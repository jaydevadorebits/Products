import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:products/model/user.dart';
import 'package:uuid/uuid.dart';

class AuthenticationProvider with ChangeNotifier {
  var collection = FirebaseFirestore.instance.collection('Users');

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; //_auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> addUser(String userId, String firstName, String lastName,
      String mobile, String email, String gender, String dob) async {
    print('add_user_repository1->');
    var uuid = Uuid();
    var uuId = uuid.v1();
    final userObj = {
      "id": userId,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "email": email,
      "gender": gender,
      "dob": dob,
    };
    final res = await add_user(userObj, userId);
    if (res != null) {
      print('user_added');
      UserModel userModel = UserModel();
      userModel.userId = uuId;
      userModel.firstName = firstName;
      userModel.lastName = lastName;
      userModel.mobile = mobile;
      userModel.email = email;
      userModel.gender = gender;
      userModel.dob = dob;
      return userModel;
    }
    return null;
  }

  Future<String> add_user(Map<String, String> todoObj, String userId) async {
    var noteId = userId; //_auth.currentUser!.uid;
    print('add_user->' + noteId);

    //await collection.doc('Users').collection(userId).doc(noteId).set(todoObj);
    await collection.doc(noteId).set(todoObj);
    return noteId;
  }

  Future<UserModel> getUserDetails(String userId) async {
    print('get_user_details');
    var snapshot = await collection.doc(userId).get();
    //print('value ' + snapshot['firstName']);

    late UserModel userModel = UserModel();

    userModel.firstName = snapshot['firstName'];
    userModel.lastName = snapshot['lastName'];
    userModel.mobile = snapshot['mobile'];
    userModel.email = snapshot['email'];
    userModel.gender = snapshot['gender'];
    userModel.dob = snapshot['dob'];
    /*var documents = val.docs;

    if (documents.length > 0) {
      for (var snapshot in documents) {
        userModel.firstName = snapshot['firstName'];
        userModel.lastName = snapshot['lastName'];
        userModel.mobile = snapshot['mobile'];
        userModel.email = snapshot['email'];
        userModel.gender = snapshot['gender'];
        userModel.dob = snapshot['dob'];
      }
    }*/
    return userModel;
  }
}
