import 'dart:io';

import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:widgets_spo/utils.dart';

class BannerModel {
  final String title;
  final String subtitle;
  final MFile? file;

  BannerModel({
    required this.title,
    required this.subtitle,
    required this.file,
  });
}

class BannerCarousel extends StatelessWidget {
  final List<BannerModel> banners;
  final double height;

  BannerCarousel({
    super.key,
    required this.banners,
    this.height = 300,
  });

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Stack(
                children: [
                  bannerWidget(banner.file, height),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.black87,
                          ],
                          stops: [0.4, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          Insets.small.height,
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          Insets.medium.height,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Insets.medium.height,
        if (banners.isNotEmpty)
          SmoothPageIndicator(
            controller: _controller,
            count: banners.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 5,
              dotWidth: 7,
              expansionFactor: 4,
              spacing: 6,
              dotColor: Color(0XFFefefef),
              activeDotColor: Color(0XFF040da7),
            ),
          ),
      ],
    );
  }

  Widget bannerWidget(MFile? image, double height) {
    if (image != null) {
      String? path = image.path;

      if (path != null && path.isNotEmpty && path.startsWith('assets/')) {
        return Image.asset(
          image.path!,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }

      if (image.publicUrl != null && image.publicUrl!.isNotEmpty) {
        return Image.network(
          image.publicUrl!,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }

      return Image.file(
        File(path!),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    double iconSize = 30.0;
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image_not_supported, size: iconSize, color: Colors.grey[600]),
    );
  }
}
