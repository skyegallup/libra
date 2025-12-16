import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/utils/models/gemtext_node.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
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
        return StyledText(
          textNode.text,
          style: Style(
            $text.color.ref($tok.color.white),
            $text.style.ref($tok.textStyle.body)
          )
        );
      case final LinkNode linkNode:
        return PressableBox(
          child: StyledText(
            linkNode.label ?? linkNode.uri,
            style: Style(
              $text.color.ref($tok.color.primaryLighter),
              $text.style.ref($tok.textStyle.body)
            )
          )
        );
      case final HeadingNode headingNode:
        switch (headingNode.level) {
          case 1:
            return StyledText(
              headingNode.text,
              style: Style(
                $text.color.ref($tok.color.white),
                $text.style.ref($tok.textStyle.heading1)
              )
            );
          case 2:
            return StyledText(
              headingNode.text,
              style: Style(
                $text.color.ref($tok.color.white),
                $text.style.ref($tok.textStyle.heading2)
              )
            );
          case 3:
            return StyledText(
              headingNode.text,
              style: Style(
                $text.color.ref($tok.color.white),
                $text.style.ref($tok.textStyle.heading3)
              )
            );
          default:
            throw Error();
        }
      case final PreformattedTextNode preNode:
        return StyledText(
          preNode.text,
          style: Style(
            $text.color.ref($tok.color.white),
            $text.style.ref($tok.textStyle.body)  // TODO: Add pre text style
          )
        );
      case final ListNode listNode:
        return Box(
          style: Style(
            $text.color.ref($tok.color.white),
            $box.padding.left(8)
          ),
          child: StyledText(
            '• ${listNode.text}',
            style: Style(
              $text.color.ref($tok.color.white),
              $text.style.ref($tok.textStyle.body)
            )
          )
        );
      case final QuoteNode quoteNode:
        return Box(
          style: Style(
            $box.padding.all(8),
            $box.border.left.width(4),
            $box.border.left.color.ref($tok.color.primaryLighter)
          ),
          child: StyledText(
            quoteNode.text,
            style: Style(
              $text.color.ref($tok.color.white),
              $text.style.ref($tok.textStyle.quote)
            )
          )
        );
      default:
        throw Error();
    }
  }
}