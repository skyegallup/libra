import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_request_event.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:libra/widgets/loading_bar.dart';
import 'package:libra/widgets/page.dart';
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
                  onSubmitted: (value) => navigate(context, value)
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
            LibraPage(
              requestEventStream: _response,
              pageLoadingState: pageLoadingState,
              onNavigate: (uri) => navigate(context, uri),
              onLoadingStateChange: (LoadingState state) {
                setState(() {
                  pageLoadingState = state;
                  showLoadingBar = state != LoadingState.complete;
                });
              },
            )
          ]
        )
      ]
    );
  }

  void navigate(BuildContext context, String uri) {
    _setUrl(uri);
    _getCurrentUrl(context);
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
      _urlController.text = url;
    });
  }
}
