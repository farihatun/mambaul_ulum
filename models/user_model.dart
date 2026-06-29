class UserModel {
  int? id;
  String nama;
  String email;
  String password;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
    };
  }
}