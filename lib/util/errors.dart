class AjusteeError implements Exception {
  final String message;
  AjusteeError(this.message);

  @override
  String toString() => 'Ajustee Error: $message';
}

class BadRequest extends AjusteeError {
  BadRequest([String message = 'Not Found']) : super(message);
}

class AccessForbidden extends AjusteeError {
  AccessForbidden() : super('Access Forbidden');
}

class NotFound extends AjusteeError {
  NotFound(String message) : super(message);
}

class PaymentRequired extends AjusteeError {
  PaymentRequired() : super('Payment Required');
}

class ServerError extends AjusteeError {
  ServerError() : super('Server Error');
}

class HttpConnectionError extends AjusteeError {
  HttpConnectionError() : super('Http Connection Error');
}

class SocketConnectionError extends AjusteeError {
  SocketConnectionError() : super('Socket Connection Error');
}

class ReservedPropertyName extends AjusteeError {
  ReservedPropertyName(String name) : super('Reserved Property Name: $name');
}
