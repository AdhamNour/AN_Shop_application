import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: AuthWidget(),
      ),
    );
  }
}

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _isLogingIn = true;

  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  String email, password, username;

  void signUp() async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({UserName: username});
    } catch (e) {
      print(e);
    }
  }

  void signIn() async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialogx('your email is sadly not found in our databases');
      } else if (e.code == 'wrong-password') {
        showDialogx(
            'Wrong password provided for that user, you may mistyped it. Try Again');
      }
    }
  }

  Future showDialogx(String text) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.toUpperCase()),
        content: Column(
          children: [
            Icon(
              Icons.error,
              size: 60,
              color: Theme.of(context).errorColor,
            ),
            Text(text)
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('O. K.'))
        ],
      ),
    );
  }

  void _trySubmet() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if (_isLogingIn) {
      signIn();
    } else {
      signUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    validator: (value) => EmailValidator.validate(value)
                        ? null
                        : 'enter a valid email',
                    onSaved: (newValue) => email = newValue,
                  ),
                  if (!_isLogingIn)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Your username'),
                      onSaved: (newValue) => username = newValue,
                    ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    validator: (value) => estimatePasswordStrength(value) < 0.3
                        ? 'this password is week !'
                        : null,
                    controller: passwordController,
                    onSaved: (newValue) => password = newValue,
                  ),
                  if (!_isLogingIn)
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'confirm password'),
                      validator: (value) => passwordController.text != value
                          ? 'the text in password and confirm password field are not alike'
                          : null,
                    ),
                  RaisedButton(
                    onPressed: _trySubmet,
                    child: Text(_isLogingIn ? LOGIN : SIGNUP),
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogingIn = !_isLogingIn;
                        });
                      },
                      child: Text(
                          _isLogingIn ? CREATE_AN_ACCOUNT : HAVE_AN_ACCOUNT)),
                ],
              )),
        ),
      ),
    );
  }
}
