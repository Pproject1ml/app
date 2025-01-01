import 'package:chat_location/features/map/presentation/ui/refreh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshLocation extends ConsumerStatefulWidget {
  const RefreshLocation({super.key, required this.onRefresh});
  final Future<void> Function() onRefresh;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RefreshLocationState();
}

class _RefreshLocationState extends ConsumerState<RefreshLocation> {
  Future<void> _refreshLocation() async {
    await widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshButton(onRefresh: _refreshLocation);
  }
}
