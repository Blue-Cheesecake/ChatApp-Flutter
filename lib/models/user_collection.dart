import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollection {
  UserCollection({this.username, this.email, this.imageUrl});

  String? username;
  String? email;
  String? imageUrl;

  factory UserCollection.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserCollection(
      username: data?["username"],
      email: data?["email"],
      imageUrl: data?["imageUrl"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (imageUrl != null) "imageUrl": imageUrl,
    };
  }
}
