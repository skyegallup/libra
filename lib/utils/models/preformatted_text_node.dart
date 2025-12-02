import 'package:libra/utils/models/gemtext_node.dart';

class PreformattedTextNode extends GemtextNode {
  PreformattedTextNode(this.text, this.altText);

  final String? altText;
  final String text;
}
