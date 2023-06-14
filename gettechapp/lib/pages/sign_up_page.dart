// Author: Pham (Sky) Truong
// Description: Sign up page
// Last revised: April 3, 2021

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gettechapp/components/custom_app_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gettechapp/pages/HomePage.dart';
import 'package:gettechapp/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_data.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final User? currentUser = _firebaseAuth.currentUser;

String getCurrentUID() {
  final uid = currentUser!.uid;
  return uid;
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(preferredHeight: screenHeight / 6),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUnFormState');
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  UserData userData = UserData("", "", "");
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  Future<void> registerAccount(
      String email, String displayName, String password) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      userData.displayName = _nameController.text;
      userData.email = _emailController.text;
      userData.zipcode = _zipcodeController.text;
      db.collection('userData').doc(getCurrentUID()).set(userData.toJson());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, 'Failed to create account', e);
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double mediumMultiplier = 4;
    double smallMultiplier = 3;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      "Sign Up!",
                      style: TextStyle(
                          fontSize: mediumMultiplier * unitHeightValue,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  // Full name
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.person,
                            color: Color.fromRGBO(184, 146, 62, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter fullname";
                                }
                                return null;
                              },
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Full Name",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Username
                  // Padding(
                  //   padding:
                  //       EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                  //   child: Row(
                  //     children: [
                  //       Flexible(
                  //         flex: 1,
                  //         fit: FlexFit.tight,
                  //         child: Icon(
                  //           Icons.account_box_rounded,
                  //           color: Color.fromRGBO(184, 146, 62, 1.0),
                  //         ),
                  //       ),
                  //       Flexible(
                  //         flex: 6,
                  //         fit: FlexFit.tight,
                  //         child: Container(
                  //           child: TextFormField(
                  //             validator: (val) {
                  //               if (val == null || val.isEmpty) {
                  //                 return "Please enter username";
                  //               } else if (val.length < 5) {
                  //                 return "Username has to contain at least 5 characters.";
                  //               }
                  //               return null;
                  //             },
                  //             controller: _usernameController,
                  //             style: TextStyle(color: Colors.white),
                  //             decoration: InputDecoration(
                  //               border: UnderlineInputBorder(),
                  //               hintText: "Username",
                  //               hintStyle: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Location
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(184, 146, 62, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter zipcode";
                                } else if (RegExp(r"^[0-9]{5}(?:-[0-9]{4})?$",
                                            caseSensitive: false)
                                        .hasMatch(val) ==
                                    false) {
                                  return "Incorrect zipcode";
                                }
                                return null;
                              },
                              controller: _zipcodeController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Zip Code",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Email
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.email_rounded,
                            color: Color.fromRGBO(184, 146, 62, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter email";
                                } else if (!EmailValidator.validate(
                                    val, true)) {
                                  return "Invalid email address";
                                }
                                return null;
                              },
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.email_rounded,
                            color: Color.fromRGBO(184, 146, 62, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please confirm email";
                                } else if (val != _emailController.text) {
                                  return "Emails dont't match";
                                }
                                return null;
                              },
                              controller: _confirmEmailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Confirm Email",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Password
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.lock_rounded,
                            color: Color.fromRGBO(255, 87, 95, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter password";
                                } else if (val.length < 6) {
                                  return "Password has to contain at least 8 characters.";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.only(left: 8.0, right: 60.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Icon(
                            Icons.lock_rounded,
                            color: Color.fromRGBO(255, 87, 95, 1.0),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Container(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please confirm password";
                                } else if (val != _passwordController.text) {
                                  return "Passwords don't match";
                                }
                                return null;
                              },
                              controller: _confirmPasswordController,
                              obscureText: !_confirmPasswordVisible,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Confirm password",
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white24,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordVisible =
                                          !_confirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Done button
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 60.0, left: 60.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                                  Color.fromRGBO(255, 197, 66, 1.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerAccount(
                                    _emailController.text,
                                    _nameController.text,
                                    _passwordController.text);
                              }
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cancel button
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 60.0, left: 60.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                                  Color.fromRGBO(255, 197, 66, 1.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
