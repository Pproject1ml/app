import 'dart:math';

import 'package:chat_location/common/ui/box/chat_ballon_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'dart:ui'
    as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
import 'package:flutter/services.dart';

Set<Circle> createCircle(LatLng position) {
  Set<Circle> _circles = {};

  _circles = {
    Circle(
      circleId: CircleId("outer_circle"),
      center: position,
      radius: 5000, // 외측 반경
      fillColor: const Color.fromRGBO(141, 155, 255, 0.5),
      strokeWidth: 0,
    ),
  };

  return _circles;
}

Future<BitmapDescriptor> createLandmarkMarkers() async {
  final _markerIcon = await const ChatBallon(chat: '999+').toBitmapDescriptor(
      logicalSize: const Size(150, 150), imageSize: const Size(150, 150));
  return _markerIcon;
}

Future<BitmapDescriptor> svgToBitmapDescriptor(
  context,
  assetName,
) async {
  final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);
  Size size = const Size(48, 48);
  double devicePixelRatio = ui.window.devicePixelRatio;
  int width = (size.width * devicePixelRatio).toInt();
  int height = (size.height * devicePixelRatio).toInt();

  final scaleFactor = min(
    width / pictureInfo.size.width,
    height / pictureInfo.size.height,
  );

  final recorder = ui.PictureRecorder();

  ui.Canvas(recorder)
    ..scale(scaleFactor)
    ..drawPicture(pictureInfo.picture);

  final rasterPicture = recorder.endRecording();

  final image = rasterPicture.toImageSync(width, height);
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}
