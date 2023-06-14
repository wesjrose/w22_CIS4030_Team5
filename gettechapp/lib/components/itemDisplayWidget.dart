import 'package:flutter/material.dart';
import 'package:gettechapp/models/product_info.dart';
import 'package:gettechapp/pages/ProductInfoPage.dart';
import 'package:gettechapp/components/favoritesButton.dart';
import '../models/product.dart';

class ItemDisplayWidget extends StatelessWidget {
  final String name;
  final String price;
  final String manufacturer;
  final String image;
  final String description;
  final List stores;
  final int index;
  final bool isList;
  final Product currentProduct;

  ItemDisplayWidget(
      {required this.name,
      required this.price,
      required this.manufacturer,
      required this.image,
      required this.description,
      required this.stores,
      required this.index,
      required this.isList,
      required this.currentProduct,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductInfoPage(
                    name: name,
                    price: price,
                    manufacturer: manufacturer,
                    image: image,
                    description: description,
                    stores: stores,
                  ),
                ),
              );
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(48, 68, 78, 1),
                      border: Border.all(
                        color: Color.fromRGBO(48, 68, 78, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 400,
                  child: Column(
                    children: [
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  overflow: TextOverflow.ellipsis))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Hero(
                              tag: image,
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  child: FittedBox(
                                    child: Image.network(image),
                                    fit: BoxFit.contain,
                                  ))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int j = 0; j < stores.length; j++)
                                Card(
                                    color: Color.fromRGBO(31, 46, 53, 1),
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          stores[j],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        )))
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Text("Manufacturer: " + manufacturer,
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(color: Colors.white)),
                              FavoritesButton(index, isList, currentProduct),
                              Text("\$" + price,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white))
                            ],
                          ))
                    ],
                  ),
                ))))
      ],
    );
  }
}
