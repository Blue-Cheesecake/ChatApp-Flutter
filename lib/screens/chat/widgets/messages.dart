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
            User? currentUser = FirebaseAuth.instance.currentUser;
            String? id = currentUser?.uid;
            bool isMyMessage = id == docs[index]['createdById'];

            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(docs[index]['createdById'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Message(
                  text: docs[index]['text'],
                  isMyMessage: isMyMessage,
                  key: ValueKey(docs[index].id),
                  username: snapshot.data?.data()?["username"],
                );
              },
            );
          },
        );
      },
    );
  }
}
