import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_response.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_spec.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
  String url = 'gemini://skyebound.gay';
  
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
            PressableBox(
              style: Style(
                $box.padding(12, 20),
                $box.color(Color.fromRGBO(29, 29, 34, 1)),
                $box.width(720)
              ),
              onPress: () => _getCurrentUrl(context),
              child: StyledText(url)
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
            // Sidebar
            Box(
              style: Style(
                $box.border.end.color.ref($tok.color.gray),
                $box.border.end.width(2),
                $box.color.ref($tok.color.grayDarker),
                $box.padding.all(16),
                $box.width(320)
              ),
              child: VBox(
                style: Style(
                  $flex.gap(8),
                  $flex.crossAxisAlignment.stretch()
                ),
                children: [
                  LibraButton(
                    style: Style(
                      ButtonSpecUtility.self.flex.mainAxisAlignment.start()
                    ),
                    variant: ButtonVariant.normal,
                    label: 'skyebound.gay',
                    onPressed: () => print('todo'),
                  ),
                  LibraButton(
                    style: Style(
                      ButtonSpecUtility.self.flex.mainAxisAlignment.start()
                    ),
                    variant: ButtonVariant.normal,
                    label: 'New tab',
                    icon: LucideIcons.plus,
                    onPressed: () => print('todo'),
                  )
                ]
              )
            ),

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

                            return VBox(
                              style: Style(
                                $flex.gap(10),
                                $flex.crossAxisAlignment.start()
                              ),
                              children: parsedResponse.value.map((node) {
                                switch (node) {
                                  case final TextNode textNode:
                                    return StyledText(textNode.text);
                                  case final LinkNode linkNode:
                                    return PressableBox(
                                      child: StyledText(
                                        linkNode.label ?? linkNode.uri,
                                        style: Style(
                                          $text.color(Color.fromRGBO(142, 183, 236, 1)),
                                          $text.fontWeight.w500()
                                        )
                                      )
                                    );
                                  case final HeadingNode headingNode:
                                    switch (headingNode.level) {
                                      case 1:
                                        return StyledText(
                                          headingNode.text,
                                          style: Style(
                                            $text.fontSize(40),
                                            $text.fontWeight.w700()
                                          )
                                        );
                                      case 2:
                                        return StyledText(
                                          headingNode.text,
                                          style: Style(
                                            $text.fontSize(26),
                                            $text.fontWeight.w700()
                                          )
                                        );
                                      case 3:
                                        return StyledText(
                                          headingNode.text,
                                          style: Style(
                                            $text.fontWeight.w700()
                                          )
                                        );
                                      default:
                                        throw Error();
                                    }
                                  case final PreformattedTextNode preNode:
                                    return StyledText(
                                      preNode.text,
                                      style: Style(
                                        $text.fontFamily('monospace')
                                      )
                                    );
                                  case final ListNode listNode:
                                    return Box(
                                      style: Style(
                                        $box.padding.left(8)
                                      ),
                                      child: StyledText('• ${listNode.text}')
                                    );
                                  case final QuoteNode quoteNode:
                                    return Box(
                                      style: Style(
                                        $box.padding.all(8),
                                        $box.border.left.width(4),
                                        $box.border.left.color(Color.fromRGBO(136, 136, 136, 1))
                                      ),
                                      child: StyledText(quoteNode.text)
                                    );
                                  default:
                                    throw Error();
                                }
                              }).toList()
                            );
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
