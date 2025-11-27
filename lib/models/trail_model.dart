import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/deleted_at_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/models/user_trail_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

enum UserTrailStatusEnum {
  registered(10, 'Registrado'),
  inProgress(20, 'Em Progresso'),
  submittedAssessment(30, 'Avaliação Submetida'),
  completed(40, 'Concluído');

  final int value;
  final String description;

  const UserTrailStatusEnum(this.value, this.description);

  static UserTrailStatusEnum fromValue(int value) {
    try {
      return UserTrailStatusEnum.values.firstWhere((e) => e.value == value);
    } catch (e) {
      throw ArgumentError('Valor $value não encontrado em UserTrailStatusEnum');
    }
  }
}

class TrailModel extends ModelBase {
  final String name;
  final int? categoryId;
  final String? description;
  final int? order;
  final String? expirationTime;
  final int? coverImageFileId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DeletedAt? deletedAt;
  final CategoryModel? category;
  final MFile? coverImageFile;
  final List<ClassModel>? classes;
  final bool status;
  final UserTrailStatusEnum? trailStatus;
  final List<UserTrailModel>? userTrails;
  final int? teacherId;
  final UserModel? teacher;

  TrailModel({
    required super.id,
    required this.name,
    this.categoryId,
    this.description,
    this.order,
    this.expirationTime,
    this.coverImageFileId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
    this.coverImageFile,
    this.classes,
    this.status = true,
    this.trailStatus,
    this.userTrails,
    this.teacherId,
    this.teacher,
  });

  factory TrailModel.fromJson(Map<String, dynamic> json) {
    return TrailModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      description: json['description'],
      order: json['order'],
      expirationTime: json['expiration_time'],
      coverImageFileId: json['cover_image_file_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DeletedAt.fromJson(json['deleted_at']) : null,
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
      coverImageFile: json['cover_image_file'] != null ? MFile.fromJson(json['cover_image_file']) : null,
      classes: json['classes'] != null && json['classes'] != [] ? ClassModel.fromJsonArray(json['classes']) : null,
      status: json['status'] ?? true,
      trailStatus:
          json['user_trails'] != null && json['user_trails'].isNotEmpty ? UserTrailStatusEnum.fromValue(json['user_trails'][0]['status']) : null,
      userTrails: json['user_trails'] != null ? UserTrailModel.fromJsonArray(json['user_trails']) : null,
      teacherId: json['teacher_id'],
      teacher: json['teacher'] != null ? UserModel.fromJson(json['teacher']) : null,
    );
  }

  String get getClassesDuration {
    final totalMinutes = classes?.map((c) => c.estimatedTime ?? 0).fold(0, (sum, minutes) => sum + minutes);

    if (totalMinutes == null || totalMinutes == 0) {
      return 'n/d';
    }

    return '$totalMinutes min';
  }

  static List<TrailModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => TrailModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'description': description,
      'order': order,
      'expiration_time': expirationTime,
      'cover_image_file_id': coverImageFileId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toJson(),
      'category': category?.toJson(),
      'cover_image_file': coverImageFile?.toJson(),
      'classes': classes?.map((e) => e.toJson()).toList(),
      'status': status,
      'trail_status': trailStatus?.value,
      'user_trails': userTrails?.map((e) => e.toJson()).toList(),
      'teacher_id': teacherId,
      'teacher': teacher?.toJson(),
    };
  }

  TrailModel copyWith({
    String? name,
    int? categoryId,
    String? description,
    int? order,
    String? expirationTime,
    int? coverImageFileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DeletedAt? deletedAt,
    CategoryModel? category,
    MFile? coverImageFile,
    List<ClassModel>? classes,
    bool? status,
    UserTrailStatusEnum? trailStatus,
    List<UserTrailModel>? userTrails,
    int? teacherId,
    UserModel? teacher,
  }) {
    return TrailModel(
      id: id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      order: order ?? this.order,
      expirationTime: expirationTime ?? this.expirationTime,
      coverImageFileId: coverImageFileId ?? this.coverImageFileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      category: category ?? this.category,
      coverImageFile: coverImageFile ?? this.coverImageFile,
      classes: classes ?? this.classes,
      status: status ?? this.status,
      trailStatus: trailStatus ?? this.trailStatus,
      userTrails: userTrails ?? this.userTrails,
      teacherId: teacherId ?? this.teacherId,
      teacher: teacher ?? this.teacher,
    );
  }
}
