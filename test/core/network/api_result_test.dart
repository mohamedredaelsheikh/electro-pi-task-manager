import 'package:flutter_test/flutter_test.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';

void main() {
  group('ApiSuccess', () {
    test('stores data correctly', () {
      const result = ApiSuccess(42);
      expect(result.data, 42);
    });

    test('isSuccess returns true', () {
      const result = ApiSuccess('hello');
      expect(result.isSuccess, isTrue);
    });
  });

  group('ApiFailure', () {
    const failure = NetworkFailure('timeout');

    test('stores failure correctly', () {
      const result = ApiFailure<int>(failure);
      expect(result.failure, failure);
    });

    test('isSuccess returns false', () {
      const result = ApiFailure<String>(failure);
      expect(result.isSuccess, isFalse);
    });
  });

  group('ApiResultX.failure', () {
    test('returns failure from ApiFailure', () {
      const f = ServerFailure('bad request', statusCode: 400);
      const result = ApiFailure<int>(f);
      expect(result.failure, f);
    });
  });

  group('ApiResultX.data', () {
    test('returns data from ApiSuccess', () {
      const result = ApiSuccess('value');
      expect(result.data, 'value');
    });
  });
}
