import 'package:cloud_firestore/cloud_firestore.dart';

class Password {
  final String? id;
  final String userId;
  final String website;
  final String? username;
  final String encryptedPassword;
  final String iv;

  Password({
    this.id,
    required this.userId,
    required this.website,
    this.username,
    required this.encryptedPassword,
    required this.iv,
  });

  factory Password.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    Map data = snapshot.data() as Map;
    return Password(
      id: snapshot.id,
      userId: data['userId'],
      website: data['website'],
      username: data['username'],
      encryptedPassword: data['encryptedPassword'],
      iv: data['iv'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userId': userId,
      'website': website,
      'encryptedPassword': encryptedPassword,
      'iv': iv,
    };

    if (id != null) {
      map['id'] = id!;
    }

    if (username != null) {
      map['username'] = username!;
    }

    if (id != null && username == null) {
      map['username'] = FieldValue.delete();
    }

    return map;
  }
}
