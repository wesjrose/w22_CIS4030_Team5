import 'package:flutter/material.dart';
import '../components/itemDisplayWidget.dart';
import '../models/product.dart';

class TypeList extends StatefulWidget {
  final Function(String) notifyParent;

  int numResponses;
  bool browsable = true;
  bool back = false;
  Color colour = Color.fromRGBO(12, 18, 21, 1);
  final String title;
  final String type; //Ideally change sthis to enum
  final List<Product> items; //Might change to diurect db query

  TypeList(
      {Key? key,
      required this.notifyParent,
      required this.items,
      required this.title,
      required this.type,
      required this.numResponses,
      this.browsable = true,
      this.colour = const Color.fromRGBO(12, 18, 21, 1),
      this.back = false})
      : super(key: key);

  //FilterDialog({required this.categories});

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    count = 0;
    if (widget.numResponses > widget.items.length || widget.numResponses < 0) {
      widget.numResponses = widget.items.length;
    }
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: widget.colour,
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              widget.browsable ? btn(widget.type) : SizedBox.shrink(),
              widget.back ? btn("") : SizedBox.shrink(),
              for (int i = 0;
                  i < widget.items.length && count < widget.numResponses;
                  i++)
                GetCardByType(i)
            ],
          ),
        ));
  }

  Widget btn(String val) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Color.fromRGBO(48, 68, 78, 1)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        widget.notifyParent(val);
      },
      child: val == "" ? Text('Back') : Text('Browse All'),
    );
  }

  Widget GetCardByType(int index) {
    if (widget.items[index].type == widget.type) {
      count++;
      return Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
          child: ItemDisplayWidget(
            name: widget.items[index].name,
            price: widget.items[index].price,
            manufacturer: widget.items[index].manufacturer,
            image: widget.items[index].imageURL,
            description: widget.items[index].description,
            stores: widget.items[index].availableStores,
            index: index,
            isList: false,
            currentProduct: Product(
              availableStores: widget.items[index].availableStores,
              name: widget.items[index].name,
              imageURL: widget.items[index].imageURL,
              manufacturer: widget.items[index].manufacturer,
              description: widget.items[index].description,
              price: widget.items[index].price,
              id: index,
              type: widget.items[index].type,
            ),
          ));
    } else {
      //Empty widigt
      return SizedBox.shrink();
    }
  }
}
