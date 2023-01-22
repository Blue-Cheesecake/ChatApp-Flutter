import 'package:chatapp/constants/firebase_collection.dart';
import 'package:chatapp/screens/chat/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key, required this.messagesScrollCtr}) : super(key: key);

  final ScrollController messagesScrollCtr;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollectionName.firestore.chat)
          .orderBy("createdAt")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Text("No Data");
        }

        if (snapshot.hasError) {
          return const Text("Error");
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            snapshot.data!.docs;

        return ListView.builder(
          controller: messagesScrollCtr,
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            User? currentUser = FirebaseAuth.instance.currentUser;
            String? id = currentUser?.uid;
            bool isMyMessage = id == docs[index]['createdById'];

            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection(FirebaseCollectionName.firestore.users)
                  .doc(docs[index]['createdById'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                return Message(
                  text: docs[index]['text'],
                  isMyMessage: isMyMessage,
                  key: ValueKey(docs[index].id),
                  username: snapshot.data?.data()?["username"],
                  userImageUrl: snapshot.data?.data()?["imageUrl"],
                );
              },
            );
          },
        );
      },
    );
  }
}
