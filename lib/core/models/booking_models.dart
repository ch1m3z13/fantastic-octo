import 'package:json_annotation/json_annotation.dart';

part 'booking_models.g.dart';

/// Create booking request matching API specification
@JsonSerializable()
class CreateBookingRequest {
  final String riderId;
  final String routeId;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String scheduledPickupTime; // ISO 8601 format
  final int? passengerCount;
  final String? specialInstructions;

  CreateBookingRequest({
    required this.riderId,
    required this.routeId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.scheduledPickupTime,
    this.passengerCount = 1,
    this.specialInstructions,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

/// Booking response from API
@JsonSerializable()
class BookingResponse {
  final String id;
  final String riderId;
  final String routeId;
  final String status; // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
  final LocationInfo pickup;
  final LocationInfo dropoff;
  final String scheduledPickupTime;
  final int passengerCount;
  final String? specialInstructions;
  final String createdAt;
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;
  final DriverInfo? driver;

  BookingResponse({
    required this.id,
    required this.riderId,
    required this.routeId,
    required this.status,
    required this.pickup,
    required this.dropoff,
    required this.scheduledPickupTime,
    required this.passengerCount,
    this.specialInstructions,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.driver,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);
}

/// Location information
@JsonSerializable()
class LocationInfo {
  final double latitude;
  final double longitude;
  final String? address;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}

/// Driver information
@JsonSerializable()
class DriverInfo {
  final String id;
  final String name;
  final String phone;
  final VehicleInfo vehicle;
  final double rating;

  DriverInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicle,
    required this.rating,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) =>
      _$DriverInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverInfoToJson(this);
}

/// Vehicle information
@JsonSerializable()
class VehicleInfo {
  final String make;
  final String model;
  final String year;
  final String plateNumber;
  final String? color;

  VehicleInfo({
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    this.color,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoToJson(this);
}

/// Cancel booking request
@JsonSerializable()
class CancelBookingRequest {
  final String reason;

  CancelBookingRequest({required this.reason});

  factory CancelBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CancelBookingRequestToJson(this);
}

/// Rating request
@JsonSerializable()
class RatingRequest {
  final int rating; // 1-5
  final String? feedback;

  RatingRequest({
    required this.rating,
    this.feedback,
  });

  factory RatingRequest.fromJson(Map<String, dynamic> json) =>
      _$RatingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RatingRequestToJson(this);
}

/// Booking status enum helper
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled;

  static BookingStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return BookingStatus.pending;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'IN_PROGRESS':
        return BookingStatus.inProgress;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}