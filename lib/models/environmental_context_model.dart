class EnvironmentalContextModel {
  final String status;
  final String? biome;
  final String? landCover;
  final double? vegetationPercent;
  final double? waterDistanceM;
  final double? altitudeM;
  final double? slopePercent;
  final double? builtUpPercent;
  final double? populationDensityKm2;
  final DateTime? analyzedAt;
  final Map<String, dynamic> sources;

  const EnvironmentalContextModel({
    required this.status,
    this.biome,
    this.landCover,
    this.vegetationPercent,
    this.waterDistanceM,
    this.altitudeM,
    this.slopePercent,
    this.builtUpPercent,
    this.populationDensityKm2,
    this.analyzedAt,
    this.sources = const {},
  });

  factory EnvironmentalContextModel.fromJson(Map<String, dynamic> json) {
    double? number(String key) {
      final value = json[key];
      return value == null ? null : double.tryParse(value.toString());
    }

    final rawSources = json['sources'];
    return EnvironmentalContextModel(
      status: json['status']?.toString() ?? 'pending',
      biome: json['biome']?.toString(),
      landCover: json['land_cover']?.toString(),
      vegetationPercent: number('vegetation_percent'),
      waterDistanceM: number('water_distance_m'),
      altitudeM: number('altitude_m'),
      slopePercent: number('slope_percent'),
      builtUpPercent: number('built_up_percent'),
      populationDensityKm2: number('population_density_km2'),
      analyzedAt: json['analyzed_at'] == null
          ? null
          : DateTime.tryParse(json['analyzed_at'].toString()),
      sources:
          rawSources is Map ? Map<String, dynamic>.from(rawSources) : const {},
    );
  }
}
