import 'package:e_commerce_app/screens/widgets/custom-input.dart';
import 'package:e_commerce_app/screens/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Build an alert dialog to display some errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close Dialog"),
              )
            ],
          );
        });
  }

  //Create a new user Account
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    //Set the form to loading state
    setState(() {
      _registerformloading = true;
    });

    //Run the Create Account Method
    String _createAccountFeedback = await _createAccount();
    //If the string is not null, we get an error while creating an account
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      //Set the form to regular state [Not loading]
      setState(() {
        _registerformloading = false;
      });
    } else {
      //The user was logged in, head back to login page
      Navigator.pop(context);
    }
  }

  //Default form loading state
  bool _registerformloading = false;

  //Form input field values
  String _registerEmail = "";
  String _registerPassword = "";

  //Focus node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'Create A New Account',
                textAlign: TextAlign.center,
                style: Constants.boldheading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: 'Email...',
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Password...',
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: 'Create New Account',
                  onPressed: () {
                    // Open the dialog
                    _submitForm();
                  },
                  isloading: _registerformloading,
                  outlineBtn: false,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: CustomBtn(
                text: 'Back To Login',
                onPressed: () {
                  Navigator.pop(context);
                },
                outlineBtn: true,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
