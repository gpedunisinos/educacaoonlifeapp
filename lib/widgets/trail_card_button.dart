import 'package:unisinos_usp_app/widgets/card_slider.dart';
import 'package:flutter/material.dart';

class TrailCardButton extends StatelessWidget {
  final CardModel item;
  final String title;
  final VoidCallback? onTap;

  const TrailCardButton({
    super.key,
    required this.item,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 30,
            width: 100,
            decoration: const BoxDecoration(
              color: Color(0xffcbdcfc),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                title,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
