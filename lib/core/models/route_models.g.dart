// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteResponse _$RouteResponseFromJson(Map<String, dynamic> json) =>
    RouteResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      stopCount: (json['stopCount'] as num?)?.toInt(),
      maxDeviationMeters: (json['maxDeviationMeters'] as num?)?.toDouble(),
      coordinatesRaw: (json['coordinates'] as List<dynamic>?)
          ?.map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      startPoint: json['startPoint'] as String?,
      endPoint: json['endPoint'] as String?,
      driverId: json['driverId'] as String?,
      driver: json['driver'] == null
          ? null
          : DriverBasicInfo.fromJson(json['driver'] as Map<String, dynamic>),
      status: json['status'] as String?,
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      departureTime: json['departureTime'] as String?,
      arrivalTime: json['arrivalTime'] as String?,
    );

Map<String, dynamic> _$RouteResponseToJson(RouteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'distanceKm': instance.distanceKm,
      'stopCount': instance.stopCount,
      'maxDeviationMeters': instance.maxDeviationMeters,
      'coordinates': instance.coordinatesRaw,
      'startPoint': instance.startPoint,
      'endPoint': instance.endPoint,
      'driverId': instance.driverId,
      'driver': instance.driver,
      'status': instance.status,
      'availableSeats': instance.availableSeats,
      'estimatedFare': instance.estimatedFare,
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
    };

DriverBasicInfo _$DriverBasicInfoFromJson(Map<String, dynamic> json) =>
    DriverBasicInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      totalTrips: (json['totalTrips'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      vehicle: json['vehicle'] == null
          ? null
          : VehicleBasicInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverBasicInfoToJson(DriverBasicInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rating': instance.rating,
      'totalTrips': instance.totalTrips,
      'phoneNumber': instance.phoneNumber,
      'vehicle': instance.vehicle,
    };

VehicleBasicInfo _$VehicleBasicInfoFromJson(Map<String, dynamic> json) =>
    VehicleBasicInfo(
      make: json['make'] as String,
      model: json['model'] as String,
      plateNumber: json['plateNumber'] as String,
      color: json['color'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VehicleBasicInfoToJson(VehicleBasicInfo instance) =>
    <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'plateNumber': instance.plateNumber,
      'color': instance.color,
      'capacity': instance.capacity,
    };

RouteCoordinate _$RouteCoordinateFromJson(Map<String, dynamic> json) =>
    RouteCoordinate(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sequenceOrder: (json['sequenceOrder'] as num?)?.toInt(),
      stopName: json['stopName'] as String?,
    );

Map<String, dynamic> _$RouteCoordinateToJson(RouteCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sequenceOrder': instance.sequenceOrder,
      'stopName': instance.stopName,
    };

CreateRouteRequest _$CreateRouteRequestFromJson(Map<String, dynamic> json) =>
    CreateRouteRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      driverId: json['driverId'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => CoordinatePair.fromJson(e as Map<String, dynamic>))
          .toList(),
      departureTime: json['departureTime'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateRouteRequestToJson(CreateRouteRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'driverId': instance.driverId,
      'coordinates': instance.coordinates,
      'departureTime': instance.departureTime,
      'capacity': instance.capacity,
    };

CoordinatePair _$CoordinatePairFromJson(Map<String, dynamic> json) =>
    CoordinatePair(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatePairToJson(CoordinatePair instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

PickupValidationResponse _$PickupValidationResponseFromJson(
  Map<String, dynamic> json,
) => PickupValidationResponse(
  isValid: json['isValid'] as bool,
  message: json['message'] as String,
  distanceFromRoute: (json['distanceFromRoute'] as num?)?.toDouble(),
  nearestPoint: json['nearestPoint'] == null
      ? null
      : RouteCoordinate.fromJson(json['nearestPoint'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PickupValidationResponseToJson(
  PickupValidationResponse instance,
) => <String, dynamic>{
  'isValid': instance.isValid,
  'message': instance.message,
  'distanceFromRoute': instance.distanceFromRoute,
  'nearestPoint': instance.nearestPoint,
};
