import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gettechapp/models/product_info.dart';
import 'package:gettechapp/components/itemDisplayWidget.dart';
import 'package:gettechapp/components/FilterIconButton.dart';
import '../Service/message.dart';
import "../models/product.dart";
import "../main.dart";

import '../components/navigationBarWidget.dart';
import '../components/notification_dialog.dart';

//firebase imports
import '../firebase_options.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:provider/provider.dart'; // new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
// import 'firebase_options.dart'; // new

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

// List<bool> selected = List.generate(200, (index) => true);

class SearchPageState extends State<SearchPage> {
  var _title = 'Search';
  var _currentIndex = 1;
  int _counter = 0;
  bool addlatest = false;
  int latestNotification = 0;
  String? _token;
  

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token){
      print("Token");
      print(token);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          '/message',
          arguments: MessageArguments(message, true),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      addlatest = true;
      print(message.data);
      latestNotification =   int.parse(message.data["productId"]);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              //channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
      setState(() {});
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );
    });
  }


  void displayNotification(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer<ApplicationState>(
                builder: (context, appState, _) => 
                  ListView(
                  padding: const EdgeInsets.all(8),
                  children:[ NotificationDialog(
                    items: appState.myNotifications,
                  )],
                )
            );
        }).then((_) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(_title)),
        backgroundColor: Color.fromRGBO(31, 45, 53, 1),
        actions: [
          IconButton(
            onPressed: () => displayNotification(context),
            icon:
            Consumer<ApplicationState>(
              builder: (context, appState, child){
                if (addlatest) {
                  appState.addProductNotifications(latestNotification);
                  addlatest = false;
                }
                _counter = appState.myNotifications.length;
                //appState.removeProductNotifications(items[index].id);
                return Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    _counter > 0?Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffc32c37),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Center(
                            child: Text(
                              _counter.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ): Icon(null),
                  ],
                );
              }
            ),
          ),
        ],
      ),
      body: SearchPageBody(),
      bottomNavigationBar: NaveBarWidget(start: _currentIndex),
    );
  }
}

class SearchPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var height = constraints.maxHeight;
      var width = constraints.maxWidth;
      return Column(children: [
        Row(children: [
          // Padding(
          //     padding: EdgeInsets.only(top: 8, left: 8),
          //     child: SizedBox(
          //         width: width * 0.75,
          //         height: 52,
          //         child: Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: Color.fromRGBO(48, 68, 78, 1)),
          //             child: TextField(
          //               decoration: InputDecoration(
          //                 prefixIcon: Icon(
          //                   Icons.search,
          //                   color: Colors.white,
          //                 ),
          //                 suffixIcon: IconButton(
          //                   icon: Icon(Icons.clear),
          //                   onPressed: () {
          //                     /* Clear the search field */
          //                   },
          //                 ),
          //                 hintText: '  GPU',
          //                 hintStyle: TextStyle(color: Colors.white),
          //                 border: InputBorder.none,
          //               ),
          //             )))),
          SizedBox(height: 10),
          Container(
              width: width * 0.80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Consumer<ApplicationState>(
                    builder: (context, getState, child) {
                  return TextField(
                      onChanged: (value) {
                        getState.inputStringChange(value);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIconColor: Colors.white,
                        labelText: 'Search',
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                      ));
                }),
              )),
          Padding(
              padding: EdgeInsets.only(left: 30), child: FilterIconButton()),
        ]),
        Expanded(
            child: Consumer<ApplicationState>(
          builder: (context, appState, _) => SearchPageFirebase(
              products: appState.filteredProductsList,
              searchString: appState.searchInput),
        ))
      ]);
    });
  }
}

class ProductInfoFirebase {
  ProductInfoFirebase({
    required this.name,
    required this.description,
    required this.imageURL,
    required this.inStoreAvailability,
    required this.isFavorite,
    required this.manufacturer,
    required this.onlineAvailability,
    required this.price,
    required this.productType,
    required this.sku,
    required this.storeAvailability,
  });
  final String name;
  final String description;
  final String imageURL;
  final bool inStoreAvailability;
  final bool isFavorite;
  final String manufacturer;
  final bool onlineAvailability;
  final String price;
  final String productType;
  final String sku;
  final List<String> storeAvailability;
}

class SearchPageFirebase extends StatefulWidget {
  const SearchPageFirebase(
      {required this.products, required this.searchString});
  final List<Product> products;
  final String searchString;

  @override
  _SearchPageFirebaseState createState() => _SearchPageFirebaseState();
}

class _SearchPageFirebaseState extends State<SearchPageFirebase> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, getState, child) {
      return ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: [
          if ((widget.searchString).isEmpty)
            for (var product in widget.products)
              if (product.availableStores[0] == 'Available Online' &&
                  (getState.categoriesProvider[product.manufacturer] == true) &&
                  (getState.categoriesProvider[product.type] == true))
                ItemDisplayWidget(
                  name: product.name,
                  price: product.price,
                  manufacturer: product.manufacturer,
                  image: product.imageURL,
                  description: product.description,
                  stores: product.availableStores,
                  index: product.id,
                  isList: true,
                  currentProduct: product,
                ),
          if ((widget.searchString).isEmpty)
            for (var product in widget.products)
              if (product.availableStores[0] == 'Out of Stock' &&
                  (getState.categoriesProvider[product.manufacturer] == true) &&
                  (getState.categoriesProvider[product.type] == true))
                ItemDisplayWidget(
                  name: product.name,
                  price: product.price,
                  manufacturer: product.manufacturer,
                  image: product.imageURL,
                  description: product.description,
                  stores: product.availableStores,
                  index: product.id,
                  isList: true,
                  currentProduct: product,
                )
              else
                Container()
          else
            for (var product in widget.products)
              if (product.name
                      .toLowerCase()
                      .contains(getState.searchInput.toLowerCase()) &&
                  (getState.categoriesProvider[product.manufacturer] == true) &&
                  (getState.categoriesProvider[product.type] == true))
                ItemDisplayWidget(
                  name: product.name,
                  price: product.price,
                  manufacturer: product.manufacturer,
                  image: product.imageURL,
                  description: product.description,
                  stores: product.availableStores,
                  index: product.id,
                  isList: true,
                  currentProduct: product,
                )
        ],
      );
    });
  }
}
