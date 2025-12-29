// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserDTO _$RegisterUserDTOFromJson(Map<String, dynamic> json) =>
    RegisterUserDTO(
      username: json['username'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isDriver: json['isDriver'] as bool? ?? false,
    );

Map<String, dynamic> _$RegisterUserDTOToJson(RegisterUserDTO instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'isDriver': instance.isDriver,
    };

LoginDTO _$LoginDTOFromJson(Map<String, dynamic> json) => LoginDTO(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginDTOToJson(LoginDTO instance) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  user: UserData.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'user': instance.user, 'token': instance.token};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String,
  username: json['username'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  roles: json['roles'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  isVerified: json['isVerified'] as bool,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'roles': instance.roles,
  'rating': instance.rating,
  'totalRatings': instance.totalRatings,
  'isVerified': instance.isVerified,
};
