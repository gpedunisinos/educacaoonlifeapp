import 'dart:convert';

import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/user_trail_model.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils/util.dart';

enum ProfileTypeEnum {
  student(10, 'Aluno'),
  teacher(20, 'Professor'),
  manager(30, 'Gestor'),
  admin(40, 'Administrador');

  final int value;
  final String description;

  const ProfileTypeEnum(this.value, this.description);

  static ProfileTypeEnum? fromValue(int value) {
    ProfileTypeEnum? type = ProfileTypeEnum.values.firstWhereOrNull((e) => e.value == value);

    return type;
  }
}

class UserModel {
  int id;
  String name;
  String email;
  String password;
  String? phone;
  String? token;
  String? fcmToken;
  String? rememberToken;
  String? resetPasswordToken;
  String? createdAt;
  String? updatedAt;
  String? emailVerifiedAt;
  DateTime? deletedAt;
  bool? sendTrailNotification;
  bool? sendClassNotification;
  bool? sendPlatformNotification;
  bool status;
  ProfileTypeEnum? profileType;
  bool? isGoogleAuth;
  int? profilePictureId;
  MFile? profilePicture;
  List<UserTrailModel>? userTrails = [];

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.token,
    this.fcmToken,
    this.rememberToken,
    this.resetPasswordToken,
    this.createdAt,
    this.updatedAt,
    this.emailVerifiedAt,
    this.deletedAt,
    this.sendTrailNotification,
    this.sendClassNotification,
    this.sendPlatformNotification,
    this.status = true,
    required this.profileType,
    this.isGoogleAuth,
    this.profilePictureId,
    this.profilePicture,
    this.userTrails,
  });

  bool get isAdmin => profileType == ProfileTypeEnum.admin;
  bool get isTeacher => profileType == ProfileTypeEnum.teacher;
  bool get isStudent => profileType == ProfileTypeEnum.student;

  Future<void> savePrefs() async {
    final prefs = Util.prefs;
    prefs.remove('user');
    prefs.setString('user', jsonEncode(this.toJson()));
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'] ?? '',
      fcmToken: json['fcm_token'],
      rememberToken: json['remember_token'],
      resetPasswordToken: json['reset_password_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      emailVerifiedAt: json['email_verified_at'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      sendTrailNotification: json['send_trail_notification'],
      sendClassNotification: json['send_class_notification'],
      sendPlatformNotification: json['send_platform_notification'],
      status: json['status'] ?? false,
      profileType: ProfileTypeEnum.fromValue(json['profile']),
      isGoogleAuth: json['is_google_auth'],
      profilePictureId: json['profile_picture_id'],
      profilePicture: json['profile_picture'] != null ? MFile.fromJson(json['profile_picture']) : null,
      userTrails: json['user_trails'] != null ? UserTrailModel.fromJsonArray(json['user_trails']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'token': token,
      'fcm_token': fcmToken,
      'remember_token': rememberToken,
      'reset_password_token': resetPasswordToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'email_verified_at': emailVerifiedAt,
      'deleted_at': deletedAt?.toIso8601String(),
      'send_trail_notification': sendTrailNotification,
      'send_class_notification': sendClassNotification,
      'send_platform_notification': sendPlatformNotification,
      'status': status,
      'profile': profileType?.value,
      'is_google_auth': isGoogleAuth,
      'profile_picture_id': profilePictureId,
      'profile_picture': profilePicture?.toJson(),
      'user_trails': userTrails,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? token,
    String? fcmToken,
    String? rememberToken,
    String? resetPasswordToken,
    String? createdAt,
    String? updatedAt,
    String? emailVerifiedAt,
    DateTime? deletedAt,
    bool? sendTrailNotification,
    bool? sendClassNotification,
    bool? sendPlatformNotification,
    bool? status,
    ProfileTypeEnum? profileType,
    bool? isGoogleAuth,
    int? profilePictureId,
    MFile? profilePicture,
    List<UserTrailModel>? userTrails,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      fcmToken: fcmToken ?? this.fcmToken,
      rememberToken: rememberToken ?? this.rememberToken,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sendTrailNotification: sendTrailNotification ?? this.sendTrailNotification ?? false,
      sendClassNotification: sendClassNotification ?? this.sendClassNotification ?? false,
      sendPlatformNotification: sendPlatformNotification ?? this.sendPlatformNotification ?? false,
      status: status ?? this.status,
      profileType: profileType ?? this.profileType,
      isGoogleAuth: isGoogleAuth ?? this.isGoogleAuth ?? false,
      profilePictureId: profilePictureId ?? this.profilePictureId,
      profilePicture: profilePicture ?? this.profilePicture,
      userTrails: userTrails ?? this.userTrails,
    );
  }

  static List<UserModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => UserModel.fromJson(json)).toList();
  }

  Map<String, dynamic> removeEmptyFields() {
    Map<String, dynamic> cleanMap(Map<String, dynamic> map) {
      final newMap = <String, dynamic>{};
      map.forEach((key, value) {
        if (value == null) return;

        if (value is String && value.isEmpty) return;

        if (value is Map<String, dynamic>) {
          final nested = cleanMap(value);
          if (nested.isNotEmpty) newMap[key] = nested;
          return;
        }

        if (value is List) {
          final list = value.where((e) => e != null && (e is! String || e.isNotEmpty)).toList();
          if (list.isNotEmpty) newMap[key] = list;
          return;
        }

        newMap[key] = value;
      });
      return newMap;
    }

    return cleanMap(toJson());
  }
}
