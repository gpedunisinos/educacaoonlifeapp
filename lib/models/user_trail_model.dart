import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';

class UserTrailModel {
  final int id;
  final int userId;
  final int trailId;
  final UserTrailStatusEnum status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? startedAt;
  final DateTime? lastAccessAt;
  final DateTime? expiresAt;
  final double? score;
  final DateTime? inactivityWarning;
  final TrailModel? trail;
  final UserModel? user;

  UserTrailModel({
    required this.id,
    required this.userId,
    required this.trailId,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.startedAt,
    this.lastAccessAt,
    this.expiresAt,
    this.score,
    this.inactivityWarning,
    this.trail,
    this.user,
  });

  factory UserTrailModel.fromJson(Map<String, dynamic> json) {
    return UserTrailModel(
      id: json['id'],
      userId: json['user_id'],
      trailId: json['trail_id'],
      status: UserTrailStatusEnum.fromValue(json['status']),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      startedAt: json['started_at'] != null ? DateTime.tryParse(json['started_at']) : null,
      lastAccessAt: json['last_access_at'] != null ? DateTime.tryParse(json['last_access_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      inactivityWarning: json['inactivity_warning'] != null && json['inactivity_warning'] > 0 ? DateTime.tryParse(json['inactivity_warning']) : null,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      trail: json['Trail'] != null ? TrailModel.fromJson(json['Trail']) : null,
      user: json['User'] != null ? UserModel.fromJson(json['User']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'trail_id': trailId,
      'status': status.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'last_access_at': lastAccessAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'inactivity_warning': inactivityWarning?.toIso8601String(),
      'score': score,
      'Trail': trail?.toJson(),
      'User': user?.toJson(),
    };
  }

  static List<UserTrailModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => UserTrailModel.fromJson(json)).toList();
  }

  UserTrailModel copyWith({
    int? id,
    int? userId,
    int? trailId,
    UserTrailStatusEnum? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? startedAt,
    DateTime? lastAccessAt,
    DateTime? expiresAt,
    double? score,
    DateTime? inactivityWarning,
    TrailModel? trail,
    UserModel? user,
  }) {
    return UserTrailModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      trailId: trailId ?? this.trailId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      startedAt: startedAt ?? this.startedAt,
      lastAccessAt: lastAccessAt ?? this.lastAccessAt,
      expiresAt: expiresAt ?? this.expiresAt,
      score: score ?? this.score,
      inactivityWarning: inactivityWarning ?? this.inactivityWarning,
      trail: trail ?? this.trail,
      user: user ?? this.user,
    );
  }
}
