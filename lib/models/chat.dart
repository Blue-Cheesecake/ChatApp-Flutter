import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? text;
  String? imageUrl;
  String? createdByUsername;
  String? createdById;
  Timestamp? createdAt;

  Chat({
    this.text,
    this.imageUrl,
    this.createdByUsername,
    this.createdById,
    this.createdAt,
  });

  factory Chat.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Chat(
      text: data?['text'],
      imageUrl: data?["imageUrl"],
      createdByUsername: data?["createdByUsername"],
      createdById: data?["createdById"],
      createdAt: data?["createdAt"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (text != null) "text": text,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (createdByUsername != null) "createdByUsername": createdByUsername,
      if (createdById != null) "createdById": createdById,
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}
