import 'package:chat_location/features/map/presentation/ui/refreh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshLocation extends ConsumerStatefulWidget {
  const RefreshLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RefreshLocationState();
}

class _RefreshLocationState extends ConsumerState<RefreshLocation> {
  Future<void> _refreshLocation() async {
    // await Future.delayed(const Duration(seconds: 10)); // 예시로 2초 대기
    showModalBottomSheet(
      context: context,
      //  isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          color: Colors.white,
          child: Center(
            child: Text(
              'This is a Bottom Popup!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshButton(onRefresh: _refreshLocation);
  }
}
