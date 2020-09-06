import 'dart:io';
import 'dart:math';

import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:password_strength/password_strength.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget>
    with SingleTickerProviderStateMixin {
  MainAxisAlignment currentAlignment = MainAxisAlignment.center;

  bool _isLogingIn = true;

  File _profileImage;

  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  String email, password, username;

  AnimationController profilePictureAnimationController;
  Animation profilePictionAnimation;

  void signUp() async {
    await Firebase.initializeApp();
    try {
      if (_profileImage == null) {
        showDialogx('you did not select an image');
        return;
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final ref = FirebaseStorage.instance
          .ref()
          .child(USER_IMAGES_STORAGE)
          .child(FirebaseAuth.instance.currentUser.uid + '.jpg');
      await ref.putFile(_profileImage).onComplete;
      final x = await ref.getDownloadURL();
      print(x);
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({UserName: username, USER_IMAGE: x});
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
  void initState() {
    super.initState();
    profilePictureAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    profilePictionAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: profilePictureAnimationController,
            curve: Curves.easeInOut));

    profilePictureAnimationController.addListener(() {
      setState(() {});
    });
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        if (visible && !_isLogingIn) {
          currentAlignment = MainAxisAlignment.start;
        } else {
          currentAlignment = MainAxisAlignment.center;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: currentAlignment,
      children: [
        Logo(20 * pi / 180, 1 - profilePictionAnimation.value),
        Card(
          margin: const EdgeInsets.all(20),
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              //height: _isLogingIn ? 214 : (260.0 + 232.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final image = await ImagePicker()
                                .getImage(source: ImageSource.camera);
                            setState(() {
                              _profileImage = File(image.path);
                            });
                          },
                          child: CircleAvatar(
                            radius: profilePictionAnimation.value * 50,
                            child: _profileImage == null
                                ? Text(
                                    'tap to add a profile picture',
                                    textAlign: TextAlign.center,
                                  )
                                : null,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage)
                                : null,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-Mail'),
                          validator: (value) => EmailValidator.validate(value)
                              ? null
                              : 'enter a valid email',
                          onSaved: (newValue) => email = newValue,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                          constraints: BoxConstraints(
                              minHeight: !_isLogingIn ? 59 : 0,
                              maxHeight: !_isLogingIn ? 119 : 0),
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Your username'),
                            onSaved: (newValue) => username = newValue,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'password'),
                          validator: (value) =>
                              estimatePasswordStrength(value) < 0.3
                                  ? 'this password is week !'
                                  : null,
                          controller: passwordController,
                          onSaved: (newValue) => password = newValue,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                          constraints: BoxConstraints(
                              minHeight: !_isLogingIn ? 59 : 0,
                              maxHeight: !_isLogingIn ? 119 : 0),
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'confirm password'),
                            validator: (value) => passwordController.text !=
                                    value
                                ? 'the text in password and confirm password field are not alike'
                                : null,
                          ),
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
                              if (profilePictureAnimationController
                                  .isCompleted) {
                                profilePictureAnimationController.reverse();
                              } else {
                                profilePictureAnimationController.forward();
                              }
                            },
                            child: Text(_isLogingIn
                                ? CREATE_AN_ACCOUNT
                                : HAVE_AN_ACCOUNT)),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  final double rotationRatio, finalAngle;
  Logo(this.finalAngle, this.rotationRatio);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
      transform: Matrix4.rotationZ(-1 * finalAngle * rotationRatio)
        ..translate(-5.0),
      // ..translate(-10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepOrange.shade200,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(
        'AN Shop',
        style: TextStyle(
          color: Theme.of(context).accentTextTheme.headline6.color,
          fontSize: 30,
          fontFamily: 'Anton',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
