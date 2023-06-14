import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../components/navigationBarWidget.dart';
import '../components/notification_dialog.dart';

class MapScreen extends StatefulWidget {
  final String currentStore;

  MapScreen({Key? key, required this.currentStore}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markerList = [];
  //final CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(43.53263428547508, -80.22651267899897), zoom: 11.5);

  late GoogleMapController _googleMapController;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    getMarker();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController _cntrl) {
    _googleMapController = _cntrl;
  }

  List getMarker() {
    if (widget.currentStore == "Best Buy Guelph") {
      markerList.add(const Marker(
        markerId: MarkerId('_guelphStore'),
        infoWindow: InfoWindow(title: 'Guelph Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.52446825761938, -80.23212437306648),
      ));
    } else if (widget.currentStore == "Best Buy Brampton") {
      markerList.add(const Marker(
        markerId: MarkerId('_bramptonStore'),
        infoWindow: InfoWindow(title: 'Brampton Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.71629894910128, -79.7216926786961),
      ));
    } else if (widget.currentStore == "Best Buy Orangeville") {
      markerList.add(const Marker(
        markerId: MarkerId('_orangeStore'),
        infoWindow: InfoWindow(title: 'Orangeville Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.93011394851642, -80.09897945956244),
      ));
    } else if (widget.currentStore == "Best Buy Toronto") {
      markerList.add(const Marker(
        markerId: MarkerId('_toStore'),
        infoWindow: InfoWindow(title: 'Toronto Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.65562577543425, -79.382414115393),
      ));
    } else if (widget.currentStore == "Best Buy Oakville") {
      markerList.add(const Marker(
        markerId: MarkerId('_oakStore'),
        infoWindow: InfoWindow(title: 'Oakville Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.46179113261726, -79.68682618049358),
      ));
    } else if (widget.currentStore == "Best Buy Kitchener") {
      markerList.add(const Marker(
        markerId: MarkerId('_kitchenerStore'),
        infoWindow: InfoWindow(title: 'Kitchener Best Buy'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(43.42136327068873, -80.43722873020072),
      ));
    }
    return markerList;
  }

  CameraPosition getInitialCameraPos() {
    if (widget.currentStore == "Best Buy Guelph") {
      return const CameraPosition(target: LatLng(43.52446825761938, -80.23212437306648), zoom: 16);
    } else if (widget.currentStore == "Best Buy Brampton") {
      return const CameraPosition(target: LatLng(43.71629894910128, -79.7216926786961), zoom: 16);
    } else if (widget.currentStore == "Best Buy Orangeville") {
      return const CameraPosition(target: LatLng(43.93011394851642, -80.09897945956244), zoom: 16);
    } else if (widget.currentStore == "Best Buy Toronto") {
      return const CameraPosition(target: LatLng(43.65562577543425, -79.382414115393), zoom: 16);
    } else if (widget.currentStore == "Best Buy Oakville") {
      return const CameraPosition(target: LatLng(43.46179113261726, -79.68682618049358), zoom: 16);
    } else if (widget.currentStore == "Best Buy Kitchener") {
      return const CameraPosition(target: LatLng(43.42136327068873, -80.43722873020072), zoom: 16);
    }
    return const CameraPosition(target: LatLng(43.53263428547508, -80.22651267899897), zoom: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Center(child: new Text("Store Locator")),
        backgroundColor: Color.fromRGBO(31, 45, 53, 1),
      ),
      body: GoogleMap(
        initialCameraPosition: getInitialCameraPos(),
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set.from(markerList),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(CameraUpdate.newCameraPosition(getInitialCameraPos())),
        child: const Icon(Icons.center_focus_strong),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
