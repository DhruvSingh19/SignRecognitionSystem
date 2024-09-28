import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_recognition/screens/authenticate/registerPage.dart';
import 'package:sign_recognition/screens/currPageState.dart';
import '../../services/auth.dart';
import '../profilePage.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final Username = TextEditingController();

  final password = TextEditingController();

  final AuthService _auth = AuthService();


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
                height: 50,
              ),
              const Center(
                  child: Icon(
                Icons.lock,
                size: 110,
                    color: Colors.black,
              )),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome back !!",
                      style: TextStyle(
                          fontSize: 27,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(
                height: 10,
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
                padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
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
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5.0, 20.0, 10.0),
                    child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        )),
                  )),
              GestureDetector(
                onTap: () {
                  signIn(false);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: Container(
                    height: 60,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Sign In",
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
                "Or",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async{
                  bool? result = await showElevatedDialog(context);
                  if(result==true) {
                    signIn(true);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  child: Container(
                    height: 60,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Sign In as a Guest",
                      style:
                          TextStyle(fontSize: 19, color: Colors.grey.shade300),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.shade800,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => registerPage()));
                      },
                      child: Text(
                        "Register now",
                        style: TextStyle(color: Colors.blue.shade500),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signIn(bool isGuest) async {
    if (isGuest) {
      dynamic result = await _auth.signInAnon();
      if (result == null) {
        Fluttertoast.showToast(
            msg: "An error occurred!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2);
      } else {
        print("inside hhere");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const currPageState()),
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } else {
      if (Username.text
          .trim()
          .isEmpty || password.text
          .trim()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter all fields!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2);
      } else {
        dynamic result =
        await _auth.signinEmailPassword(Username.text, password.text);
        if (result == null) {
          Fluttertoast.showToast(
              msg: "Invalid Credentials!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2);
          // } else {
          //   print("inside hhere");
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => const currPageState()),
          //         (Route<dynamic> route) => false, // Remove all previous routes
          //   );
          // }
          //Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context)=>homepage()));
        }
      }
    }
  }

  Future<bool?> showElevatedDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          elevation: 24.0,
          title: const Text('Your data may be lost if you sign in as a guest'),
          content: const Text('Are you sure you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text('OK',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
