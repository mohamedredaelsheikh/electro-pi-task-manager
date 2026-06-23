import '../error/failures.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}

extension ApiResultX<T> on ApiResult<T> {
  bool get isSuccess => this is ApiSuccess<T>;
  T get data => (this as ApiSuccess<T>).data;
  Failure get failure => (this as ApiFailure<T>).failure;
}
