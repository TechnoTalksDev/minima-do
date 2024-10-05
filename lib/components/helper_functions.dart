import 'package:flutter/material.dart';

void displayMessage(String message, String type, BuildContext context) {
  
  IconData icon = Icons.info_outline;

  switch (type) {
    case "error":
      icon = Icons.warning_amber;
    default:
      icon = Icons.info_outline;
  }

  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.all(20),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 10,),
          Text(message, style: TextStyle(fontSize: 18),),
        ],
      ),
    )
  );
}