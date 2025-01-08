import 'dart:developer';

import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  const AsyncButton(
      {super.key, required this.child, required this.onClick, this.callback});

  final Widget child;
  final Future<void> Function() onClick;
  final VoidCallback? callback;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Future<void> handleClickButton() async {
    setState(() {
      _isLoading = true;
    });
    log('clicked');
    try {
      await widget.onClick();
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (widget.callback != null) {
        widget.callback!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!_isLoading) await handleClickButton();
      },
      child: Opacity(
        opacity: _isLoading ? 0.5 : 1,
        child: SizedBox(
          child: Stack(
            children: [
              widget.child,
              if (_isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
