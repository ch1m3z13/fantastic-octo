import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Login request DTO matching API specification
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Login response with JWT token
@JsonSerializable()
class LoginResponse {
  final String token;
  final UserInfo user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// User information matching actual backend response
@JsonSerializable()
class UserInfo {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String roles; // Backend sends "DRIVER,RIDER" or "RIDER" as string
  final int? rating;
  final int? totalRatings;
  final bool? isVerified;

  UserInfo({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.roles,
    this.rating,
    this.totalRatings,
    this.isVerified,
  });

  // Helper getter to check if user is a driver
  bool get isDriver => roles.contains('DRIVER');

  // Helper getter to check if user is a rider
  bool get isRider => roles.contains('RIDER');

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

/// Registration request DTO matching API specification
@JsonSerializable()
class RegisterRequest {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isDriver;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.isDriver = false,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// Registration response
@JsonSerializable()
class RegisterResponse {
  final String token;
  final UserInfo user;

  RegisterResponse({required this.token, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
