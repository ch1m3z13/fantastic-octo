import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/driver_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'auth_api_service.dart'; // For ApiException

/// Service for handling driver-related API calls
class DriverApiService {
  final ApiClient _apiClient = ApiClient();
  final _logger = Logger();

  /// Get driver statistics
  Future<DriverStats> getDriverStats(String driverId) async {
    try {
      _logger.i('Fetching stats for driver: $driverId');

      final response = await _apiClient.get(
        ApiConfig.driverStatsEndpoint,
      );

      if (response.statusCode == 200 && response.data != null) {
        _logger.i('Driver stats retrieved successfully');
        return DriverStats.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to get driver stats with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get driver stats error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get driver stats error: $e');
      throw ApiException('An unexpected error occurred while fetching driver stats');
    }
  }

  /// Get active route manifest
  Future<ActiveManifest> getActiveManifest(String driverId) async {
    try {
      _logger.i('Fetching active manifest for driver: $driverId');

      final response = await _apiClient.get(
        ApiConfig.driverManifestEndpoint,
      );

      if (response.statusCode == 200 && response.data != null) {
        _logger.i('Active manifest retrieved successfully');
        return ActiveManifest.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to get active manifest with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get active manifest error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get active manifest error: $e');
      throw ApiException('An unexpected error occurred while fetching manifest');
    }
  }

  /// Update driver status
  Future<StatusUpdateResponse> updateDriverStatus(
    String driverId,
    DriverStatus status,
  ) async {
    try {
      _logger.i('Updating driver status to: ${status.value}');

      final request = StatusUpdateRequest(status: status.value);

      final response = await _apiClient.post(
        ApiConfig.driverStatusEndpoint,
        data: request.toJson(),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        _logger.i('Driver status updated successfully');
        return StatusUpdateResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to update status with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Update driver status error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected update driver status error: $e');
      throw ApiException('An unexpected error occurred while updating status');
    }
  }

  /// Handle Dio errors and convert to ApiException
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ??
            error.response?.data?['error'] ??
            'An error occurred';

        if (statusCode == 404) {
          return ApiException('No data found', statusCode: 404);
        }

        return ApiException(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection. Please check your network settings.',
        );

      default:
        return ApiException(
          'An unexpected error occurred: ${error.message}',
        );
    }
  }
}