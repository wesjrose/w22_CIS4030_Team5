import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  final List stores;
  final int index;

  MapPage({
    Key? key,
    required this.stores,
    required this.index,
  }) : super(key: key);

  static const TextStyle headerStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Available Store Locations", textAlign: TextAlign.center),
        backgroundColor: Color.fromRGBO(31, 45, 53, 1),
      ),
      body: buildMap(),
    );
  }

  Widget buildMap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Stores: ",
              style: headerStyle,
            ),
          ),
          for (int i = 0; i < stores.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stores[i],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      "10km Away",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Map:",
              style: headerStyle,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/GuelphMap.png'),
          ),
        ],
      ),
    );
  }
}
