import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/profile/data/repositories/profile_repository_impl.dart';

import '../../../helpers/mocks.dart';

void main() {
  late ProfileRepositoryImpl repo;
  late MockTokenStorage mockStorage;

  setUp(() {
    mockStorage = MockTokenStorage();
    repo = ProfileRepositoryImpl(mockStorage);
  });

  test('returns User when all fields are present', () {
    when(() => mockStorage.getUserId()).thenReturn(1);
    when(() => mockStorage.getUserName()).thenReturn('Alice');
    when(() => mockStorage.getUserEmail()).thenReturn('alice@x.com');

    final result = repo.getProfile();

    expect(result.isSuccess, isTrue);
    expect(result.data.id, 1);
    expect(result.data.name, 'Alice');
    expect(result.data.email, 'alice@x.com');
  });

  test('returns CacheFailure when id is null', () {
    when(() => mockStorage.getUserId()).thenReturn(null);
    when(() => mockStorage.getUserName()).thenReturn('Alice');
    when(() => mockStorage.getUserEmail()).thenReturn('alice@x.com');

    final result = repo.getProfile();

    expect(result.isSuccess, isFalse);
    expect(result.failure, isA<CacheFailure>());
  });

  test('returns CacheFailure when name is null', () {
    when(() => mockStorage.getUserId()).thenReturn(1);
    when(() => mockStorage.getUserName()).thenReturn(null);
    when(() => mockStorage.getUserEmail()).thenReturn('alice@x.com');

    final result = repo.getProfile();

    expect(result.isSuccess, isFalse);
  });

  test('returns CacheFailure when email is null', () {
    when(() => mockStorage.getUserId()).thenReturn(1);
    when(() => mockStorage.getUserName()).thenReturn('Alice');
    when(() => mockStorage.getUserEmail()).thenReturn(null);

    final result = repo.getProfile();

    expect(result.isSuccess, isFalse);
  });
}
