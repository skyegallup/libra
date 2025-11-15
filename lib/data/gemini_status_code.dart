enum GeminiStatusCode {
  input(10),
  sensitiveInput(11),
  success(20),
  temporaryRedirect(30),
  permanentRedirect(31),
  temporaryFailure(40),
  serverUnavailable(41),
  cgiError(42),
  proxyError(43),
  slowDown(44),
  permanentFailure(50),
  notFound(51),
  gone(52),
  proxyRequestRefused(53),
  badRequest(59),
  clientCertificateRequired(60),
  certificateNotAuthorised(61),
  certificateNotValid(62);

  const GeminiStatusCode(this.statusCode);

  final int statusCode;

  static GeminiStatusCode fromInt(int statusCodeInt) {
    // Check for an exact match first
    final exactMatch  = GeminiStatusCode.values.where((x) => x.statusCode == statusCodeInt);
    if (exactMatch.isNotEmpty) {
      return exactMatch.first;
    }

    // If that fails, then fall back to the semantically closest status code
    if (statusCodeInt < 10 || statusCodeInt > 69) {
      throw FormatException('Status code is invalid.');
    }
    final firstDigit = (statusCodeInt / 10).floor();
    switch (firstDigit) {
      case 1:
        return GeminiStatusCode.input;
      case 2:
        return GeminiStatusCode.success;
      case 3:
        return GeminiStatusCode.temporaryRedirect;
      case 4:
        return GeminiStatusCode.temporaryFailure;
      case 5:
        return GeminiStatusCode.permanentFailure;
      case 6:
        return GeminiStatusCode.clientCertificateRequired;
      default:
        throw FormatException('Status code is not invalid or non-standard.');
    }
  }
}
