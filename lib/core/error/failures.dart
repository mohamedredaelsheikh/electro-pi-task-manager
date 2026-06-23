sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Check your connection.']);
}

final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
