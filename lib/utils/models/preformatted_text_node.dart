import 'package:libra/utils/models/text_node.dart';

class PreformattedTextNode extends TextNode {
  PreformattedTextNode(super.text, this.altText);

  final String? altText;
}
