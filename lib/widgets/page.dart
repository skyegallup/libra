import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/data/page_state.dart';
import 'package:libra/data/page_state_repository.dart';
import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/widgets/gemtext_renderer/gemtext_renderer.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';

class LibraPage extends StatelessWidget {
  LibraPage({
    super.key,
    required this.pageState
  });

  final PageState pageState;
  final GemtextParser _parser = GemtextParser();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(  // TODO: Try using a ListView of text items instead?
        child: HBox(
          style: Style(
            $flex.mainAxisAlignment.center()
          ),
          children: [
            Box(
              style: Style(
                $box.maxWidth(720),
                $box.padding.vertical(24)
              ),
              child: _buildDisplayedContent(context)
            )
          ]
        )
      )
    );
  }

  Widget _buildDisplayedContent(BuildContext context) {
    switch (pageState.loadingState) {
      case (LoadingState.idle):
        return StyledText('Request not yet sent.');
      case (LoadingState.connecting):
      case (LoadingState.dataTransfer):
        return StyledText('Waiting...');
      case (LoadingState.complete):
        if (pageState.response?.content != null) {
          var content = pageState.response!.content!;

          final parsedResponse = _parser.parse(content);
          return GemtextRenderer(
            nodes: UnmodifiableListView(parsedResponse),
            onNavigate: (uri) {
              final repo = Provider.of<PageStateRepository>(context, listen: false);
              repo.navigatePage(pageState, uri);
            },
          );
        } else {
          return StyledText('<no content>');
        }
    }
  }
}
