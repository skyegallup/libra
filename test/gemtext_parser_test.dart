import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

void main() {
  test('Text line is parsed correctly', () {
    final str = 'hello world!';
    final res = textLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<TextNode>());
    expect(res.value.text, str);
  });

  test('Blank line is parsed correctly', () {
    final str = '';
    final res = textLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<TextNode>());
    expect(res.value.text, str);
  });

  test('Link line without label is parsed correctly', () {
    final str = '=> gemini://geminiprotocol.net';
    final res = linkLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<LinkNode>());
    expect(res.value.uri, 'gemini://geminiprotocol.net');
    expect(res.value.label, null);
  });

  test('Link line with label is parsed correctly', () {
    final str = '=> gemini://geminiprotocol.net Label';
    final res = linkLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<LinkNode>());
    expect(res.value.uri, 'gemini://geminiprotocol.net');
    expect(res.value.label, 'Label');
  });

  test('Preformatted lines are parsed correctly', () {
    final str = '```json\r\n["a", "b", "c"]\r\n```';
    final res = preformattedLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<PreformattedTextNode>());
    expect(res.value.text, '["a", "b", "c"]'); 
  });

  test('First-level heading is parsed correctly', () {
    final str = '# Heading';
    final res = headingLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<HeadingNode>());
    expect(res.value.level, 1);
    expect(res.value.text, 'Heading');
  });

  test('Second-level heading is parsed correctly', () {
    final str = '## Heading';
    final res = headingLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<HeadingNode>());
    expect(res.value.level, 2);
    expect(res.value.text, 'Heading');
  });

  test('Third-level heading is parsed correctly', () {
    final str = '### Heading';
    final res = headingLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<HeadingNode>());
    expect(res.value.level, 3);
    expect(res.value.text, 'Heading');
  });

  test('List line is parsed correctly', () {
    final str = '* hello world!';
    final res = listLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<ListNode>());
    expect(res.value.text, 'hello world!');
  });

  test('Quote line is parsed correctly', () {
    final str = '> hello world!';
    final res = quoteLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<QuoteNode>());
    expect(res.value.text, 'hello world!');
  });
}
