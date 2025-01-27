class StatusCode {
  /// 200 Success: The request has successfully resulted in the response and data being sent back to the client.
  static const int success = 200;

  /// 400 Bad Request: The request could not be understood by the server due to malformed syntax.
  static const int badRequest = 400;

  /// 401 Unauthorized: The request requires user authentication or, if the request has included authentication credentials, authorization has been refused for those credentials.
  static const int unauthorized = 401;

  /// 403 Forbidden: The server understood the request, but is refusing to fulfill it.
  static const int forbidden = 403;

  /// 404 Not Found: The server has not found anything matching the Request-URI.
  static const int notFound = 404;

  /// 409 Conflict: The request could not be completed due to a conflict with the current state of the resource.
  static const int conflict = 409;

  /// 500 Internal Server Error: The server encountered an unexpected condition which prevented it from fulfilling the request.
  static const int internalServerError = 500;
}
