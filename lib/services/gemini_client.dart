import 'dart:convert';
import 'dart:io';

import 'package:libra/data/gemini_response.dart';

class GeminiClient {
  Future<GeminiResponse> get(String url) async {
    final uri = _getNormalizedUri(url);
    _assertUriValid(uri);

    // Send request
    final socket = await SecureSocket.connect(uri.host, uri.port, onBadCertificate: (_) => true);
    socket.encoding = utf8;
    socket.write("${uri.toString()}\r\n");
    await socket.flush();

    // Wait for response
    // TODO: Try to parse the response header before we finish reading, so that we can reject invalid responses early
    final responseBuffer = StringBuffer();
    await socket.listen(
      (List<int> data) {
        final chunk = utf8.decode(data);
        responseBuffer.write(chunk);
      }
    ).asFuture();
    await socket.close();
    final response = responseBuffer.toString();

    // Parse response
    final firstLineBreakIndex = response.indexOf('\r\n');
    if (firstLineBreakIndex == -1) {
      throw FormatException('Server response is invalid.');
    }

    final header = response.substring(0, firstLineBreakIndex);
    final content = response.substring(firstLineBreakIndex + 2);

    final statusCodeStr = header.substring(0, 2);
    final statusCodeInt = int.tryParse(statusCodeStr);
    if (statusCodeInt == null) {
      throw FormatException('Server response is invalid.');
    }
    final meta = header.substring(3);
    if (meta.length > 1024) {
      throw FormatException('Server response is invalid.');
    }
    
    return GeminiResponse(
      content: content,
      meta: meta,
      statusCodeInt: statusCodeInt
    );
  }

  void _assertUriValid(Uri uri) {
    if (uri.scheme != 'gemini') {
      throw FormatException('Only  Gemini URLs are supported.');
    }
    if (uri.userInfo != '') {
      throw FormatException('User info is not allowed in Gemini URLs.');
    }
  }

  Uri _getNormalizedUri(String url) {
    final parsedUri = Uri.parse(url);
    return Uri(
      scheme: parsedUri.hasScheme ? parsedUri.scheme : 'gemini',
      host: parsedUri.host,
      port: parsedUri.hasPort ? parsedUri.port : 1965,
      path: parsedUri.hasEmptyPath ? '/' : parsedUri.path
    );
  }
}
