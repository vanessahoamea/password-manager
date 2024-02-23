import 'package:cloud_firestore/cloud_firestore.dart';

class Password {
  final String id;
  final String userId;
  final String website;
  final String? username;
  final String encryptedPassword;

  Password({
    required this.id,
    required this.userId,
    required this.website,
    this.username,
    required this.encryptedPassword,
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
    );
  }

  Map<String, String?> toMap() {
    return {
      'id': id,
      'userId': userId,
      'website': website,
      'username': username,
      'encryptedPassword': encryptedPassword,
    };
  }
}
