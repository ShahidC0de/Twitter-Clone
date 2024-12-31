class AppwriteConstants {
  static const String databaseId = '677133b20014ff747f62';
  static const String projectId = '67702c62002f9bd90a18';
  static const String endPoint = 'http://localhost:80';
  static const Map<int, String> errorCodesAndTheirMessages = {
    400: " general_argument_invalid",
    401:
        "general_argument_invalid or authentication is required and has failed or not been provided.",
    404: "the requested resource does not exist.",
    409:
        "the request could not be completed due to a conflict with the current state of the target resource.",
    503: "429:	 the user has sent too many requests in a given amount of time.",
    429:
        "429	general_rate_limit_exceeded	Too many requests; the user has sent too many requests in a given amount of time.",
  };
}
