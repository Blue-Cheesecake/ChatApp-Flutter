class FirebaseCollectionName {
  static Firestore firestore = const Firestore();
  static const storage = Storage();
}

class Firestore {
  const Firestore();

  String get chat => "chat";

  String get users => "users";
}

class Storage {
  const Storage();

  String get userImages => "user_images";
}
