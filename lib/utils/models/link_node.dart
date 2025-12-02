import 'package:libra/utils/models/gemtext_node.dart';

class LinkNode extends GemtextNode {
  LinkNode(this.uri, this.label);

  final String uri;

  final String? label;
}
