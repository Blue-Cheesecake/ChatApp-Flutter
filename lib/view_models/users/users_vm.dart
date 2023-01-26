import 'package:chatapp/constants/firebase_collection.dart';
import 'package:chatapp/models/user_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersVM {
  Future<DocumentSnapshot<UserCollection>> getSingleUserWithChatId(
      String? chatId) {
    return FirebaseFirestore.instance
        .collection(FirebaseCollectionName.firestore.users)
        .doc(chatId)
        .withConverter(
          fromFirestore: UserCollection.fromFirestore,
          toFirestore: (value, options) => UserCollection().toFirestore(),
        )
        .get();
  }
}
