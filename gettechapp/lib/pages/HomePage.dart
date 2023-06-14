import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gettechapp/components/notification_dialog.dart';
import 'package:gettechapp/models/product.dart';
import 'package:provider/provider.dart';
import '../Service/message.dart';
import '../components/navigationBarWidget.dart';
import '../components/typeListWidget.dart';
import '../main.dart';
import '../models/product_info.dart';
import 'ProductInfoPage.dart';
import 'SearchPage.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

List<bool> selected = List.generate(11, (index) => true);

class HomePageState extends State<HomePage> {
  var _title = 'Home';
  var _currentIndex = 0;
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
      body: HomeBody(),
      bottomNavigationBar: NaveBarWidget(start: _currentIndex),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  //FilterDialog({required this.categories});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var SelectedType = "";
  var featured = Product(
    name: "MSI - GeForce GTX 1660 Ti Gaming X 6GB GDDR6 PCI Express 3.0 Graphics Card", 
    price: "399.99", 
    manufacturer: "MSI", 
    imageURL: "https://pisces.bbystatic.com/prescaled/500/500/image2/BestBuy_US/images/products/6330/6330461_sd.jpg", 
    description: "Run demanding games at high frame rates and in incredible detail with this MSI GeForce GTX 1660 Ti graphics card. Games, streaming and other graphical programs run fluidly thanks to the 1,536 CUDA cores, and three DisplayPort outputs make multi-monitor setup simple. This MSI GeForce GTX 1660 Ti graphics card has 6GB of memory for handling intense workloads.", 
    availableStores: ["Out of Stock"], 
    id: 0, 
    type: "GPU");
  int maxResults = 20;
  int minResults = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => 
          ListView(
          padding: const EdgeInsets.all(8),
          children: [SearchBtn(context), ...GetDisplay(context, appState)],
        )
      );
  }

  Widget SearchBtn(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20, right: 240, left: 20),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
          child: Text('Search'),
        ));
  }

  List<Widget> GetDisplay(BuildContext context, ApplicationState appState) {
    if (SelectedType == "") {
      return [
        TypeList(notifyParent: refresh, items: [featured], numResponses: 1, title: "Featured Product", type: featured.type, colour: Color.fromRGBO(255, 197, 66, 1), browsable: false),
        TypeList(notifyParent: refresh, items:  appState.productsList, numResponses: minResults, title: GetTypeName("GPU"), type: "GPU"),
        TypeList(notifyParent: refresh, items:  appState.productsList, numResponses: minResults, title: GetTypeName("CPU"), type: "CPU")
      ];
    } else {
      return [TypeList(notifyParent: refresh, items: appState.productsList, numResponses: maxResults, title: GetTypeName(SelectedType), type: SelectedType, browsable: false, back: true)];
    }
  }

  refresh(String val) {
    setState(() {
      SelectedType = val;
    });
  }

  String GetTypeName(String type) {
    if (type == "GPU") {
      return "Graphics Cards";
    } else {
      return "CPU's";
    }
  }
}
