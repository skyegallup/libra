import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/utils/models/gemtext_node.dart';
import 'package:libra/utils/models/heading_node.dart';
import 'package:libra/utils/models/link_node.dart';
import 'package:libra/utils/models/list_node.dart';
import 'package:libra/utils/models/preformatted_text_node.dart';
import 'package:libra/utils/models/quote_node.dart';
import 'package:libra/utils/models/text_node.dart';
import 'package:test/test.dart';

void main() {
  test('parses text lines correctly', () {
    final str = 'hello world!\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str)[0];

    expect(res, TypeMatcher<TextNode>());
    expect((res as TextNode).text, 'hello world!');
  });

  test(' parses blank lines correctly', () {
    final str = '\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str)[0];

    expect(res, TypeMatcher<TextNode>());
    res as TextNode;  // Linter fixer

    expect(res.text, '');
  });

  group('linkLine', () {
    test(' parses links without labels correctly', () {
      final str = '=> gemini://geminiprotocol.net\r\n';
      var parser = GemtextParser();

      final res = parser.parse(str)[0];
      
      expect(res, TypeMatcher<LinkNode>());
      res as LinkNode;  // Linter fixer

      expect(res.uri, 'gemini://geminiprotocol.net');
      expect(res.label, null);
    });

    test(' parses links with labels correctly', () {
      final str = '=> gemini://geminiprotocol.net Label\r\n';
      var parser = GemtextParser();

      final res = parser.parse(str)[0];
      
      expect(res, TypeMatcher<LinkNode>());
      res as LinkNode;  // Linter fixer

      expect(res.uri, 'gemini://geminiprotocol.net');
      expect(res.label, 'Label');
    });
  });

  test('performattedLine parses preformatted lines correctly', () {
    final str = '```json\r\n["a", "b", "c"]\r\n```\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str)[0];
    
    expect(res, TypeMatcher<PreformattedTextNode>());
    res as PreformattedTextNode;  // Linter fixer

    expect(res.text, '["a", "b", "c"]'); 
  });

  group('headingLine', () {
    test(' parses first-level headings correctly', () {
      final str = '# Heading\r\n';
      var parser = GemtextParser();

      final res = parser.parse(str)[0];
      
      expect(res, TypeMatcher<HeadingNode>());
      res as HeadingNode;  // Linter fixer

      expect(res.level, 1);
      expect(res.text, 'Heading');
    });

    test(' parses second-level headings correctly', () {
      final str = '## Heading\r\n';
      var parser = GemtextParser();

      final res = parser.parse(str)[0];
      
      expect(res, TypeMatcher<HeadingNode>());
      res as HeadingNode;  // Linter fixer

      expect(res.level, 2);
      expect(res.text, 'Heading');
    });

    test(' parses third-level headings correctly', () {
      final str = '### Heading\r\n';
      var parser = GemtextParser();

      final res = parser.parse(str)[0];
      
      expect(res, TypeMatcher<HeadingNode>());
      res as HeadingNode;  // Linter fixer

      expect(res.level, 3);
      expect(res.text, 'Heading');
    });
  });

  test('listLine parses list lines correctly', () {
    final str = '* hello world!\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str)[0];
    
    expect(res, TypeMatcher<ListNode>());
    res as ListNode;  // Linter fixer

    expect(res.text, 'hello world!');
  });

  test('quoteLine parses quote lines correctly', () {
    final str = '> hello world!\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str)[0];
    
    expect(res, TypeMatcher<QuoteNode>());
    res as QuoteNode;  // Linter fixer

    expect(res.text, 'hello world!');
  });

  test(' parses multiple lines correctly', () {
    final str = 'hi!\r\n```json\r\n["a", "b", "c"]\r\n```\r\n';
    var parser = GemtextParser();

    final res = parser.parse(str);
    
    expect(res, TypeMatcher<List<GemtextNode>>());
    expect(res.length, 2);
    expect(res[0], TypeMatcher<TextNode>());
    expect(res[1], TypeMatcher<PreformattedTextNode>());
  });
}
