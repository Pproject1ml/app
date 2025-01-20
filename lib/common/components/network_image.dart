import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

class NetWorkImage extends StatefulWidget {
  const NetWorkImage({super.key, this.imagePath});
  final String? imagePath;

  @override
  State<NetWorkImage> createState() => _NetWorkImageState();
}

class _NetWorkImageState extends State<NetWorkImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.imagePath == null) {
      return defaultimage();
    }
    return Image.network(
      widget.imagePath!,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // 이미지 로드 완료 시 표시
        }
        // 로딩 중인 상태를 보여주는 위젯
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        // 에러 발생 시 기본 이미지 표시
        return defaultimage();
      },
      fit: BoxFit.cover,
    );
  }

  Widget defaultimage() {
    return const Icon(
      Icons.image_not_supported_outlined,
      color: TTColors.gray600,
    );
  }
}
