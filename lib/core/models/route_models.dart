import 'package:json_annotation/json_annotation.dart';

part 'route_models.g.dart';

/// Route response matching actual backend structure
@JsonSerializable()
class RouteResponse {
  final String id;
  final String name;
  final String? description;
  final double? distanceKm;
  final int? stopCount;
  final double? maxDeviationMeters;
  
  @JsonKey(name: 'coordinates')
  final List<List<double>>? coordinatesRaw; // Backend sends [[lon, lat], ...]
  
  final String? startPoint;
  final String? endPoint;
  
  // Optional fields that backend might add later
  final String? driverId;
  final DriverBasicInfo? driver;
  final String? status;
  final int? availableSeats;
  final double? estimatedFare;
  final String? departureTime;
  final String? arrivalTime;

  RouteResponse({
    required this.id,
    required this.name,
    this.description,
    this.distanceKm,
    this.stopCount,
    this.maxDeviationMeters,
    this.coordinatesRaw,
    this.startPoint,
    this.endPoint,
    this.driverId,
    this.driver,
    this.status,
    this.availableSeats,
    this.estimatedFare,
    this.departureTime,
    this.arrivalTime,
  });

  factory RouteResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RouteResponseToJson(this);

  // Helper getter to convert backend coordinates to proper format
  List<RouteCoordinate> get coordinates {
    if (coordinatesRaw == null) return [];
    
    return coordinatesRaw!.map((coord) {
      // Backend sends [longitude, latitude] (GeoJSON format)
      return RouteCoordinate(
        longitude: coord[0],
        latitude: coord[1],
      );
    }).toList();
  }

  // Helper getter for display distance
  String get distanceDisplay {
    if (distanceKm == null) return 'Distance unknown';
    
    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).toStringAsFixed(0)}m';
    } else {
      return '${distanceKm!.toStringAsFixed(1)}km';
    }
  }

  // Helper to get route summary
  String get routeSummary {
    if (startPoint != null && endPoint != null) {
      return '$startPoint → $endPoint';
    }
    return name;
  }
}

/// Basic driver information
@JsonSerializable()
class DriverBasicInfo {
  final String id;
  final String name;
  final double? rating;
  final int? totalTrips;
  final String? phoneNumber;
  final VehicleBasicInfo? vehicle;

  DriverBasicInfo({
    required this.id,
    required this.name,
    this.rating,
    this.totalTrips,
    this.phoneNumber,
    this.vehicle,
  });

  factory DriverBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$DriverBasicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverBasicInfoToJson(this);
}

/// Basic vehicle information
@JsonSerializable()
class VehicleBasicInfo {
  final String make;
  final String model;
  final String plateNumber;
  final String? color;
  final int? capacity;

  VehicleBasicInfo({
    required this.make,
    required this.model,
    required this.plateNumber,
    this.color,
    this.capacity,
  });

  factory VehicleBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleBasicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleBasicInfoToJson(this);

  String get displayName => '$make $model';
}

/// Route coordinate point
@JsonSerializable()
class RouteCoordinate {
  final double latitude;
  final double longitude;
  final int? sequenceOrder;
  final String? stopName;

  RouteCoordinate({
    required this.latitude,
    required this.longitude,
    this.sequenceOrder,
    this.stopName,
  });

  factory RouteCoordinate.fromJson(Map<String, dynamic> json) =>
      _$RouteCoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$RouteCoordinateToJson(this);
}

/// Create route request (for drivers)
@JsonSerializable()
class CreateRouteRequest {
  final String name;
  final String? description;
  final String driverId;
  final List<CoordinatePair> coordinates;
  final String? departureTime;
  final int? capacity;

  CreateRouteRequest({
    required this.name,
    this.description,
    required this.driverId,
    required this.coordinates,
    this.departureTime,
    this.capacity,
  });

  factory CreateRouteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRouteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRouteRequestToJson(this);
}

/// Simple coordinate pair
@JsonSerializable()
class CoordinatePair {
  final double latitude;
  final double longitude;

  CoordinatePair({
    required this.latitude,
    required this.longitude,
  });

  factory CoordinatePair.fromJson(Map<String, dynamic> json) =>
      _$CoordinatePairFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatePairToJson(this);
}

/// Pickup validation response
@JsonSerializable()
class PickupValidationResponse {
  final bool isValid;
  final String message;
  final double? distanceFromRoute;
  final RouteCoordinate? nearestPoint;

  PickupValidationResponse({
    required this.isValid,
    required this.message,
    this.distanceFromRoute,
    this.nearestPoint,
  });

  factory PickupValidationResponse.fromJson(Map<String, dynamic> json) =>
      _$PickupValidationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PickupValidationResponseToJson(this);
}

/// Search filters for finding routes
class RouteSearchFilters {
  final double latitude;
  final double longitude;
  final double radiusInMeters;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final int? minAvailableSeats;
  final double? maxFare;
  final String? departureTimeStart;
  final String? departureTimeEnd;

  RouteSearchFilters({
    required this.latitude,
    required this.longitude,
    this.radiusInMeters = 1000,
    this.destinationLatitude,
    this.destinationLongitude,
    this.minAvailableSeats,
    this.maxFare,
    this.departureTimeStart,
    this.departureTimeEnd,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'lat': latitude,
      'lon': longitude,
      'radius': radiusInMeters,
    };

    if (destinationLatitude != null) {
      params['destLat'] = destinationLatitude;
    }
    if (destinationLongitude != null) {
      params['destLon'] = destinationLongitude;
    }

    return params;
  }
}

/// Route status enum helper
enum RouteStatus {
  active,
  inactive,
  completed;

  static RouteStatus fromString(String? status) {
    if (status == null) return RouteStatus.active;
    
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return RouteStatus.active;
      case 'INACTIVE':
        return RouteStatus.inactive;
      case 'COMPLETED':
        return RouteStatus.completed;
      default:
        return RouteStatus.active;
    }
  }

  String get displayName {
    switch (this) {
      case RouteStatus.active:
        return 'Active';
      case RouteStatus.inactive:
        return 'Inactive';
      case RouteStatus.completed:
        return 'Completed';
    }
  }
}