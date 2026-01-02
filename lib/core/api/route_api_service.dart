import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/route_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'auth_api_service.dart'; // For ApiException

/// Service for handling route-related API calls
class RouteApiService {
  final ApiClient _apiClient = ApiClient();
  final _logger = Logger();

  /// Find nearby routes based on user's location
  /// 
  /// Parameters:
  /// - [latitude]: User's current latitude
  /// - [longitude]: User's current longitude
  /// - [radiusInMeters]: Search radius (default 1000m = 1km)
  Future<List<RouteResponse>> findNearbyRoutes({
    required double latitude,
    required double longitude,
    double radiusInMeters = 1000,
  }) async {
    try {
      _logger.i('Searching for routes near: $latitude, $longitude');

      final response = await _apiClient.get(
        ApiConfig.nearbyRoutesEndpoint,
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'radius': radiusInMeters,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final routes = data.map((json) => RouteResponse.fromJson(json)).toList();
        
        _logger.i('Found ${routes.length} nearby routes');
        return routes;
      } else {
        throw ApiException(
          'Failed to find routes with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Find nearby routes error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected find nearby routes error: $e');
      throw ApiException('An unexpected error occurred while searching for routes');
    }
  }

  /// Find routes heading towards a destination
  /// 
  /// Parameters:
  /// - [originLatitude]: Starting point latitude
  /// - [originLongitude]: Starting point longitude
  /// - [destinationLatitude]: Destination latitude
  /// - [destinationLongitude]: Destination longitude
  /// - [radiusInMeters]: Search radius (default 1000m)
  Future<List<RouteResponse>> findRoutesHeadingTo({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    double radiusInMeters = 1000,
  }) async {
    try {
      _logger.i('Searching for routes from ($originLatitude, $originLongitude) to ($destinationLatitude, $destinationLongitude)');

      final response = await _apiClient.get(
        '${ApiConfig.routesEndpoint}/heading-to',
        queryParameters: {
          'originLat': originLatitude,
          'originLon': originLongitude,
          'destLat': destinationLatitude,
          'destLon': destinationLongitude,
          'radius': radiusInMeters,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final routes = data.map((json) => RouteResponse.fromJson(json)).toList();
        
        _logger.i('Found ${routes.length} routes heading to destination');
        return routes;
      } else {
        throw ApiException(
          'Failed to find routes with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Find routes heading to error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected find routes heading to error: $e');
      throw ApiException('An unexpected error occurred while searching for routes');
    }
  }

  /// Get detailed information about a specific route
  Future<RouteResponse> getRouteDetails(String routeId) async {
    try {
      _logger.i('Fetching route details: $routeId');

      final response = await _apiClient.get(
        '${ApiConfig.routesEndpoint}/$routeId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return RouteResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to get route details with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Get route details error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected get route details error: $e');
      throw ApiException('An unexpected error occurred while fetching route details');
    }
  }

  /// Validate if a pickup location is acceptable for a route
  /// 
  /// Parameters:
  /// - [routeId]: The route ID to validate against
  /// - [latitude]: Proposed pickup latitude
  /// - [longitude]: Proposed pickup longitude
  Future<PickupValidationResponse> validatePickupLocation({
    required String routeId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      _logger.i('Validating pickup location for route: $routeId');

      final response = await _apiClient.get(
        '${ApiConfig.routesEndpoint}/$routeId/validate-pickup',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return PickupValidationResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to validate pickup with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Validate pickup error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected validate pickup error: $e');
      throw ApiException('An unexpected error occurred while validating pickup location');
    }
  }

  /// Create a new route (driver functionality)
  Future<RouteResponse> createRoute(CreateRouteRequest request) async {
    try {
      _logger.i('Creating new route: ${request.name}');

      final response = await _apiClient.post(
        ApiConfig.routesEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        _logger.i('Route created successfully');
        return RouteResponse.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to create route with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Create route error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected create route error: $e');
      throw ApiException('An unexpected error occurred while creating route');
    }
  }

  /// Search for routes with advanced filters
  Future<List<RouteResponse>> searchRoutes(RouteSearchFilters filters) async {
    try {
      _logger.i('Searching routes with filters');

      // Use the appropriate endpoint based on whether destination is provided
      final endpoint = filters.destinationLatitude != null && 
                      filters.destinationLongitude != null
          ? '${ApiConfig.routesEndpoint}/heading-to'
          : ApiConfig.nearbyRoutesEndpoint;

      final response = await _apiClient.get(
        endpoint,
        queryParameters: filters.toQueryParams(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        var routes = data.map((json) => RouteResponse.fromJson(json)).toList();

        // Apply client-side filters if needed
        if (filters.minAvailableSeats != null) {
          routes = routes.where((route) => 
            (route.availableSeats ?? 0) >= filters.minAvailableSeats!
          ).toList();
        }

        if (filters.maxFare != null) {
          routes = routes.where((route) => 
            (route.estimatedFare ?? double.infinity) <= filters.maxFare!
          ).toList();
        }

        _logger.i('Found ${routes.length} routes matching filters');
        return routes;
      } else {
        throw ApiException(
          'Failed to search routes with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.e('Search routes error: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      _logger.e('Unexpected search routes error: $e');
      throw ApiException('An unexpected error occurred while searching routes');
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
          return ApiException('No routes found in this area', statusCode: 404);
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