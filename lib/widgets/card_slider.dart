import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgets_spo/utils.dart';

class CardModel {
  final int id;
  final String title;
  final String subtitle;
  final MFile? image;

  CardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

class CardSlider extends StatelessWidget {
  final double height;
  final String? title;
  final List<CardModel> items;
  final Widget Function(CardModel)? buttonBuilder;

  const CardSlider({
    super.key,
    required this.height,
    this.title,
    required this.items,
    this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
          Insets.medium.height,
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => Insets.medium.width,
              itemBuilder: (context, index) {
                final item = items[index];
                return ContentCard(
                  height: height,
                  item: item,
                  buttonBuilder: buttonBuilder,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final double height;
  final CardModel item;
  final Widget Function(CardModel)? buttonBuilder;

  const ContentCard({
    super.key,
    required this.height,
    required this.item,
    this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFf3f6fd),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 6,
            child: ImageWidget(
              image: item.image,
              width: double.infinity,
              height: 180,
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (buttonBuilder != null) ...[
                    buttonBuilder!(item),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
