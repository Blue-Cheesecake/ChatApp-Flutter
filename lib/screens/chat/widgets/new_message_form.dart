import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageForm extends StatefulWidget {
  NewMessageForm({Key? key}) : super(key: key);

  @override
  State<NewMessageForm> createState() => _NewMessageFormState();
}

class _NewMessageFormState extends State<NewMessageForm> {
  final _msgCtr = TextEditingController();

  void _submitMessage() async {
    FocusScope.of(context).unfocus();
    String? id = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(id ?? "")
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _msgCtr.text,
      "createdAt": Timestamp.now(),
      "createdById": id ?? "",
      "createdByUsername": userData["username"]
    });
    _msgCtr.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtr,
              decoration: InputDecoration(
                labelText: "New message",
                border: null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            onPressed: _msgCtr.text.trim().isEmpty ? null : _submitMessage,
            icon: Icon(
              Icons.send_rounded,
              color: _msgCtr.text.trim().isEmpty
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
