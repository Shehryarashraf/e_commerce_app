import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/product_page.dart';
import 'package:e_commerce_app/screens/widgets/custom_action_bar.dart';
import 'package:e_commerce_app/screens/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              //Products data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                //display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(top: 120, bottom: 12),
                  children: snapshot.data.docs.map((document) {
                    return ProductCard(
                      title: document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: "\$${document.data()['price']}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              //Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
        CustomActionBar(
          title: "Home",
          hasBackArrow: false,
        )
      ]),
    );
  }
}
