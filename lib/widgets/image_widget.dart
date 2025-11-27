import 'dart:io';

import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final MFile? image;
  final double width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const ImageWidget({
    super.key,
    required this.image,
    required this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: buildImage(image),
    );
  }

  Widget buildImage(MFile? image) {
    if (image != null) {
      String? path = image.path;

      if (path != null && path.isNotEmpty && path.startsWith('assets/')) {
        return Image.asset(
          image.path!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }

      if (image.publicUrl != null && image.publicUrl!.isNotEmpty) {
        return Image.network(
          image.publicUrl!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }

      return Image.file(
        File(path!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    double iconSize = width.isFinite && width > 0 ? width * 0.5 : 30.0;
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image_not_supported, size: iconSize, color: Colors.grey[600]),
    );
  }
}
