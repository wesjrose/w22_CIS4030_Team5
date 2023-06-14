// Author: Pham (Sky) Truong
// Description: main dart file
// Last revised: March 6, 2021
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gettechapp/pages/sign_in_page.dart';
import 'package:gettechapp/pages/startup_page.dart';
import 'package:provider/provider.dart'; // new
import './models/product.dart';




import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

//firebase imports
import '../firebase_options.dart'; // new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'Service/message.dart';




  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Handling a background message ${message.messageId}');
  }
/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      //'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  
      
      String? token = await FirebaseMessaging.instance.getToken();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF1F2E35), primaryColor: Colors.white),
      home: StartUpPage(),
      routes: {
        '/message': (context) => MessageView(),
      },
    );
  }
}


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // FirebaseAuth.instance.userChanges().listen((user) {

    // });

    _productsSubscription = FirebaseFirestore.instance
        .collection("products")
        .orderBy("id", descending: false)
        // .limit(50)
        .snapshots()
        .listen((snapshot) {
      _products = [];
      for (final document in snapshot.docs) {
        List<String> listStores = [];
        for (var i = 0; i < document.data()["storeAvailability"].length; i++) {
          listStores.add((document.data()["storeAvailability"][i]).toString());
        }
        _products.add(
          Product(
            name: document.data()['name'] as String,
            price: (document.data()['price']).toString() as String,
            manufacturer: document.data()['manufacturer'] as String,
            imageURL: document.data()["imageURL"] as String,
            description: document.data()["description"] as String,
            availableStores: listStores,
            id: document.data()["id"],
            type: document.data()["productType"],
            // document.data()["storeAvailability"] as List<String>,
          ),
        );
      }
      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot>? _productsSubscription;
  List<Product> _products = [];
  List<Product> get productsList => _products;
  List<Product> get filteredProductsList => _products;

  List<Product> myListProducts = [];

  List<Product> get notificationList => _products;
  List<Product> myNotifications = [];

  List<bool> isFavoriteList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  //flips the value of is favorite in the boolean
  void updateIsFavoriteList(int index) {
    isFavoriteList[index] = !isFavoriteList[index];
    // print("This is the index sent:");
    // print(index);

    if (isFavoriteList[index] == true) {
      addProductMyList(index);
    } else {
      removeProductMyList(index);
    }

    notifyListeners();
  }

  //this function adds an item to the myList provider list

  void addProductNotifications(int id) {
    Future.delayed(const Duration(milliseconds: 100), () {
      myNotifications.add(_products.where((item) => item.id == id).first);
      notifyListeners();
    });
  }

  void removeProductNotifications(int id) {
    Future.delayed(const Duration(milliseconds: 100), () {
      myNotifications.removeWhere((item) => item.id == id);
      notifyListeners();
    });
  }

  void clearProductNotifications() {
    Future.delayed(const Duration(milliseconds: 100), () {
      myNotifications.clear();
      notifyListeners();
    });
  }


  //this function adds an item to the myList provider list

  void addProductMyList(int index) {
    myListProducts.add(_products[index]);
  }

  void removeProductMyList(int index) {
    // for (int i = 0; i < myListProducts.length; i++) {
    // if (myListProducts[i].id == index) {
    Future.delayed(const Duration(milliseconds: 300), () {
      myListProducts.removeWhere((item) => item.id == index);
      notifyListeners();
    });
  }

  String searchInput = "";

  void inputStringChange(String newString) {
    searchInput = newString;
    print(searchInput);
    notifyListeners();
  }

  Map<String, bool> categoriesProvider = {
    "GPU": true,
    'CPU': true,
    'MSI': true,
    'NVIDIA': true,
    'GIGABYTE': true,
    'PNY': true,
    'EVGA': true,
    'XFX': true,
    'ASUS': true,
    'Intel': true,
    'AMD': true,
  };

  void addCategoryToFilter(List<String> newFilterCategoryies, List<bool> trueOrFalse) {
    for (int i = 0; i < newFilterCategoryies.length; i++) {
      categoriesProvider[newFilterCategoryies[i]] = trueOrFalse[i];
    }

    notifyListeners();
  }
}
