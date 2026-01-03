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

/// Booking response matching actual backend structure
@JsonSerializable()
class BookingResponse {
  final String id;
  final String riderId;
  final String routeId;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String status; // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
  final String scheduledPickupTime;
  final String? estimatedDropoffTime;
  final int passengerCount;
  final double? fareAmount;
  final double? distanceKm;
  final String? specialInstructions;
  final double? riderRating;
  final double? driverRating;
  final String? createdAt;
  final String? confirmedAt;
  final String? startedAt;
  final String? completedAt;

  BookingResponse({
    required this.id,
    required this.riderId,
    required this.routeId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.status,
    required this.scheduledPickupTime,
    this.estimatedDropoffTime,
    required this.passengerCount,
    this.fareAmount,
    this.distanceKm,
    this.specialInstructions,
    this.riderRating,
    this.driverRating,
    this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);

  // Helper getters for display
  String get fareDisplay => fareAmount != null 
      ? '₦${fareAmount!.toStringAsFixed(0)}' 
      : 'Fare TBD';

  String get distanceDisplay => distanceKm != null
      ? '${distanceKm!.toStringAsFixed(1)} km'
      : 'Distance TBD';

  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Waiting for driver';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'IN_PROGRESS':
        return 'In progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }
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