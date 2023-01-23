import 'package:chatapp/constants/firebase_collection.dart';
import 'package:chatapp/models/user_collection.dart';
import 'package:chatapp/models/user_dto.dart';
import 'package:chatapp/models/user_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SubmitFormUtils {
  /// Try register the user using Firebase Auth & Firestore by accepting
  /// UserRegister as a request from Form
  ///
  /// Throw [NullThrownError] if the image wasn't provided
  ///
  static Future<void> registerUser(UserRegister request) async {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    // The image can't be null
    if (request.isAllNull()) {
      throw NullThrownError();
    }

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: request.email!,
      password: request.password!,
    );

    // Define the path of file
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(FirebaseCollectionName.storage.userImages)
        .child(userCredential.user?.uid ?? "error_file");

    // Actual uploading the file to the path
    await storageRef.putFile(request.imageFile!);

    // Get the URL
    String imageUrl = await storageRef.getDownloadURL();

    // Register username and email to Firestore
    final userCollection = UserCollection(
      username: request.username,
      email: request.email,
      imageUrl: imageUrl,
    );

    final dbRef = db
        .collection(FirebaseCollectionName.firestore.users)
        .withConverter(
          fromFirestore: UserCollection.fromFirestore,
          toFirestore: (value, options) => userCollection.toFirestore(),
        )
        .doc(userCredential.user!.uid);

    dbRef.set(userCollection);
  }

  static Future<void> loginUser(UserDto request) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (request.isAllNull()) {
      throw NullThrownError();
    }

    await auth.signInWithEmailAndPassword(
      email: request.email!,
      password: request.password!,
    );
  }
}
