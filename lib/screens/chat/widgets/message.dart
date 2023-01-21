import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message(
      {Key? key,
      required this.text,
      required this.isMyMessage,
      required this.username})
      : super(key: key);

  final String text;
  final bool isMyMessage;
  final String username;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(16.6);
    const zero = Radius.zero;

    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isMyMessage
                    ? Colors.grey.shade200
                    : Colors.deepPurpleAccent.shade400,
                borderRadius: BorderRadius.only(
                  topRight: radius,
                  topLeft: radius,
                  bottomLeft: isMyMessage ? radius : zero,
                  bottomRight: isMyMessage ? zero : radius,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMyMessage ? Colors.black : Colors.white,
                ),
              ),
            ),
            Text(isMyMessage ? "Me" : username),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}