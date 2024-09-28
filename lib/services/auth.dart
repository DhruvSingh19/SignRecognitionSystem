import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sign_recognition/models/userInfoModel.dart';
import 'package:sign_recognition/services/database.dart';
import '../models/usermodels.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //usermodel object based on User returned by firebase
  UserModels? _userFromFirebaseUser(User user){
    return UserModels(uid: user.uid);
  }

  //sign in anonomusouly
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      AdditionalUserInfo? adduser = result.additionalUserInfo;
      try {
        await DataBaseService(uid: user!.uid).updateUserInfo(
            'New User', '', '', 'Prefer not to say', 'Prefer not to say', 1);
        return _userFromFirebaseUser(user);
      }catch(e){
        print(e.toString()+"here");
      }
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerEmailPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DataBaseService(uid: user!.uid).updateUserInfo("New User", email, '', 'Prefer not to say', 'Prefer not to say', 1);
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  ///signin with email and password
  Future signinEmailPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //link anonumous user with email id
  Future linkWithEmailPassword(String email, String password, userInfoModel userInfo) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently signed in.");
        return null;
      }

      bool isAlreadyLinked = user.providerData.any((provider) =>
      provider.providerId == EmailAuthProvider.PROVIDER_ID && provider.email == email);

      if (isAlreadyLinked) {
        print("User is already linked with this email.");
        return null;
      }

      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      await user.linkWithCredential(credential);
      print("Anonymous account upgraded to email account!");
      await DataBaseService(uid: user.uid).updateUserInfo(userInfo.name, email, userInfo.contact, userInfo.gender, userInfo.disability, userInfo.level);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Failed to link account: $e");
    }
  }

  //signout
  Future signOut() async {
    try{
      await _auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

}