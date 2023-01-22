import 'package:chatapp/constants/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageForm extends StatefulWidget {
  const NewMessageForm({Key? key, required this.scrollMessageDownFn})
      : super(key: key);

  final Function scrollMessageDownFn;

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
    FirebaseFirestore.instance
        .collection(FirebaseCollectionName.firestore.chat)
        .add({
      "text": _msgCtr.text,
      "createdAt": Timestamp.now(),
      "createdById": id ?? "",
      "createdByUsername": userData["username"],
      "imageUrl": userData["imageUrl"],
    });
    _msgCtr.text = "";

    widget.scrollMessageDownFn();
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
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                labelText: "New message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),
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
