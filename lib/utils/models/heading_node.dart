import 'package:libra/utils/models/gemtext_node.dart';

class HeadingNode extends GemtextNode {
  HeadingNode(this.level, this.text);

  final int level;  // between 1 and 3, inclusive
  final String text;
}