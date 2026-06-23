import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/failures.dart';
import '../network/api_result.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
    } catch (_) {
      return const ApiFailure(UnexpectedFailure());
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
    } catch (_) {
      return const ApiFailure(UnexpectedFailure());
    }
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    required Map<String, dynamic> data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
    } catch (_) {
      return const ApiFailure(UnexpectedFailure());
    }
  }

  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkFailure('Connection timed out.');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] as String? ??
            'Server error ($statusCode).';
        return ServerFailure(message, statusCode: statusCode);
      default:
        return const UnexpectedFailure();
    }
  }
}
