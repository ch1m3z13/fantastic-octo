// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverStats _$DriverStatsFromJson(Map<String, dynamic> json) => DriverStats(
  driverId: json['driverId'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  completedTrips: (json['completedTrips'] as num).toInt(),
  completedTripsToday: (json['completedTripsToday'] as num).toInt(),
  completedTripsThisWeek: (json['completedTripsThisWeek'] as num).toInt(),
  completedTripsThisMonth: (json['completedTripsThisMonth'] as num).toInt(),
  totalEarnings: (json['totalEarnings'] as num).toDouble(),
  earningsToday: (json['earningsToday'] as num).toDouble(),
  earningsThisWeek: (json['earningsThisWeek'] as num).toDouble(),
  earningsThisMonth: (json['earningsThisMonth'] as num).toDouble(),
  activePassengers: (json['activePassengers'] as num).toInt(),
  currentRouteId: json['currentRouteId'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$DriverStatsToJson(DriverStats instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'completedTrips': instance.completedTrips,
      'completedTripsToday': instance.completedTripsToday,
      'completedTripsThisWeek': instance.completedTripsThisWeek,
      'completedTripsThisMonth': instance.completedTripsThisMonth,
      'totalEarnings': instance.totalEarnings,
      'earningsToday': instance.earningsToday,
      'earningsThisWeek': instance.earningsThisWeek,
      'earningsThisMonth': instance.earningsThisMonth,
      'activePassengers': instance.activePassengers,
      'currentRouteId': instance.currentRouteId,
      'status': instance.status,
    };

ActiveManifest _$ActiveManifestFromJson(Map<String, dynamic> json) =>
    ActiveManifest(
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String,
      departureTime: json['departureTime'] as String?,
      passengers: (json['passengers'] as List<dynamic>)
          .map((e) => ManifestPassenger.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPassengers: (json['totalPassengers'] as num).toInt(),
      pickedUpPassengers: (json['pickedUpPassengers'] as num).toInt(),
      completedPassengers: (json['completedPassengers'] as num).toInt(),
      totalFare: (json['totalFare'] as num).toDouble(),
    );

Map<String, dynamic> _$ActiveManifestToJson(ActiveManifest instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeName': instance.routeName,
      'departureTime': instance.departureTime,
      'passengers': instance.passengers,
      'totalPassengers': instance.totalPassengers,
      'pickedUpPassengers': instance.pickedUpPassengers,
      'completedPassengers': instance.completedPassengers,
      'totalFare': instance.totalFare,
    };

ManifestPassenger _$ManifestPassengerFromJson(Map<String, dynamic> json) =>
    ManifestPassenger(
      bookingId: json['bookingId'] as String,
      riderId: json['riderId'] as String,
      riderName: json['riderName'] as String,
      riderPhone: json['riderPhone'] as String?,
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      dropoffLatitude: (json['dropoffLatitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num).toDouble(),
      status: json['status'] as String,
      fare: (json['fare'] as num).toDouble(),
      passengerCount: (json['passengerCount'] as num).toInt(),
      specialInstructions: json['specialInstructions'] as String?,
      pickupOrder: (json['pickupOrder'] as num).toInt(),
    );

Map<String, dynamic> _$ManifestPassengerToJson(ManifestPassenger instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'riderId': instance.riderId,
      'riderName': instance.riderName,
      'riderPhone': instance.riderPhone,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'dropoffLatitude': instance.dropoffLatitude,
      'dropoffLongitude': instance.dropoffLongitude,
      'status': instance.status,
      'fare': instance.fare,
      'passengerCount': instance.passengerCount,
      'specialInstructions': instance.specialInstructions,
      'pickupOrder': instance.pickupOrder,
    };

StatusUpdateRequest _$StatusUpdateRequestFromJson(Map<String, dynamic> json) =>
    StatusUpdateRequest(status: json['status'] as String);

Map<String, dynamic> _$StatusUpdateRequestToJson(
  StatusUpdateRequest instance,
) => <String, dynamic>{'status': instance.status};

StatusUpdateResponse _$StatusUpdateResponseFromJson(
  Map<String, dynamic> json,
) => StatusUpdateResponse(
  driverId: json['driverId'] as String,
  status: json['status'] as String,
  message: json['message'] as String?,
);

Map<String, dynamic> _$StatusUpdateResponseToJson(
  StatusUpdateResponse instance,
) => <String, dynamic>{
  'driverId': instance.driverId,
  'status': instance.status,
  'message': instance.message,
};
