// Author: Pham (Sky) Truong
// Description: Sign in page
// Last revised: April 3, 2021

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gettechapp/pages/HomePage.dart';
import 'package:gettechapp/pages/sign_up_page.dart';
import '../components/custom_app_bar.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(preferredHeight: screenHeight / 6),
      body: SignInForm(),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignInFormState');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _passwordVisible;

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, 'Failed to login', e);
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
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double mediumMultiplier = 4;
    double smallMultiplier = 3;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            // Sign-in Header
            _buildSignInHeader(
                mediumMultiplier: mediumMultiplier,
                unitHeightValue: unitHeightValue),

            // Mid section
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  // Username
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                  ),

                  // Password
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                  ),
                ],
              ),
            ),
            // Forgot password
            _buildForgotPassword(),

            // // Buttons section
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  // Sign-in button
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Color.fromRGBO(255, 197, 66, 1.0),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signInWithEmailAndPassword(_emailController.text,
                                  _passwordController.text);
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Create account button
                  _buildCreateAccButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _buildSignInHeader extends StatelessWidget {
  const _buildSignInHeader({
    Key? key,
    required this.mediumMultiplier,
    required this.unitHeightValue,
  }) : super(key: key);

  final double mediumMultiplier;
  final double unitHeightValue;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Text(
        "Welcome!",
        style: TextStyle(
            fontSize: mediumMultiplier * unitHeightValue,
            color: Colors.white,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _buildForgotPassword extends StatelessWidget {
  const _buildForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text("Forgot Password"),
    );
  }
}

class _buildCreateAccButton extends StatelessWidget {
  const _buildCreateAccButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Color.fromRGBO(255, 197, 66, 1.0),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignUpPage(),
                ),
              );
            },
            child: Text(
              'Create new account',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
