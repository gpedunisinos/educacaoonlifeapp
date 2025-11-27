import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:widgets_spo/utils.dart';

class GradeCard extends StatelessWidget {
  final MFile? image;
  final String title;
  final String? subtitle;
  final double? progress;
  final double? finalGrade;

  const GradeCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.progress,
    this.finalGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFf3f6fd),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          ImageWidget(
            image: image,
            width: 80,
            height: 80,
          ),
          Insets.medium.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle ?? '', style: secondaryTextStyle(size: 12)),
            ],
          ),
          const Spacer(),
          if (progress != null)
            CircularPercentIndicator(
              radius: 43.0,
              lineWidth: 16.0,
              percent: progress!,
              center: Text('${(progress! * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff014fef))),
              progressColor: Color(0xff014fef),
              backgroundColor: Color(0xffb2c4ee),
            ),
          if (finalGrade != null) ...[
            Column(
              children: [
                Text('Nota Final', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text(finalGrade!.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
              ],
            ),
            Insets.medium.width,
          ]
        ],
      ),
    );
  }
}
