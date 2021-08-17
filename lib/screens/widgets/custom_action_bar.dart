import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/cart_page.dart';
import 'package:e_commerce_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasbackground;
  CustomActionBar(
      {this.title, this.hasBackArrow, this.hasTitle, this.hasbackground});

  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasbackground = hasbackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasbackground
              ? LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0)],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1))
              : null),
      padding: EdgeInsets.only(top: 72, right: 24, left: 24, bottom: 42),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (_hasBackArrow)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: Image(
                image: AssetImage("assets/images/back_arrow@2x.png"),
                width: 16,
                height: 16,
                color: Colors.white,
              ),
            ),
          ),
        if (_hasTitle)
          Text(title ?? "Action Bar", style: Constants.boldheading),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CartPage(),
              ));
          },         
          child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: StreamBuilder(
                stream: _usersRef
                    .doc(_firebaseServices.getuserId())
                    .collection("Cart")
                    .snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;
        
                  if (snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
        
                  return Text("$_totalItems" ?? "0",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white));
                },
              )),
        )
      ]),
    );
  }
}
