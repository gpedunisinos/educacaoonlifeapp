class DeletedAt {
  final String? time;
  final bool? valid;

  DeletedAt({
    this.time,
    this.valid,
  });

  factory DeletedAt.fromJson(Map<String, dynamic> json) {
    return DeletedAt(
      time: json['time'] as String?,
      valid: json['valid'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'valid': valid,
    };
  }
}
