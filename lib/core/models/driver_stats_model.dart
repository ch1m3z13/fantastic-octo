import 'package:json_annotation/json_annotation.dart';

part 'driver_stats_model.g.dart';

@JsonSerializable()
class DriverStats {
  // Tier 1 - Immediate Action
  final int activePassengers;
  final int pendingRequests;
  final String? nextStopName;
  final int? nextStopEtaMinutes; // Nullable if no active trip

  // Tier 2 - Daily Performance
  final double todaysEarnings;
  final int tripsCompleted;
  final int passengersTransported;

  // Tier 3 - Session Info
  final int onlineMinutes; // Storing as minutes for easier serialization
  final double acceptanceRate; // 0.0 to 1.0

  const DriverStats({
    this.activePassengers = 0,
    this.pendingRequests = 0,
    this.nextStopName,
    this.nextStopEtaMinutes,
    this.todaysEarnings = 0.0,
    this.tripsCompleted = 0,
    this.passengersTransported = 0,
    this.onlineMinutes = 0,
    this.acceptanceRate = 1.0,
  });

  // Factory constructor for creating a default/empty state
  factory DriverStats.initial() => const DriverStats();

  factory DriverStats.fromJson(Map<String, dynamic> json) =>
      _$DriverStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatsToJson(this);
  
  // --- Helpers for UI ---
  
  // Format currency (Naira)
  String get formattedEarnings => '₦${todaysEarnings.toStringAsFixed(2)}';
  
  // Format online time nicely (e.g., "4h 12m")
  String get formattedOnlineTime {
    final hours = onlineMinutes ~/ 60;
    final minutes = onlineMinutes % 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }

  // Format acceptance rate as percentage
  String get formattedAcceptanceRate => '${(acceptanceRate * 100).toInt()}%';
}