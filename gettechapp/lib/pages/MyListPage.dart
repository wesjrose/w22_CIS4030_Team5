import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gettechapp/models/product_info.dart';
import 'package:gettechapp/components/itemDisplayWidget.dart';
import '../Service/message.dart';
import '../main.dart';
import 'package:provider/provider.dart'; // new
import '../components/navigationBarWidget.dart';
import '../components/notification_dialog.dart';
import '../models/product.dart';

class MyListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyListPageUpdatePageState();
}

List<bool> selected = List.generate(11, (index) => true);

class MyListPageUpdatePageState extends State<MyListPage> {
  var _title = 'My List';
  var _currentIndex = 2;
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
      body: MyListPageBody(),
      bottomNavigationBar: NaveBarWidget(start: _currentIndex),
    );
  }
}

class MyListPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Center(
        //       child: Container(
        //           width: 300,
        //           color: Color.fromRGBO(48, 68, 78, 1),
        //           child: Text("My List",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 20)))),
        // ),
        child: Consumer<ApplicationState>(
            builder: (context, appState, _) => ListPageFirebase()));
  }
}

class ListPageFirebase extends StatefulWidget {
  @override
  _ListPageFirebaseState createState() => _ListPageFirebaseState();
}

class _ListPageFirebaseState extends State<ListPageFirebase> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, getState, child) {
      return ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: [
          for (var product in getState.myListProducts)
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
