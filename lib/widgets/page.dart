import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:libra/data/gemini_response.dart';
import 'package:libra/data/gemini_status_code.dart';
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
        return _buildDisplayedContentForRespones(context, pageState.response!);
    }
  }

  Widget _buildDisplayedContentForRespones(BuildContext context, GeminiResponse res) {
    switch (res.statusCode) {
      // 10 code block
      case (GeminiStatusCode.input):
      case (GeminiStatusCode.sensitiveInput):
        throw Exception('Not yet supported.');

      // 20 code block
      case (GeminiStatusCode.success):
        var content = pageState.response!.content!;
        final parsedResponse = _parser.parse(content);
        return GemtextRenderer(
          nodes: UnmodifiableListView(parsedResponse),
          onNavigate: (uri) {
            final repo = Provider.of<PageStateRepository>(context, listen: false);
            repo.navigatePage(pageState, uri);
          },
        );

      // 30 code block
      case (GeminiStatusCode.temporaryRedirect):
      case (GeminiStatusCode.permanentRedirect):  // TODO: Handle permanent redirects differently?
        // TODO: Move redirects into GeminiClient??
        final repo = Provider.of<PageStateRepository>(context, listen: false);
        repo.navigatePage(pageState, res.meta);
        return StyledText('Redirecting...');

      // 40 code block
      case (GeminiStatusCode.temporaryFailure):
        return StyledText(res.meta.isNotEmpty ? res.meta : '40 Temporary Failure: There was a temporary server error when processing your request.');
      case (GeminiStatusCode.serverUnavailable):
        return StyledText(res.meta.isNotEmpty ? res.meta : '41 Server Unavailable: The server is not available due to overload or maintenance.');
      case (GeminiStatusCode.cgiError):
        return StyledText(res.meta.isNotEmpty ? res.meta : '42 CGI Error: There was a temporary CGI error or timeout when processing your request.');
      case (GeminiStatusCode.proxyError):
        return StyledText(res.meta.isNotEmpty ? res.meta : '43 Proxy Error: There was a temporary proxy error when processing your request.');
      case (GeminiStatusCode.slowDown):
        return StyledText(res.meta.isNotEmpty ? res.meta : '44 Slow Down: You are sending requests too fast; please wait before trying again.');

      // 50 code block
      case (GeminiStatusCode.permanentFailure):
        return StyledText(res.meta.isNotEmpty ? res.meta : '50 Permanent Failure: There was a permanent error when processing your request.');
      case (GeminiStatusCode.notFound):
        return StyledText(res.meta.isNotEmpty ? res.meta : '51 Not Found: The requested document could not be found.');
      case (GeminiStatusCode.gone):
        return StyledText(res.meta.isNotEmpty ? res.meta : '52 Gone: The requested document was removed and is no longer available.');
      case (GeminiStatusCode.proxyRequestRefused):
        return StyledText(res.meta.isNotEmpty ? res.meta : '53 Proxy Request Refused: The request was for a resource at another domain, but the server does not accept proxy requests.');
      case (GeminiStatusCode.badRequest):
        return StyledText(res.meta.isNotEmpty ? res.meta : '59 Bad Request: The server was unable to process your request.');

      // 60 code block
      case (GeminiStatusCode.clientCertificateRequired):
      case (GeminiStatusCode.certificateNotAuthorised):
      case (GeminiStatusCode.certificateNotValid):
        throw Exception('Not yet supported.');
    }
  }
}
