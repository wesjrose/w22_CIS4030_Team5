import 'package:flutter/material.dart';
import 'package:gettechapp/pages/GoogleMapPage.dart';

class ProductInfoPage extends StatelessWidget {
  final String name;
  final String price;
  final String manufacturer;
  final String image;
  final String description;
  final List stores;

  ProductInfoPage({
    Key? key,
    required this.name,
    required this.price,
    required this.manufacturer,
    required this.image,
    required this.description,
    required this.stores,
  }) : super(key: key);

  static const TextStyle headerStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Info", textAlign: TextAlign.center),
        backgroundColor: Color.fromRGBO(31, 45, 53, 1),
      ),
      body: _buildProductCard(context),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Color.fromRGBO(48, 68, 78, 1),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: 325,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(31, 45, 53, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        image,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text(
                    "Available At:",
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
                for (int i = 0; i < stores.length; i++) _buildStoreCard(context, i),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Product Info:",
                        //textAlign: TextAlign.left,
                        style: headerStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCard(BuildContext context, int index) {
    return SizedBox(
      width: 250,
      child: GestureDetector(
        onTap: stores[index] == "Available Online" || stores[index] == "Out of Stock"
            ? () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Store location information not available"),
                    content: const Text("Product is either out of stock or only available online."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context, "OK"), child: const Text("OK"))],
                  ),
                )
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(
                            currentStore: stores[index],
                          )),
                );
              },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            //Made this a row in case we want to add distance later
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(stores[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
