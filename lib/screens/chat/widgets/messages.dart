import 'package:chatapp/screens/chat/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return Text("No Data");
        }

        if (snapshot.hasError) {
          return Text("Error");
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            bool isMyMessage = FirebaseAuth.instance.currentUser?.uid ==
                docs[index]['createdById'];

            return Message(
              text: docs[index]['text'],
              isMyMessage: isMyMessage,
            );
          },
        );
      },
    );
  }
}
