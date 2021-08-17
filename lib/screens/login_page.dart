import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/register_page.dart';
import 'package:e_commerce_app/screens/widgets/custom-input.dart';
import 'package:e_commerce_app/screens/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginformloading = true;
    });

    //Run the Create Account Method
    String _loginFeedback = await _loginAccount();
    //If the string is not null, we get an error while creating an account
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      //Set the form to regular state [Not loading]
      setState(() {
        _loginformloading = false;
      });
    }
  }

  //Default form loading state
  bool _loginformloading = false;

  //Form input field values
  String _loginEmail = "";
  String _loginPassword = "";

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
                'Welcome User,\nLogin to your Account',
                textAlign: TextAlign.center,
                style: Constants.boldheading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: 'Email...',
                  onChanged: (value) {
                    _loginEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: 'Password...',
                  onChanged: (value) {
                    _loginPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: 'Login',
                  onPressed: () {
                    // Open the dialog
                    _submitForm();
                  },
                  isloading: _loginformloading,
                  outlineBtn: false,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: CustomBtn(
                text: 'Create New Account',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
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
