import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgets_spo/utils.dart';

class ItemCard extends StatelessWidget {
  final MFile? image;
  final String title;
  final String subtitle;
  final void Function()? onClick;

  const ItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        children: [
          ImageWidget(
            image: image,
            width: 100,
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: secondaryTextStyle(size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
