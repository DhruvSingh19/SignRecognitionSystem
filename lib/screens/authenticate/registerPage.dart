import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_recognition/screens/currPageState.dart';
import '../../services/auth.dart';
import '../homePage.dart';

class registerPage extends StatelessWidget {
  final Username = TextEditingController();
  final password = TextEditingController();
  final confpassword = TextEditingController();
  final AuthService _auth = AuthService();
  // Future signUp() async{
  //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email:Username.text.trim() , password: password.text.trim());
  //   Navigator.
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.black,
                    size: 110,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 5, 0, 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome,",
                      style: TextStyle(
                          fontSize: 27,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 5, 0, 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Were waiting for you !!",
                      style: TextStyle(
                          fontSize: 27,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
                child: TextField(
                  controller: Username,
                  style: const TextStyle(color: Colors.black),
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
                padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
                child: TextField(
                  controller: password,
                  style: const TextStyle(color: Colors.black),
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
                padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                child: TextField(
                  controller: confpassword,
                  style: const TextStyle(color: Colors.black),
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
              GestureDetector(
                onTap: () async {
                  if (Username.text.toString().isEmpty ||
                      password.text.toString().isEmpty ||
                      confpassword.text.toString().isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Enter all fields !!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                    );
                  } else if (password.text.length < 8) {
                    Fluttertoast.showToast(
                      msg: "Password should be minimum 8 characters!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                    );
                  } else if (password.text.toString() !=
                      confpassword.text.toString()) {
                    Fluttertoast.showToast(
                      msg: "Both passwords should be same !!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                    );
                  } else {
                    dynamic result = await _auth.registerEmailPassword(
                        Username.text, password.text);
                    if (result == null) {
                      Fluttertoast.showToast(
                          msg: "Supply valid credentials!!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2);
                    // }else{
                    //   Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => const currPageState()),
                    //         (Route<dynamic> route) => false, // Remove all previous routes
                    //   );
                    //   // Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context)=>homepage()));
                    // }
                  }
                }},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                  child: Container(
                    height: 60,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                          "Sign Up",
                          style:
                          TextStyle(fontSize: 19, color: Colors.grey.shade300),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.shade800,
              ),
              Text(
                "Or continue with",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                          image: DecorationImage(
                              image: AssetImage('assets/images/google.png'))),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                          image: DecorationImage(
                              image: AssetImage('assets/images/apple.jpg'))),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
