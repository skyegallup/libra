import 'package:libra/data/gemini_response.dart';
import 'package:libra/data/loading_state.dart';

class PageState {
  PageState({
    required this.uuid,
    this.uri = '',
    this.response,
    this.loadingState = LoadingState.idle
  });

  String uuid;
  String uri;
  GeminiResponse? response;
  LoadingState loadingState;
}
