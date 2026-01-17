import 'package:libra/data/gemini_response.dart';
import 'package:libra/data/loading_state.dart';

class GeminiRequestEvent {
  const GeminiRequestEvent(this.state, this.response);

  final LoadingState state;
  final GeminiResponse? response;
}
