import 'dart:developer';

import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/user/presentation/ui/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionTile extends StatefulWidget {
  const NotificationPermissionTile({super.key});

  @override
  State<NotificationPermissionTile> createState() =>
      _NotificationPermissionTileState();
}

class _NotificationPermissionTileState extends State<NotificationPermissionTile>
    with WidgetsBindingObserver {
  String _permissionStatus = "Unknown";
  Future<void> _requestNotificationPermission() async {
    await openAppSettings();
  }

  Future<void> _checkPermissionStatus() async {
    PermissionStatus status = await Permission.notification.status;
    setState(() {
      if (status.isGranted) {
        _permissionStatus = "Granted";
      } else if (status.isDenied) {
        _permissionStatus = "Denied";
      } else if (status.isPermanentlyDenied) {
        _permissionStatus = "Permanently Denied";
      } else {
        _permissionStatus = "Unknown";
      }
    });
  }

  Future<void> _getCurrentPermissionStatus() async {
    PermissionStatus currentStatus = await Permission.notification.status;

    setState(() {
      if (currentStatus.isGranted) {
        _permissionStatus = "Granted";
      } else if (currentStatus.isDenied) {
        _permissionStatus = "Denied";
      } else if (currentStatus.isPermanentlyDenied) {
        _permissionStatus = "Permanently Denied";
      } else {
        _permissionStatus = "Unknown";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPermissionStatus();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer on dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app resumes, check the permission status
      _checkPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return mypageMenuItem(
      backgroundColor: Theme.of(context).cardTheme.color,
      textColor: Theme.of(context).textTheme.bodyMedium?.color,
      onTap: _requestNotificationPermission,
      title: '채팅 푸시알림',
      subTitle: "기기 설정을 변경해야 알림을 받을 수 있어요.",
      trailing: SizedBox(
        height: heightRatio(24),
        width: widthRatio(40),
        child: Switch(
            overlayColor: MaterialStateProperty.resolveWith(
              (final Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
            thumbColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return Colors.white;
            }),
            trackOutlineColor: MaterialStateProperty.resolveWith(
              (final Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
            activeColor: TTColors.ttPurple,
            activeTrackColor: TTColors.ttPurple.withOpacity(1.0),
            inactiveTrackColor: TTColors.gray300.withOpacity(1.0),
            value: _permissionStatus == "Granted",
            onChanged: (value) {}),
      ),
    );
  }
}
