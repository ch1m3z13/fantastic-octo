import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class RegisterUserDTO {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isDriver;

  RegisterUserDTO({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.isDriver = false,
  });

  factory RegisterUserDTO.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserDTOToJson(this);
}

@JsonSerializable()
class LoginDTO {
  final String username;
  final String password;

  LoginDTO({
    required this.username,
    required this.password,
  });

  factory LoginDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDTOToJson(this);
}

// Main response wrapper from backend
@JsonSerializable()
class AuthResponse {
  final UserData user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
  
  // Convenience getter to check if user is driver
  bool get isDriver => user.roles == 'DRIVER';
}

// User data from backend
@JsonSerializable()
class UserData {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String roles; // "DRIVER" or "RIDER"
  final double rating;
  final int totalRatings;
  final bool isVerified;

  UserData({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.roles,
    required this.rating,
    required this.totalRatings,
    required this.isVerified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
  
  // Convenience getter
  bool get isDriver => roles == 'DRIVER';
}

// For backwards compatibility, keep UserResponse as alias
typedef UserResponse = AuthResponse;