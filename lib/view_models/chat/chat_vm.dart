import 'package:chatapp/constants/firebase_collection.dart';
import 'package:chatapp/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatVM {
  Stream<QuerySnapshot<Chat>> getChatStream() {
    return FirebaseFirestore.instance
        .collection(FirebaseCollectionName.firestore.chat)
        .withConverter(
          fromFirestore: Chat.fromFirestore,
          toFirestore: (value, options) => Chat().toFirestore(),
        )
        .orderBy("createdAt")
        .snapshots();
  }
}
