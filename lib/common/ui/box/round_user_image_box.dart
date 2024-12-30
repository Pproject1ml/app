import 'package:chat_location/constants/colors.dart';
import 'package:flutter/material.dart';

Widget roundUserImageBox({String? imageUrl, double size =40, bool editable=false}){
  return  Stack(
    children: [
      SizedBox(
        height: size,
        width: size,
        child:  CircleAvatar(
          backgroundColor: TTColors.gray6,
          child: Icon(Icons.person, color: TTColors.gray2,size: size/1.2,),
        ),
      ),
      if(editable)
      const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.grey),
                    ),
                  ),
    ],
  );
}