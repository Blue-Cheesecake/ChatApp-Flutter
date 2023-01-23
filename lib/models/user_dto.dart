class UserDto {
  UserDto({
    this.email,
    this.password,
  });

  String? email = "";
  String? password = "";

  bool isAllNull() {
    return email == null && password == null;
  }
}
