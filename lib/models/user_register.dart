import 'dart:io';

class UserRegister {
  UserRegister({
    this.email,
    this.username,
    this.password,
    this.imageFile,
  });

  String? email = "";
  String? username = "";
  String? password = "";
  File? imageFile;

  bool isAllNull() {
    return email == null &&
        username == null &&
        password == null &&
        imageFile == null;
  }
}
