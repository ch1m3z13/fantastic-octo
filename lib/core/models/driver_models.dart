import 'package:json_annotation/json_annotation.dart';

part 'driver_models.g.dart';

/// Driver statistics response
@JsonSerializable()
class DriverStats {
  final String driverId;
  final double rating;
  final int totalRatings;
  final int completedTrips;
  final int completedTripsToday;
  final int completedTripsThisWeek;
  final int completedTripsThisMonth;
  final double totalEarnings;
  final double earningsToday;
  final double earningsThisWeek;
  final double earningsThisMonth;
  final int activePassengers;
  final String? currentRouteId;
  final String status; // ONLINE, OFFLINE, BUSY

  DriverStats({
    required this.driverId,
    required this.rating,
    required this.totalRatings,
    required this.completedTrips,
    required this.completedTripsToday,
    required this.completedTripsThisWeek,
    required this.completedTripsThisMonth,
    required this.totalEarnings,
    required this.earningsToday,
    required this.earningsThisWeek,
    required this.earningsThisMonth,
    required this.activePassengers,
    this.currentRouteId,
    required this.status,
  });

  factory DriverStats.fromJson(Map<String, dynamic> json) =>
      _$DriverStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatsToJson(this);

  // Helper getters for display
  String get ratingDisplay => rating.toStringAsFixed(1);
  
  String get earningsTodayDisplay => '₦${earningsToday.toStringAsFixed(0)}';
  String get earningsWeekDisplay => '₦${earningsThisWeek.toStringAsFixed(0)}';
  String get earningsMonthDisplay => '₦${earningsThisMonth.toStringAsFixed(0)}';
  String get totalEarningsDisplay => '₦${totalEarnings.toStringAsFixed(0)}';
}

/// Active manifest response
@JsonSerializable()
class ActiveManifest {
  final String routeId;
  final String routeName;
  final String? departureTime;
  final List<ManifestPassenger> passengers;
  final int totalPassengers;
  final int pickedUpPassengers;
  final int completedPassengers;
  final double totalFare;

  ActiveManifest({
    required this.routeId,
    required this.routeName,
    this.departureTime,
    required this.passengers,
    required this.totalPassengers,
    required this.pickedUpPassengers,
    required this.completedPassengers,
    required this.totalFare,
  });

  factory ActiveManifest.fromJson(Map<String, dynamic> json) =>
      _$ActiveManifestFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveManifestToJson(this);

  String get totalFareDisplay => '₦${totalFare.toStringAsFixed(0)}';
  
  int get remainingPickups => totalPassengers - pickedUpPassengers;
}

/// Manifest passenger details
@JsonSerializable()
class ManifestPassenger {
  final String bookingId;
  final String riderId;
  final String riderName;
  final String? riderPhone;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String status; // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED
  final double fare;
  final int passengerCount;
  final String? specialInstructions;
  final int pickupOrder;

  ManifestPassenger({
    required this.bookingId,
    required this.riderId,
    required this.riderName,
    this.riderPhone,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.status,
    required this.fare,
    required this.passengerCount,
    this.specialInstructions,
    required this.pickupOrder,
  });

  factory ManifestPassenger.fromJson(Map<String, dynamic> json) =>
      _$ManifestPassengerFromJson(json);

  Map<String, dynamic> toJson() => _$ManifestPassengerToJson(this);

  String get fareDisplay => '₦${fare.toStringAsFixed(0)}';
  
  bool get isPickedUp => status.toUpperCase() == 'IN_PROGRESS';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isPending => status.toUpperCase() == 'PENDING' || 
                        status.toUpperCase() == 'CONFIRMED';
}

/// Driver status update request
@JsonSerializable()
class StatusUpdateRequest {
  final String status; // ONLINE, OFFLINE, BUSY

  StatusUpdateRequest({required this.status});

  factory StatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$StatusUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StatusUpdateRequestToJson(this);
}

/// Driver status response
@JsonSerializable()
class StatusUpdateResponse {
  final String driverId;
  final String status;
  final String? message;

  StatusUpdateResponse({
    required this.driverId,
    required this.status,
    this.message,
  });

  factory StatusUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusUpdateResponseToJson(this);
}

/// Driver status enum
enum DriverStatus {
  online,
  offline,
  busy;

  static DriverStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'ONLINE':
        return DriverStatus.online;
      case 'OFFLINE':
        return DriverStatus.offline;
      case 'BUSY':
        return DriverStatus.busy;
      default:
        return DriverStatus.offline;
    }
  }

  String get value {
    switch (this) {
      case DriverStatus.online:
        return 'ONLINE';
      case DriverStatus.offline:
        return 'OFFLINE';
      case DriverStatus.busy:
        return 'BUSY';
    }
  }

  String get displayName {
    switch (this) {
      case DriverStatus.online:
        return 'Online';
      case DriverStatus.offline:
        return 'Offline';
      case DriverStatus.busy:
        return 'Busy';
    }
  }
}