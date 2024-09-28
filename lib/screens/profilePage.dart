import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_recognition/models/userInfoModel.dart';
import 'package:sign_recognition/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> disabilityOptions = ['Deaf', 'Blind', 'Mute','Prefer not to say'];

  String? _gender;
  String? _disability;

  final user = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    print(DataBaseService(uid: user!.uid).getCurrUserInfo);
    return StreamBuilder<userInfoModel>(
        stream: DataBaseService(uid: user!.uid).getCurrUserInfo,
        builder: (BuildContext context, AsyncSnapshot<userInfoModel> snapshot) {
          userInfoModel? currUserInfo = snapshot.data;
          print("thissss");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User information not found.'));
          }
          if (snapshot.hasData) {

            if (_nameController.text.isEmpty && currUserInfo!=null) {
              _nameController.text = currUserInfo.name ?? '';
              _emailController.text = currUserInfo.email ?? '';
              _contactController.text = currUserInfo.contact ?? '';
              _gender = currUserInfo.gender;
              _disability = currUserInfo.disability;
            }
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          hintText: 'Contact number',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Please enter your contact number' : null,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        value: _gender,
                        decoration: InputDecoration(
                          hintText: 'Gender',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Colors.black,
                        items: genderOptions.where((option)=>option.isNotEmpty).map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _gender = val.toString();
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        value: _disability,
                        decoration: InputDecoration(
                          hintText: 'Disability',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Colors.black,
                        items: disabilityOptions.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _disability = val.toString();
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              print("done not Update");
                              if (currUserInfo != null) {
                                await DataBaseService(uid: user!.uid).updateUserInfo(
                                  _nameController.text,
                                  _emailController.text,
                                  _contactController.text,
                                  _gender!, // gender null check
                                  _disability!, // disability null check
                                  currUserInfo.level, // level from current user
                                );
                                print("done Update");
                                Fluttertoast.showToast(
                                  msg: "Updated Successfully!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                );
                                // This will only print if the Firestore operation is successful
                                //Navigator.pop(context); // Navigate back after update
                              } else {
                                print("Error: currUserInfo is null.");
                                Fluttertoast.showToast(
                                  msg: "User information is not available.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                );
                              }
                            } catch (e) {
                              print("Error updating Firestore: $e"); // Print any Firestore errors
                              Fluttertoast.showToast(
                                msg: "Failed to update profile. Please try again.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please fill correct details!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[800],
                          ),
                          width: 100,
                          height: 40,
                          child: const Center(
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Future<void> showElevatedDialog(BuildContext context, userInfoModel currUserInfo) {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade200,
        elevation: 24.0,
        title: const Text('Enter the email to be linked'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
                child: TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Submit", style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              final username = usernameController.text;
              final password = passwordController.text;
              final confirmPassword = confirmPasswordController.text;
              if (password == confirmPassword) {
                await _auth.linkWithEmailPassword(username, password, currUserInfo);
                Navigator.of(context).pop();
              } else {
                // Handle password mismatch case
              }
            },
          ),
        ],
      );
    },
  );
}
