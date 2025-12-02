import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:petitparser/petitparser.dart';


// Reference: gemini://geminiprotocol.net/docs/gemtext-specification.gmi


final textLine = seq2(
  any().starLazy(newline()).flatten(),
  newline()
).map2((text, _) => TextNode(text));

final linkLine = seq5(
  string('=>'),
  whitespace().plus(),
  any().plusLazy(whitespace()).flatten(),
  seq3(
    whitespace().plus(),
    any().plusLazy(newline()).flatten(),
    whitespace().plusLazy(newline())
  ).map3((_, label, _) => label.trim()).optional(),
  newline()
).map5((_, _, uri, label, _) => LinkNode(uri, label));

final preformattedLine = seq7(
  string('```'),
  any().plusLazy(newline()).flatten().optional(),
  newline(),
  any().plusLazy(newline().seq(string('```'))).flatten(),
  newline().seq(string('```')),
  any().starLazy(newline()).optional(),
  newline()
).map7((_, altText, _, text, _, _, _) => PreformattedTextNode(text, altText));

final headingLine = seq4(
  char('#').repeat(1, 3).map((strs) => strs.length),
  whitespace().star(),
  any().starLazy(newline()).flatten(),
  newline()
).map4((level, _, text, _) => HeadingNode(level, text));

final listLine = seq4(
  char('*'),
  whitespace().star(),
  any().starLazy(newline()).flatten(),
  newline()
).map4((_, _, text, _) => ListNode(text));

final quoteLine = seq4(
  char('>'),
  whitespace().star(),
  any().starLazy(newline()).flatten(),
  newline()
).map4((_, _, text, _) => QuoteNode(text));

final gemtextLine = [linkLine, preformattedLine, headingLine, listLine, quoteLine, textLine].toChoiceParser();
final gemtext = gemtextLine.star();
