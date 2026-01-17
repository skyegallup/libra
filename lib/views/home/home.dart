import 'dart:async';
import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_request_event.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:libra/widgets/gemtext_renderer/gemtext_renderer.dart';
import 'package:libra/widgets/loading_bar.dart';
import 'package:libra/widgets/sidebar/sidebar.dart';
import 'package:libra/widgets/text_field/text_field.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<GeminiRequestEvent>? _response;
  String url = '';
  final TextEditingController _urlController = TextEditingController();
  LoadingState pageLoadingState = LoadingState.idle;
  bool showLoadingBar = true;

  Map<LoadingState, double> loadingStateToLoadingBarMap = {
    LoadingState.idle:         0.00,
    LoadingState.connecting:   0.15,
    LoadingState.dataTransfer: 0.30,
    LoadingState.complete:     1.00
  };

  @override
  Widget build(BuildContext context) {
    // Build view
    return VBox(
      style: Style(
        $box.color(Color.fromRGBO(29, 29, 34, 1)),
        $flex.crossAxisAlignment.stretch(),
        $flex.mainAxisSize.max()
      ),
      children: [
        // Action bar
        VBox(
          children: [
            // Action bar items
            HBox(
              style: Style(
                $box.padding(12, 24),
                $box.color.ref($tok.color.primary),

                $flex.mainAxisAlignment.center(),
                $flex.crossAxisAlignment.center(),
                $flex.gap(8)
              ),
              children: [
                LibraButton(
                  variant: ButtonVariant.primary,
                  label: '',
                  icon: LucideIcons.refreshCw,
                  onPressed: () => _getCurrentUrl(context),
                ),
                LibraTextField(
                  defaultValue: url,
                  controller: _urlController,
                  style: Style(
                    TextFieldSpecUtility.self.container.color.ref($tok.color.primaryDark),
                    TextFieldSpecUtility.self.container.width(720)
                  ),
                  onSubmitted: (value) {
                    _setUrl(value);
                    _getCurrentUrl(context);
                  }
                )
              ]
            ),

            LibraLoadingBar(
              fillAmount: loadingStateToLoadingBarMap[pageLoadingState] ?? 0.0,
              show: showLoadingBar,
            )
          ]
        ),

        // Main section
        HBox(
          style: Style(
            $flex.crossAxisAlignment.stretch(),
            $with.expanded()
          ),
          children: [
            Sidebar(),

            // Content
            Expanded(
              child: SingleChildScrollView(  // TODO: Try using a ListView of text items instead?
                child: HBox(
                  style: Style(
                    $flex.mainAxisAlignment.center()
                  ),
                  children: [
                    Box(
                      style: Style(
                        $box.maxWidth(720),
                        $box.padding.vertical(24)
                      ),
                      child: StreamBuilder<GeminiRequestEvent>(
                        stream: _response,
                        builder: (BuildContext context, AsyncSnapshot<GeminiRequestEvent> snapshot) {
                          if (snapshot.connectionState == ConnectionState.none) {
                            return StyledText('Request not yet sent.');
                          }

                          if (snapshot.hasData) {
                            final data = snapshot.data!;
                            if (data.state != pageLoadingState) {
                              SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
                                setState(() {
                                  pageLoadingState = data.state;
                                  showLoadingBar = data.state != LoadingState.complete;
                                });
                              });
                            }

                            if (data.state == LoadingState.idle) {
                              return StyledText('Request not yet sent.');
                            } else if (data.state == LoadingState.complete) {
                              final response = data.response!;

                              if (response.content == null) {
                                return StyledText('<no content>');
                              }
                              var content = response.content!;
                              
                              var parser = GemtextParser();
                              final parsedResponse = parser.parse(content);
                              return GemtextRenderer(
                                nodes: UnmodifiableListView(parsedResponse),
                                onNavigate: (uri) {
                                  _setUrl(uri);
                                  _getCurrentUrl(context);
                                },
                              );
                            }
                          }

                          if (snapshot.hasError) {
                            return StyledText('Request failed.');
                          }

                          return StyledText('Waiting...');
                        },
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      ]
    );
  }

  void _getCurrentUrl(BuildContext context) {
    if (url == '') {
      return;
    }

    setState(() {
      showLoadingBar = true;
      _response = Provider.of<GeminiClient>(context, listen: false).get(url);
    });
  }

  void _setUrl(String url) {
    setState(() {
      this.url = url;
      this._urlController.text = url;
    });
  }
}
