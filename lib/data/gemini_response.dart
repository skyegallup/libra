import 'package:libra/data/gemini_status_code.dart';

class GeminiResponse {
  GeminiResponse({ required this.content, required this.meta, required this.statusCodeInt })
    : statusCode = GeminiStatusCode.fromInt(statusCodeInt);

  final String? content;
  final String meta;
  final GeminiStatusCode statusCode;
  final int statusCodeInt;

  bool get isSuccess => statusCode == GeminiStatusCode.success
    || statusCode == GeminiStatusCode.input 
    || statusCode == GeminiStatusCode.sensitiveInput;
}
