import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/utils/models/gemtext_node.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

void main() {
  group('textLine', () {
    test(' parses text lines correctly', () {
      final str = 'hello world!\r\n';
      final res = textLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<TextNode>());
      expect(res.value.text, 'hello world!');
    });

    test(' parses blank lines correctly', () {
      final str = '\r\n';
      final res = textLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<TextNode>());
      expect(res.value.text, '');
    });
  });
  
  group('linkLine', () {
    test(' parses links without labels correctly', () {
      final str = '=> gemini://geminiprotocol.net\r\n';
      final res = linkLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<LinkNode>());
      expect(res.value.uri, 'gemini://geminiprotocol.net');
      expect(res.value.label, null);
    });

    test(' parses links with labels correctly', () {
      final str = '=> gemini://geminiprotocol.net Label\r\n';
      //final res = trace(linkLine).parse(str);
      final res = linkLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<LinkNode>());
      expect(res.value.uri, 'gemini://geminiprotocol.net');
      expect(res.value.label, 'Label');
    });
  });

  test('performattedLine parses preformatted lines correctly', () {
    final str = '```json\r\n["a", "b", "c"]\r\n```\r\n';
    final res = preformattedLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<PreformattedTextNode>());
    expect(res.value.text, '["a", "b", "c"]'); 
  });

  group('headingLine', () {
    test(' parses first-level headings correctly', () {
      final str = '# Heading\r\n';
      final res = headingLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<HeadingNode>());
      expect(res.value.level, 1);
      expect(res.value.text, 'Heading');
    });

    test(' parses second-level headings correctly', () {
      final str = '## Heading\r\n';
      final res = headingLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<HeadingNode>());
      expect(res.value.level, 2);
      expect(res.value.text, 'Heading');
    });

    test(' parses third-level headings correctly', () {
      final str = '### Heading\r\n';
      final res = headingLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<HeadingNode>());
      expect(res.value.level, 3);
      expect(res.value.text, 'Heading');
    });
  });

  test('listLine parses list lines correctly', () {
    final str = '* hello world!\r\n';
    final res = listLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<ListNode>());
    expect(res.value.text, 'hello world!');
  });

  test('quoteLine parses quote lines correctly', () {
    final str = '> hello world!\r\n';
    final res = quoteLine.parse(str);

    expect(res, TypeMatcher<Success>());
    expect(res.value, TypeMatcher<QuoteNode>());
    expect(res.value.text, 'hello world!');
  });

  group('gemtextLine', () {
    test(' selects text lines correctly', () {
      final str = 'hello world!\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<TextNode>());
    });

    test(' selects link lines correctly', () {
      final str = '=> gemini://geminiprotocol.net\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<LinkNode>());
    });

    test(' selects preformatted text lines correctly', () {
      final str = '```json\r\n["a", "b", "c"]\r\n```\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<PreformattedTextNode>());
    });

    test(' selects heading lines correctly', () {
      final str = '# Heading\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<HeadingNode>());
    });

    test(' selects list lines correctly', () {
      final str = '* hello world!\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<ListNode>());
    });

    test(' selects quote nodes correctly', () {
      final str = '> hello world!\r\n';
      final res = gemtextLine.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<QuoteNode>());
    });
  });

  group('gemtext', () {
    test(' parses a single line correctly', () {
      final str = 'hi!\r\n';
      final res = gemtext.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<List<GemtextNode>>());
      expect(res.value.length, 1);
      expect(res.value[0], TypeMatcher<TextNode>());
    });

    test(' parses multiple lines correctly', () {
      final str = 'hi!\r\n```json\r\n["a", "b", "c"]\r\n```\r\n';
      final res = gemtext.parse(str);

      expect(res, TypeMatcher<Success>());
      expect(res.value, TypeMatcher<List<GemtextNode>>());
      expect(res.value.length, 2);
      expect(res.value[0], TypeMatcher<TextNode>());
      expect(res.value[1], TypeMatcher<PreformattedTextNode>());
    });
  });
}
