import 'package:flutter/material.dart';
import 'package:gettechapp/models/product.dart';
import 'package:gettechapp/pages/ProductInfoPage.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Product> items;

  //FilterDialog({required this.categories});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<Product> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = widget.items;
    /*widget.categories.forEach((key, value) { 
     categories_copy[key] = value;
   });*/
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(31, 45, 53, 1),
      title: Text(
        "New In Stock",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          return SizedBox(
            width: width - 10,
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView(
                    children: [for (var i = 0; i < items.length; i++) _buildNotification(i)],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        Consumer<ApplicationState>(
          builder: (context, appState, child) => TextButton(
            child: const Text('Dismiss All'),
            onPressed: () {
              items = [];
              appState.clearProductNotifications();
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget _buildNotification(int index) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Card(
        color: Color.fromRGBO(12, 18, 21, 1),
        child: ListTile(
          onTap: () {
            appState.removeProductNotifications(items[index].id);    
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductInfoPage(
                  name: items[index].name,
                  price: items[index].price,
                  manufacturer: items[index].manufacturer,
                  image: items[index].imageURL,
                  description: items[index].description,
                  stores: items[index].availableStores,
                ),
              ),
            );
          },
          title: Text(
            items[index].name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          leading: Container(
              width: 50,
              height: 50,
              child: FittedBox(
                child: Image.network(items[index].imageURL),
                fit: BoxFit.fitWidth,
              )),
          dense: false,
        )
      )
    );
  }
}
