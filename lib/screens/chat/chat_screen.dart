import 'package:chatapp/screens/chat/widgets/messages.dart';
import 'package:chatapp/screens/chat/widgets/new_message_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messagesScrollController = ScrollController();

  @override
  void initState() {
    FirebaseMessaging fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    super.initState();
  }

  /// Somehow it work only iOS device
  ///
  ///
  void _scrollMessageDown() {
    _messagesScrollController.animateTo(
      _messagesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    // List of message
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "Public Room",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Colors.white),
        ),
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 0),
          child: Divider(
            height: 0,
            thickness: 1.5,
          ),
        ),
        actions: [
          DropdownButton(
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: "logout",
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
              )
            ],
            onChanged: (value) {
              if (value == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 15,
                ),
                child: Messages(messagesScrollCtr: _messagesScrollController),
              ),
            ),
            NewMessageForm(
              scrollMessageDownFn: _scrollMessageDown,
            ),
          ],
        ),
      ),
    );
  }
}
