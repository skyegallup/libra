import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/utils/models/gemtext_node.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:mix/mix.dart';

class GemtextRenderer extends StatelessWidget {
  const GemtextRenderer({super.key, required this.nodes});

  final UnmodifiableListView<GemtextNode> nodes;

  @override
  Widget build(BuildContext context) {
    return VBox(
      style: Style(
        $flex.gap(10),
        $flex.crossAxisAlignment.start()
      ),
      children: nodes.map((node) => _mapNodeToWidget(node)).toList()
    );
  }

  Widget _mapNodeToWidget(GemtextNode node) {
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
  }
}