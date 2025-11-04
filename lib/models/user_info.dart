import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  /// Connect the generated [_$UserInfo] function to the `fromJson`
  /// factory.
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  /// Connect the generated [_$UserInfoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
