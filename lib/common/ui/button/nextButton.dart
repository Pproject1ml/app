import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

// class bottomNextButton extends StatefulWidget {
//   bottomNextButton(
//       {super.key,
//       required this.isDisabled,
//       required this.text,
//       required this.onPressed});
//   final bool isDisabled;
//   final String text;
//   final Future<void> onPressed;

//   @override
//   State<bottomNextButton> createState() => _bottomNextButtonState();
// }

// class _bottomNextButtonState extends State<bottomNextButton> {
//   bool _isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = widget.isDisabled;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: () async {
//           setState(() {
//             _isLoading = true;
//           });
//           _isLoading ? null : await widget.onPressed;
//           setState(() {
//             _isLoading = false;
//           });
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _isLoading ? TTColors.gray5 : TTColors.ttPurple,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           minimumSize: const Size(double.infinity, 52),
//         ),
//         child: Text(
//           widget.text,
//           style: TextStyle(
//               fontSize: 16,
//               color: _isLoading ? TTColors.gray : Colors.white,
//               letterSpacing: -0.3,
//               height: 1.22,
//               fontWeight: FontWeight.normal),
//         ));
//   }
// }
Widget bottomNextButton(
    {bool isDisabled = false,
    required String text,
    required Function onPressed}) {
  return ElevatedButton(
      onPressed: () async {
        isDisabled ? null : await onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? TTColors.gray5 : TTColors.ttPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: isDisabled ? TTColors.gray : Colors.white,
            letterSpacing: -0.3,
            height: 1.22,
            fontWeight: FontWeight.normal),
      ));
}
