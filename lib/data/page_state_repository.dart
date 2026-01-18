import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/data/page_state.dart';
import 'package:libra/services/gemini_client.dart';
import 'package:uuid/uuid.dart';

class PageStateRepository extends ChangeNotifier {
  final List<PageState> _pageStates = [];
  late PageState _currentPageState;

  final Uuid _uuidGenerator = Uuid();
  final GeminiClient _geminiClient;

  UnmodifiableListView<PageState> get pageStates => UnmodifiableListView(_pageStates);
  PageState get currentPageState => _currentPageState;

  PageStateRepository({
    required GeminiClient geminiClient
  }) : _geminiClient = geminiClient {
    _currentPageState = openNewPage();
  }

  PageState openNewPage() {
    final newPageState = PageState(uuid: _uuidGenerator.v4());
    _pageStates.add(newPageState);
    notifyListeners();
    return newPageState;
  }

  void closePage(PageState pageState) {
    _pageStates.remove(pageState);
    notifyListeners();
  }

  void navigatePage(PageState pageState, String uri) {
    if (uri == '') 
    {
      return;
    }

    pageState.uri = uri;

    _geminiClient.get(uri).forEach((event) {
      pageState.loadingState = event.state;
      if (event.state == LoadingState.complete && event.response != null) {
        pageState.response = event.response;
      }
      notifyListeners();
    });  // not awaited - runs in the background
  }

  void switchCurrentPage(PageState newCurrentPageState) {
    if (!_pageStates.contains(newCurrentPageState)) {
      throw Exception('Page state is no longer valid.');
    }
    
    _currentPageState = newCurrentPageState;
    notifyListeners();
  }
}
