// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBookingRequest _$CreateBookingRequestFromJson(
  Map<String, dynamic> json,
) => CreateBookingRequest(
  riderId: json['riderId'] as String,
  routeId: json['routeId'] as String,
  pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
  pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
  dropoffLatitude: (json['dropoffLatitude'] as num).toDouble(),
  dropoffLongitude: (json['dropoffLongitude'] as num).toDouble(),
  scheduledPickupTime: json['scheduledPickupTime'] as String,
  passengerCount: (json['passengerCount'] as num?)?.toInt() ?? 1,
  specialInstructions: json['specialInstructions'] as String?,
);

Map<String, dynamic> _$CreateBookingRequestToJson(
  CreateBookingRequest instance,
) => <String, dynamic>{
  'riderId': instance.riderId,
  'routeId': instance.routeId,
  'pickupLatitude': instance.pickupLatitude,
  'pickupLongitude': instance.pickupLongitude,
  'dropoffLatitude': instance.dropoffLatitude,
  'dropoffLongitude': instance.dropoffLongitude,
  'scheduledPickupTime': instance.scheduledPickupTime,
  'passengerCount': instance.passengerCount,
  'specialInstructions': instance.specialInstructions,
};

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) =>
    BookingResponse(
      id: json['id'] as String,
      riderId: json['riderId'] as String,
      routeId: json['routeId'] as String,
      status: json['status'] as String,
      pickup: LocationInfo.fromJson(json['pickup'] as Map<String, dynamic>),
      dropoff: LocationInfo.fromJson(json['dropoff'] as Map<String, dynamic>),
      scheduledPickupTime: json['scheduledPickupTime'] as String,
      passengerCount: (json['passengerCount'] as num).toInt(),
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: json['createdAt'] as String,
      confirmedAt: json['confirmedAt'] as String?,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      driver: json['driver'] == null
          ? null
          : DriverInfo.fromJson(json['driver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingResponseToJson(BookingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'riderId': instance.riderId,
      'routeId': instance.routeId,
      'status': instance.status,
      'pickup': instance.pickup,
      'dropoff': instance.dropoff,
      'scheduledPickupTime': instance.scheduledPickupTime,
      'passengerCount': instance.passengerCount,
      'specialInstructions': instance.specialInstructions,
      'createdAt': instance.createdAt,
      'confirmedAt': instance.confirmedAt,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'driver': instance.driver,
    };

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) => LocationInfo(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
);

Map<String, dynamic> _$LocationInfoToJson(LocationInfo instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
    };

DriverInfo _$DriverInfoFromJson(Map<String, dynamic> json) => DriverInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
  rating: (json['rating'] as num).toDouble(),
);

Map<String, dynamic> _$DriverInfoToJson(DriverInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'vehicle': instance.vehicle,
      'rating': instance.rating,
    };

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => VehicleInfo(
  make: json['make'] as String,
  model: json['model'] as String,
  year: json['year'] as String,
  plateNumber: json['plateNumber'] as String,
  color: json['color'] as String?,
);

Map<String, dynamic> _$VehicleInfoToJson(VehicleInfo instance) =>
    <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'plateNumber': instance.plateNumber,
      'color': instance.color,
    };

CancelBookingRequest _$CancelBookingRequestFromJson(
  Map<String, dynamic> json,
) => CancelBookingRequest(reason: json['reason'] as String);

Map<String, dynamic> _$CancelBookingRequestToJson(
  CancelBookingRequest instance,
) => <String, dynamic>{'reason': instance.reason};

RatingRequest _$RatingRequestFromJson(Map<String, dynamic> json) =>
    RatingRequest(
      rating: (json['rating'] as num).toInt(),
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$RatingRequestToJson(RatingRequest instance) =>
    <String, dynamic>{'rating': instance.rating, 'feedback': instance.feedback};
