import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_response.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/widgets/gemtext_renderer/gemtext_renderer.dart';
import 'package:libra/widgets/sidebar/sidebar.dart';
import 'package:libra/widgets/text_field/text_field.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:mix/mix.dart';
import 'package:petitparser/petitparser.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<GeminiResponse>? _response;
  String url = 'gemini://skyebound.gay/posts/an-introduction.gmi';
  
  @override
  Widget build(BuildContext context) {
    return VBox(
      style: Style(
        $box.color(Color.fromRGBO(29, 29, 34, 1)),
        $flex.crossAxisAlignment.stretch(),
        $flex.mainAxisSize.max()
      ),
      children: [
        // Action bar
        HBox(
          style: Style(
            $box.padding(16, 24),
            $box.color(Color.fromRGBO(17, 17, 21, 1)),
            $flex.mainAxisAlignment.center(),
            $flex.crossAxisAlignment.center()
          ),
          children: [
            //PressableBox(
            //  style: Style(
            //    $box.padding(12, 20),
            //    $box.color(Color.fromRGBO(29, 29, 34, 1)),
            //    $box.width(720)
            //  ),
            //  onPress: () => _getCurrentUrl(context),
            //  child: StyledText(url)
            //)
            LibraTextField(
              style: Style(
                TextFieldSpecUtility.self.container.width(720)
              ),
              onSubmitted: (value) {
                setState(() {
                  url = value;
                });
                _getCurrentUrl(context);
              }
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
                      child: FutureBuilder<GeminiResponse>(
                        future: _response,
                        builder: (BuildContext context, AsyncSnapshot<GeminiResponse> snapshot) {
                          if (snapshot.connectionState == ConnectionState.none) {
                            return StyledText('Request not yet sent.');
                          }

                          if (snapshot.hasData) {
                            if (snapshot.data!.content == null) {
                              return StyledText('<no content>');
                            }

                            var content = snapshot.data!.content!;
                            if (!content.endsWith('\r\n')) {
                              content += '\r\n';
                            }
                            final parsedResponse = gemtext.parse(content);
                            if (parsedResponse is Failure) {
                              print(parsedResponse);
                              return StyledText('<failed to parse context>');
                            }

                            return GemtextRenderer(nodes: UnmodifiableListView(parsedResponse.value));
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
    setState(() {
      print('sending req...');
      _response = Provider.of<GeminiClient>(context, listen: false).get(url);
    });
  }
}
