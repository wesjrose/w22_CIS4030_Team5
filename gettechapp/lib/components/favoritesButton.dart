import 'package:flutter/material.dart';
import 'package:gettechapp/models/product_info.dart';
import 'package:gettechapp/pages/ProductInfoPage.dart';
import 'package:gettechapp/favorite_tracker.dart';
import '../models/product.dart';
import 'package:provider/provider.dart'; // new
import '../main.dart';

class FavoritesButton extends StatefulWidget {
  final int index;
  final isList;
  final Product currentProduct;
  FavoritesButton(this.index, this.isList, this.currentProduct);
  // const StatefulIconButtonClass({Key? key}) : super(key: key);
  @override
  State<FavoritesButton> createState() => _StatefulIconButtonClassState();
}

class _StatefulIconButtonClassState extends State<FavoritesButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey[500],
        child: Consumer<ApplicationState>(builder: (context, getState, child) {
          return IconButton(
            icon: getState.isFavoriteList[widget.index]
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            iconSize: 20,
            onPressed: () {
              getState.updateIsFavoriteList(widget.index);
            },
            color: Colors.red,
          );
        }));
  }
}
