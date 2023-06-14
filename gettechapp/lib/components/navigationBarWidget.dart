import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gettechapp/pages/HomePage.dart';
import 'package:gettechapp/pages/MyListPage.dart';
import 'package:gettechapp/pages/SearchPage.dart';
import '../pages/UserAccountPage.dart';
import 'itemDisplayWidget.dart';
class NaveBarWidget extends StatefulWidget {
  final int start;
  const NaveBarWidget({Key? key, required this.start}) : super(key: key);

  @override
  State<NaveBarWidget> createState() => NavBar();
}

class NavBar extends State<NaveBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    
    setState((){
      _selectedIndex = index;
      if (index == 1){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context)=> SearchPage(),
          ),
        );
      }else if (index == 2){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context)=> MyListPage(),
          ),
        );
      }else if (index == 3){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context)=> UserAccountPage(),
          ),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context)=> HomePage(),
          ),
        );
      }
    });
  }

  @override
  BottomNavigationBar build (BuildContext context){
    _selectedIndex = widget.start;
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color.fromRGBO(255, 197, 66, 1),
        backgroundColor: Color.fromRGBO(48, 68, 78, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.format_list_bulleted_rounded,
            ),
            label: 'MyList',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      );
  }
}