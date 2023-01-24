import 'package:chatapp/constants/firebase_collection.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/user_collection.dart';
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
          .withConverter(
        fromFirestore: Chat.fromFirestore,
        toFirestore: (value, options) => Chat().toFirestore(),
      )
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

        List<QueryDocumentSnapshot<Chat>> docs = snapshot.data!.docs;

        return ListView.builder(
          controller: messagesScrollCtr,
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Chat chat = docs[index].data();
            User? currentUser = FirebaseAuth.instance.currentUser;
            String? id = currentUser?.uid;
            bool isMyMessage = id == chat.createdById;

            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection(FirebaseCollectionName.firestore.users)
                  .doc(chat.createdById)
                  .withConverter(
                fromFirestore: UserCollection.fromFirestore,
                toFirestore: (value, options) =>
                    UserCollection().toFirestore(),
              )
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                UserCollection userCollection = snapshot.data!.data()!;

                return Message(
                  text: chat.text ?? "-Error-",
                  isMyMessage: isMyMessage,
                  key: ValueKey(docs[index].id),
                  username: userCollection.username ?? "-username Error-",
                  userImageUrl: userCollection.imageUrl ?? "-no image-",
                );
              },
            );
          },
        );
      },
    );
  }
}
