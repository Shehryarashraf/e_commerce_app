import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/widgets/custom-input.dart';
import 'package:e_commerce_app/screens/widgets/product_card.dart';
import 'package:e_commerce_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        if (_searchString.isEmpty)
          Center(
            child: Container(
                child: Text(
              "Search Results",
              style: Constants.regularDarkText,
            )),
          )
        else
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef
                  .orderBy("search_string")
                  .startAt([_searchString]).endAt(
                      ["$_searchString\ufaff"]).get(),
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
        Padding(
          padding: const EdgeInsets.only(top: 45),
          child: CustomInput(
            hintText: "Search here...",
            onSubmitted: (value) {
                setState(() {
                  _searchString = value.toLowerCase();
                });
              }
          ),
        ),
      ],
    ));
  }
}
