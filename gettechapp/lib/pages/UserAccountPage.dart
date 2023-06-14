import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gettechapp/pages/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Service/message.dart';
import '../components/navigationBarWidget.dart';
import '../components/notification_dialog.dart';
import '../main.dart';
import '../models/product_info.dart';
import '../models/user_data.dart';

class UserAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserAccountPageState();
}

List<bool> selected = List.generate(11, (index) => true);

class UserAccountPageState extends State<UserAccountPage> {
  var _title = 'Profile';
  var _currentIndex = 3;
  int _counter = 0;
  bool addlatest = false;
  int latestNotification = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
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
      latestNotification = int.parse(message.data["productId"]);
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
              builder: (context, appState, _) => ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      NotificationDialog(
                        items: appState.myNotifications,
                      )
                    ],
                  ));
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
                Consumer<ApplicationState>(builder: (context, appState, child) {
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
                  _counter > 0
                      ? Container(
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
                                border:
                                    Border.all(color: Colors.white, width: 1)),
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
                        )
                      : Icon(null),
                ],
              );
            }),
          ),
        ],
      ),
      body: UserAccountBody(),
      bottomNavigationBar: NaveBarWidget(start: _currentIndex),
    );
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final User? currentUser = _firebaseAuth.currentUser;

String getCurrentUID() {
  final uid = currentUser!.uid;
  return uid;
}

signOut() async {
  await FirebaseAuth.instance.signOut();
}

class UserAccountBody extends StatefulWidget {
  @override
  State<UserAccountBody> createState() => _UserAccountBodyState();
}

class _UserAccountBodyState extends State<UserAccountBody> {
  UserData userData = UserData("", "", "");

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _zipcodeController = TextEditingController();

  Future<String> _getDisplayName() async {
    String? displayName = currentUser!.displayName;
    userData.displayName = displayName!;

    print(userData.displayName);
    print("in _getDisplayName");
    return userData.displayName;
  }

  Future<String> _getEmail() async {
    String? email = currentUser!.email;
    userData.email = email!;

    print(userData.email);
    print("in _getEmail");
    return userData.email;
  }

  Future<String> _getZipcode() async {
    final uid = await getCurrentUID();
    db.collection('userData').doc(uid).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        userData.zipcode = snapshot.data()!['zipcode'];

        print(userData.zipcode);
        print("in _getZipcode");
      }
    });

    return userData.zipcode;
  }

  void _updateProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Update Profile"),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.cancel),
                        color: Colors.red[400],
                        iconSize: 25,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            controller: _zipcodeController,
                            decoration: InputDecoration(helperText: "Zip Code"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          final uid = getCurrentUID();
                          userData.zipcode = _zipcodeController.text;
                          setState(() {
                            _zipcodeController.text = userData.zipcode;
                          });
                          db
                              .collection('userData')
                              .doc(uid)
                              .set(userData.toJson());
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 197, 66, 1.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _zipcodeController = TextEditingController(text: "61350");
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double bigMultiplier = 6;
    double mediumMultiplier = 4;
    double smallMultiplier = 2.2;
    double tinyMultiplier = 1.8;

    return SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Profile display
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Display Name
                          FutureBuilder<String>(
                              future: _getDisplayName(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                Widget child;
                                if (snapshot.hasData) {
                                  _displayNameController.text =
                                      userData.displayName;
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text:
                                              "${_displayNameController.text}"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Display Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller:
                                          TextEditingController(text: "Error"),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Display Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else {
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "Loading..."),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Display Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                }

                                return Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Icon(
                                            Icons.person,
                                            color: Color.fromRGBO(
                                                184, 146, 62, 1.0),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: child,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),

                          // Username
                          // Flexible(
                          //   flex: 1,
                          //   fit: FlexFit.tight,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: Row(
                          //       children: [
                          //         Flexible(
                          //           flex: 1,
                          //           fit: FlexFit.tight,
                          //           child: Icon(
                          //             Icons.account_box_rounded,
                          //             color: Color.fromRGBO(184, 146, 62, 1.0),
                          //           ),
                          //         ),
                          //         Flexible(
                          //           flex: 3,
                          //           fit: FlexFit.tight,
                          //           child: Container(
                          //             child: TextField(
                          //               enabled: false,
                          //               controller: TextEditingController(
                          //                   text: "getTechUser"),
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize:
                          //                     smallMultiplier * unitHeightValue,
                          //               ),
                          //               decoration: InputDecoration(
                          //                 border: UnderlineInputBorder(),
                          //                 labelText: "Username",
                          //                 labelStyle: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: tinyMultiplier *
                          //                         unitHeightValue),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          // Email
                          FutureBuilder<String>(
                              future: _getEmail(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                Widget child;
                                if (snapshot.hasData) {
                                  _emailController.text = userData.email;
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "${_emailController.text}"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller:
                                          TextEditingController(text: "Error"),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else {
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "Loading..."),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                }

                                return Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Icon(
                                            Icons.email_rounded,
                                            color: Color.fromRGBO(
                                                184, 146, 62, 1.0),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: child,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),

                          // Zip Code
                          FutureBuilder<String>(
                              future: _getZipcode(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                Widget child;
                                if (snapshot.hasData) {
                                  // _zipcodeController.text = userData.zipcode;
                                  bool hasValue =
                                      (userData.zipcode != '') ? true : false;
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: hasValue
                                              ? userData.zipcode
                                              : _zipcodeController.text),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Zip Code",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller:
                                          TextEditingController(text: "Error"),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Zip Code",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                } else {
                                  child = Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "Loading..."),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            smallMultiplier * unitHeightValue,
                                      ),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Zip Code",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: tinyMultiplier *
                                                unitHeightValue),
                                      ),
                                    ),
                                  );
                                }

                                return Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Icon(
                                            Icons.location_on,
                                            color: Color.fromRGBO(
                                                184, 146, 62, 1.0),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: child,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),

                  // Buttons section
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        //Account settings
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 60.0, left: 60.0, bottom: 8.0, top: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor:
                                        Color.fromRGBO(255, 197, 66, 1.0),
                                  ),
                                  onPressed: () {
                                    _updateProfileBottomSheet(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Account Settings",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Contact us
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 8.0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: TextButton(
                        //           style: TextButton.styleFrom(
                        //             primary: Colors.white,
                        //             backgroundColor: Color.fromRGBO(255, 197, 66, 1.0),
                        //           ),
                        //           onPressed: () {},
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text("Contact Us"),
                        //               // Icon(Icons.arrow_forward_rounded),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // FAQs
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 8.0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: TextButton(
                        //           style: TextButton.styleFrom(
                        //             primary: Colors.white,
                        //             backgroundColor: Color.fromRGBO(255, 197, 66, 1.0),
                        //           ),
                        //           onPressed: () {},
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text("FAQs"),
                        //               // Icon(Icons.arrow_forward_rounded),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Sign out
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 60.0, left: 60.0, bottom: 8.0, top: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor:
                                        Color.fromRGBO(255, 197, 66, 1.0),
                                  ),
                                  onPressed: () async {
                                    await signOut();
                                    if (FirebaseAuth.instance.currentUser ==
                                        null) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => SignInPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sign out",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
