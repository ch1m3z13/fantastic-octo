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
      pickupLatitude: (json['pickupLatitude'] as num).toDouble(),
      pickupLongitude: (json['pickupLongitude'] as num).toDouble(),
      dropoffLatitude: (json['dropoffLatitude'] as num).toDouble(),
      dropoffLongitude: (json['dropoffLongitude'] as num).toDouble(),
      status: json['status'] as String,
      scheduledPickupTime: json['scheduledPickupTime'] as String,
      estimatedDropoffTime: json['estimatedDropoffTime'] as String?,
      passengerCount: (json['passengerCount'] as num).toInt(),
      fareAmount: (json['fareAmount'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
      riderRating: (json['riderRating'] as num?)?.toDouble(),
      driverRating: (json['driverRating'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      confirmedAt: json['confirmedAt'] as String?,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
    );

Map<String, dynamic> _$BookingResponseToJson(BookingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'riderId': instance.riderId,
      'routeId': instance.routeId,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'dropoffLatitude': instance.dropoffLatitude,
      'dropoffLongitude': instance.dropoffLongitude,
      'status': instance.status,
      'scheduledPickupTime': instance.scheduledPickupTime,
      'estimatedDropoffTime': instance.estimatedDropoffTime,
      'passengerCount': instance.passengerCount,
      'fareAmount': instance.fareAmount,
      'distanceKm': instance.distanceKm,
      'specialInstructions': instance.specialInstructions,
      'riderRating': instance.riderRating,
      'driverRating': instance.driverRating,
      'createdAt': instance.createdAt,
      'confirmedAt': instance.confirmedAt,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
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
