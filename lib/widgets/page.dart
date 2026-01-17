import 'dart:async';
import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_request_event.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/utils/gemtext_parser.dart';
import 'package:libra/widgets/gemtext_renderer/gemtext_renderer.dart';
import 'package:mix/mix.dart';

class LibraPage extends StatelessWidget {
  const LibraPage({
    super.key,
    required this.requestEventStream,
    required this.pageLoadingState,
    required this.onNavigate,
    required this.onLoadingStateChange
  });

  final Stream<GeminiRequestEvent>? requestEventStream;
  final LoadingState pageLoadingState;
  final Function(String uri) onNavigate;
  final Function(LoadingState state) onLoadingStateChange;

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
              child: StreamBuilder<GeminiRequestEvent>(
                stream: requestEventStream,
                builder: (BuildContext context, AsyncSnapshot<GeminiRequestEvent> snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return StyledText('Request not yet sent.');
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.state != pageLoadingState) {
                      SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) => onLoadingStateChange(data.state));
                    }

                    if (data.state == LoadingState.idle) {
                      return StyledText('Request not yet sent.');
                    } else if (data.state == LoadingState.complete) {
                      final response = data.response!;

                      if (response.content == null) {
                        return StyledText('<no content>');
                      }
                      var content = response.content!;
                      
                      var parser = GemtextParser();
                      final parsedResponse = parser.parse(content);
                      return GemtextRenderer(
                        nodes: UnmodifiableListView(parsedResponse),
                        onNavigate: onNavigate,
                      );
                    }
                  }

                  if (snapshot.hasError) {
                    return StyledText('Request failed.');
                  }

                  return StyledText('Waiting...');
                },
              )
            )
          ]
        )
      )
    );
  }
}
