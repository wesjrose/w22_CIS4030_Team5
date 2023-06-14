
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gettechapp/models/product.dart';

import '../models/product_info.dart';
import '../pages/ProductInfoPage.dart';

/// Message route arguments.
class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  // ignore: public_member_api_docs
  MessageArguments(this.message, this.openedApplication);
}
class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() {
    return new _MessageViewState();
  }
}

class _MessageViewState extends State<MessageView> {
  /// A single data row.
  Widget row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: '),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MessageArguments args =
        ModalRoute.of(context)!.settings.arguments! as MessageArguments;
    RemoteMessage message = args.message;
    return GetProduct( message.data["productId"].toString());

  }

  
}

class GetProduct extends StatelessWidget {
  final String documentId;

  GetProduct(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference products = FirebaseFirestore.instance.collection('products');

    return FutureBuilder<DocumentSnapshot>(
      future: products.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          List<String> listStores = [];
          for (var i = 0; i < data["storeAvailability"].length; i++) {
            listStores.add((data["storeAvailability"][i]).toString());
          }
          var p = Product(
            name: data['name'] as String,
            price: (data['price']).toString() as String,
            manufacturer: data['manufacturer'] as String,
            imageURL: data["imageURL"] as String,
            description: data["description"] as String,
            availableStores: listStores,
            id: data["id"],
            type: data["productType"],
            // document.data()["storeAvailability"] as List<String>,
          );
          return ProductInfoPage(
            name: p.name,
            price:p.price,
            manufacturer: p.manufacturer,
            image: p.imageURL,
            description:p.description,
            stores: p.availableStores,
          );
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}