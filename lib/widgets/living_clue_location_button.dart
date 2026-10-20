import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_location_screen.dart';

class LivingClueLocationButton extends StatelessWidget {
  const LivingClueLocationButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });
  final TextEditingController latitude;
  final TextEditingController longitude;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    icon: const Icon(Icons.add_location_alt_outlined),
    label: const Text('Escolher localização no mapa'),
    onPressed: () async {
      final lat = double.tryParse(latitude.text.replaceAll(',', '.'));
      final lon = double.tryParse(longitude.text.replaceAll(',', '.'));
      final valid =
          lat != null &&
          lon != null &&
          lat.isFinite &&
          lon.isFinite &&
          lat.abs() <= 90 &&
          lon.abs() <= 180;
      final point = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (_) => LivingClueLocationScreen(
            initialPoint: valid ? LatLng(lat, lon) : null,
          ),
        ),
      );
      if (!context.mounted || point == null) return;
      latitude.text = point.latitude.toStringAsFixed(6);
      longitude.text = point.longitude.toStringAsFixed(6);
    },
  );
}
