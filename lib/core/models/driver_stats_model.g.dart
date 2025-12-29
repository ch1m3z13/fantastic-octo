// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverStats _$DriverStatsFromJson(Map<String, dynamic> json) => DriverStats(
  activePassengers: (json['activePassengers'] as num?)?.toInt() ?? 0,
  pendingRequests: (json['pendingRequests'] as num?)?.toInt() ?? 0,
  nextStopName: json['nextStopName'] as String?,
  nextStopEtaMinutes: (json['nextStopEtaMinutes'] as num?)?.toInt(),
  todaysEarnings: (json['todaysEarnings'] as num?)?.toDouble() ?? 0.0,
  tripsCompleted: (json['tripsCompleted'] as num?)?.toInt() ?? 0,
  passengersTransported: (json['passengersTransported'] as num?)?.toInt() ?? 0,
  onlineMinutes: (json['onlineMinutes'] as num?)?.toInt() ?? 0,
  acceptanceRate: (json['acceptanceRate'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$DriverStatsToJson(DriverStats instance) =>
    <String, dynamic>{
      'activePassengers': instance.activePassengers,
      'pendingRequests': instance.pendingRequests,
      'nextStopName': instance.nextStopName,
      'nextStopEtaMinutes': instance.nextStopEtaMinutes,
      'todaysEarnings': instance.todaysEarnings,
      'tripsCompleted': instance.tripsCompleted,
      'passengersTransported': instance.passengersTransported,
      'onlineMinutes': instance.onlineMinutes,
      'acceptanceRate': instance.acceptanceRate,
    };
