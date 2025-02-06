import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

class NetWorkImage extends StatefulWidget {
  const NetWorkImage({super.key, this.imagePath, this.defaultImage});
  final String? imagePath;
  final Widget? defaultImage;
  @override
  State<NetWorkImage> createState() => _NetWorkImageState();
}

class _NetWorkImageState extends State<NetWorkImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.imagePath == null) {
      return widget.defaultImage ?? defaultimage();
    }
    return CachedNetworkImage(
      imageUrl: widget.imagePath!,
      placeholder: (context, url) {
        // 로딩 중인 상태를 보여주는 위젯
        return widget.defaultImage ?? defaultimage();
      },
      errorWidget: (context, url, error) {
        // 에러 발생 시 기본 이미지 표시
        return widget.defaultImage ?? defaultimage();
      },
      fit: BoxFit.cover,
    );
  }

  Widget defaultimage() {
    return Container(
      color: TTColors.ttPurple,
      child: const Icon(
        Icons.map_outlined,
        color: TTColors.gray300,
      ),
    );
  }
}
