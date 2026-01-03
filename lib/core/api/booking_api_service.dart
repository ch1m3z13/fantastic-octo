import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/booking_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'auth_api_service.dart'; // For ApiException

/// Service for handling booking API calls
class BookingApiService {
  final ApiClient _apiClient = ApiClient();
  final _logger = Logger();

  /// Create a new booking
  Future<BookingResponse> createBooking(CreateBookingRequest request) async {
    try {
      _logger.i('Creating booking for rider: ${request.riderId}');

      final response = await _apiClient.post(
        ApiConfig.bookingsEndpoint,
        data: request.toJson(),
      );

      // ✅ Accept both 200 OK and 201 Created as success
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data != null) {
        _logger.i('Booking created successfully');
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to create booking with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Create booking error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected create booking error: $e');
      throw ApiException('An unexpected error occurred while creating booking');
    }
  }

  /// Get booking details by ID
  Future<BookingResponse> getBooking(String bookingId) async {
    try {
      _logger.i('Fetching booking: $bookingId');

      final response = await _apiClient.get(
        '${ApiConfig.bookingsEndpoint}/$bookingId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to get booking with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get booking error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get booking error: $e');
      throw ApiException('An unexpected error occurred while fetching booking');
    }
  }

  /// Get rider's booking history
  Future<List<BookingResponse>> getRiderBookings(String riderId) async {
    try {
      _logger.i('Fetching bookings for rider: $riderId');

      final response = await _apiClient.get(
        '${ApiConfig.bookingsEndpoint}/rider/$riderId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to get rider bookings with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get rider bookings error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get rider bookings error: $e');
      throw ApiException(
        'An unexpected error occurred while fetching rider bookings',
      );
    }
  }

  /// Get driver's pending booking requests
  Future<List<BookingResponse>> getDriverPendingBookings(
    String driverId,
  ) async {
    try {
      _logger.i('Fetching pending bookings for driver: $driverId');

      final response = await _apiClient.get(
        '${ApiConfig.bookingsEndpoint}/driver/$driverId/pending',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to get driver bookings with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get driver pending bookings error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get driver pending bookings error: $e');
      throw ApiException(
        'An unexpected error occurred while fetching driver bookings',
      );
    }
  }

  /// Get active bookings for a route
  Future<List<BookingResponse>> getRouteActiveBookings(String routeId) async {
    try {
      _logger.i('Fetching active bookings for route: $routeId');

      final response = await _apiClient.get(
        '${ApiConfig.bookingsEndpoint}/route/$routeId/active',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to get route bookings with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get route active bookings error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get route active bookings error: $e');
      throw ApiException(
        'An unexpected error occurred while fetching route bookings',
      );
    }
  }

  /// Confirm a booking (driver action)
  Future<BookingResponse> confirmBooking(String bookingId) async {
    try {
      _logger.i('Confirming booking: $bookingId');

      final response = await _apiClient.post(
        '${ApiConfig.bookingsEndpoint}/$bookingId/confirm',
      );

      // ✅ Accept both 200 and 201 for POST operations
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data != null) {
        _logger.i('Booking confirmed successfully');
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to confirm booking with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Confirm booking error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected confirm booking error: $e');
      throw ApiException('An unexpected error occurred while confirming booking');
    }
  }

  /// Start a ride (driver picks up passenger)
  Future<BookingResponse> startRide(String bookingId) async {
    try {
      _logger.i('Starting ride: $bookingId');

      final response = await _apiClient.post(
        '${ApiConfig.bookingsEndpoint}/$bookingId/start',
      );

      // ✅ Accept both 200 and 201 for POST operations
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data != null) {
        _logger.i('Ride started successfully');
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to start ride with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Start ride error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected start ride error: $e');
      throw ApiException('An unexpected error occurred while starting ride');
    }
  }

  /// Complete a ride (driver drops off passenger)
  Future<BookingResponse> completeRide(String bookingId) async {
    try {
      _logger.i('Completing ride: $bookingId');

      final response = await _apiClient.post(
        '${ApiConfig.bookingsEndpoint}/$bookingId/complete',
      );

      // ✅ Accept both 200 and 201 for POST operations
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data != null) {
        _logger.i('Ride completed successfully');
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to complete ride with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Complete ride error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected complete ride error: $e');
      throw ApiException('An unexpected error occurred while completing ride');
    }
  }

  /// Cancel a booking
  Future<BookingResponse> cancelBooking(
    String bookingId,
    String reason,
  ) async {
    try {
      _logger.i('Cancelling booking: $bookingId');

      final request = CancelBookingRequest(reason: reason);

      final response = await _apiClient.post(
        '${ApiConfig.bookingsEndpoint}/$bookingId/cancel',
        data: request.toJson(),
      );

      // ✅ Accept both 200 and 201 for POST operations
      if ((response.statusCode == 200 || response.statusCode == 201) && 
          response.data != null) {
        _logger.i('Booking cancelled successfully');
        return BookingResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to cancel booking with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Cancel booking error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected cancel booking error: $e');
      throw ApiException('An unexpected error occurred while cancelling booking');
    }
  }

  /// Rate a completed ride
  Future<void> rateRide(String bookingId, int rating, String? feedback) async {
    try {
      _logger.i('Rating ride: $bookingId with rating: $rating');

      final request = RatingRequest(rating: rating, feedback: feedback);

      final response = await _apiClient.post(
        '${ApiConfig.bookingsEndpoint}/$bookingId/rate',
        data: request.toJson(),
      );

      // ✅ Accept both 200 and 201 for POST operations
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('Ride rated successfully');
      } else {
        throw ApiException(
          'Failed to rate ride with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Rate ride error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected rate ride error: $e');
      throw ApiException('An unexpected error occurred while rating ride');
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