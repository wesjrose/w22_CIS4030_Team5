import 'package:flutter/material.dart';
import '../models/product.dart';
import '../main.dart';
import 'package:provider/provider.dart'; // new

List<bool> categoryList = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
];

List<String> filterCategories = [
  "GPU",
  'CPU',
  'MSI',
  'NVIDIA',
  'GIGABYTE',
  'PNY',
  'EVGA',
  'XFX',
  'ASUS',
  'Intel',
  'AMD',
];

class FilterIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.filter_alt_rounded),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                      title: Text("Adjust Filters"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: Builder(builder: (context) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width * 1;
                        if (width > height) {
                          width = 400;
                        }
                        // selected = new List.from(categoryList);

                        // List categoryList_temp = categoryList;

                        // selected = new List.from(categoryList);
                        return Container(
                            width: width,
                            child: Wrap(
                              children: [
                                for (int i = 0;
                                    i < filterCategories.length;
                                    i++)
                                  Card(
                                    color: categoryList[i]
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            categoryList[i] = !categoryList[i];

                                            // categoryList[i] =
                                            //     !categoryList[i];
                                          });
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3,
                                                left: 3,
                                                top: 5,
                                                bottom: 5),
                                            child: Stack(
                                                overflow: Overflow.visible,
                                                children: [
                                                  Text(filterCategories[i]),
                                                  Positioned(
                                                      right: -5,
                                                      top: -9,
                                                      child: AnimatedOpacity(
                                                          duration:
                                                              const Duration(
                                                                  seconds: 0),
                                                          opacity:
                                                              categoryList[i]
                                                                  ? 1.0
                                                                  : 0.0,
                                                          child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.black,
                                                              size: 10)))
                                                ]))),
                                  )
                              ],
                            ));
                      }),
                      actions: <Widget>[
                        Consumer<ApplicationState>(
                            builder: (context, getState, child) {
                          return TextButton(
                            onPressed: () {
                              getState.addCategoryToFilter(
                                  filterCategories, categoryList);
                              Navigator.pop(context, true);
                            },
                            child: const Text('Apply',
                                style: TextStyle(
                                    color: Color.fromRGBO(48, 68, 78, 1))),
                          );
                        }),
                      ],
                    )));
      },
    );
  }
}
