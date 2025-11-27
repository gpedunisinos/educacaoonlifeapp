import 'dart:convert';
import 'dart:io';

import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileImage extends StatelessWidget {
  final MFile? profilePicture;
  final double radius;

  const ProfileImage({
    super.key,
    this.profilePicture,
    this.radius = 26,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF084CEC),
      child: profilePicture != null
          ? ClipOval(
              child: profilePhoto(),
            )
          : SvgPicture.asset(
              'assets/icons/user.svg',
              package: 'widgets_spo',
              width: radius * 2 - 2,
              height: radius * 2 - 2,
            ),
    );
  }

  Widget profilePhoto() {
    if (profilePicture!.path != null && profilePicture!.path!.isNotEmpty) {
      return Image.file(
        File(profilePicture!.path!),
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    } else if (profilePicture!.bytes != null && profilePicture!.bytes!.isNotEmpty ||
        profilePicture!.base64 != null && profilePicture!.base64!.isNotEmpty) {
      return Image.memory(
        profilePicture!.bytes != null ? profilePicture!.bytes! : base64Decode(profilePicture!.base64!),
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    return Image.network(
      profilePicture!.publicUrl!,
      fit: BoxFit.cover,
      width: radius * 2,
      height: radius * 2,
    );
  }
}
