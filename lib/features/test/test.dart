import 'package:flutter/material.dart';

class ExpandablePopupExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 상단 고정 영역

          // 아래 드래그 가능한 팝업 영역
          DraggableScrollableSheet(
            initialChildSize: 0.3, // 초기 크기 (30%)
            minChildSize: 0.3, // 최소 크기
            maxChildSize: 0.8, // 최대 크기
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<String> _messages = []; // 메시지 목록

//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         _messages.insert(0, text); // 새 메시지를 리스트 앞에 추가
//       });
//       _messageController.clear(); // 입력 필드 초기화
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Room'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // 메시지 목록
//           Expanded(
//             child: ListView.builder(
//               reverse: true, // 최신 메시지가 위에 표시되도록
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0, vertical: 4.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft, // 메시지를 왼쪽 정렬
//                     child: Container(
//                       padding: const EdgeInsets.all(12.0),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[100],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Text(
//                         _messages[index],
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // 입력 필드와 전송 버튼
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 // 메시지 입력 필드
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 // 전송 버튼
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
