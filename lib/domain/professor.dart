import 'package:cloud_firestore/cloud_firestore.dart';

class Professor {
  final String id;
  final String name;
  final bool isAdmin;
  final String password;

  Professor({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.password,
  });

  factory Professor.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Professor(
      id: snapshot.id,
      name: data?["name"] as String,
      isAdmin: data?["is_admin"] ?? false,
      password: data?["password"] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "isAdmin": isAdmin,
      "password": password,
    };
  }
}
