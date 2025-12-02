import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:petitparser/petitparser.dart';

final textLine = any().starString().map((text) => TextNode(text));

final linkLine = seq3(
  string('=>'),
  whitespace().plus(),
  [
    seq3(
      any().plusLazy(whitespace()).flatten(),
      whitespace().plus(),
      any().plusString()
    ).map3((url, _, label) => LinkNode(url, label)),
    any().plusString().map((str) => LinkNode(str, null))
  ].toChoiceParser()
).map3((_, _, node) => node);

final preformattedLine = seq6(
  string('```'),
  any().plusLazy(newline()).flatten().optional(),
  newline(),
  any().plusLazy(newline().seq(string('```'))).flatten(),
  newline().seq(string('```')),
  any().starLazy(newline()).optional()
).map6((_, altText, _, text, _, _) => PreformattedTextNode(text, altText));

final headingLine = seq3(
  char('#').repeat(1, 3).map((strs) => strs.length),
  whitespace().star(),
  any().plusString()
).map3((level, _, text) => HeadingNode(level, text));

final listLine = seq3(
  char('*'),
  whitespace().star(),
  any().plusString()
).map3((_, _, text) => ListNode(text));

final quoteLine = seq3(
  char('>'),
  whitespace().star(),
  any().plusString()
).map3((_, _, text) => QuoteNode(text));

final gemtextLine = [textLine, linkLine, preformattedLine, headingLine, listLine, quoteLine].toChoiceParser();
final gemtext = gemtextLine.starSeparated(newline()).map((sepList) => sepList.elements);
