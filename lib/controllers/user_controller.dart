import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wecount/models/user_model.dart';

class UserController extends GetxController {
  Rxn<UserModel> user = Rxn<UserModel>();

  static UserController get to => Get.find();

  final CollectionReference<UserModel> userRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (snapshot, _) => UserModel.fromJson(
              snapshot.data(),
              snapshot.id,
            ),
            toFirestore: (user, _) => user.toJson(),
          );

  User get currentUser {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw ("Current user not found.");
    }

    return FirebaseAuth.instance.currentUser!;
  }

  bool isSignIn() => FirebaseAuth.instance.currentUser != null;

  void listenUser(
      void Function(DocumentSnapshot<UserModel> snapshot) onUserChanged) {
    userRef.doc(currentUser.uid).snapshots().listen(
          onUserChanged,
        );
  }
}
