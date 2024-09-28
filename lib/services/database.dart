import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_recognition/models/userInfoModel.dart';

class DataBaseService{
  final String uid;
  DataBaseService({required this.uid});

  final CollectionReference userColl = FirebaseFirestore.instance.collection('userInfo');

  //update
  Future updateUserInfo(String name, String email, String contact, String gender, String disability, int level) async{
    return await userColl.doc(uid).set({
      'name': name,
      'email': email,
      'contact': contact,
      'gender': gender,
      'disability': disability,
      'level': level,
    });
  }

  //it takes querysnapshot i.e. for all entries
  List<userInfoModel> _userInfoModelFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((e){
      return userInfoModel(
          email: e.get('email')??'',
          contact: e.get('contact')??'',
          disability: e.get('disability')??'Prefer not to say',
          level: e.get('level'),
          gender: e.get('gender')??'Prefer not to say',
          name: e.get('name')??'');
    }).toList();
  }

  //this fetches data for all the entries in the firestore, not depend on uid
  Stream<List<userInfoModel>>? get getAllUserInfo{
    return userColl.snapshots().map(_userInfoModelFromSnapshot);
  }

  //this method is not used, since there is no service where qwe need all the entries data
  //this fetches data for one entry
  userInfoModel _userInfoModelFromDocument(DocumentSnapshot snapshot){
    print("here here");
    return userInfoModel(
        email: snapshot.get('email')??'',
        contact: snapshot.get('contact')??'',
        disability: snapshot.get('disability')??'Prefer not to say',
        level: snapshot.get('level')??'',
        gender: snapshot.get('gender')??'Prefer not to say',
        name: snapshot.get('name'));
  }

  //this fetches data for a single entry whose uid is passed
  Stream<userInfoModel> get getCurrUserInfo{
    return userColl.doc(uid).snapshots().map(_userInfoModelFromDocument);
}
}