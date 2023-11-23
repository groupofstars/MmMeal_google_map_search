import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as my_location;

import 'package:google_maps_webservice/places.dart';

import 'friendsListScreen.dart';
import 'restaurantDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      24.88453,
      67.07886,
    ),
    zoom: 15,
  );

  // final List<Marker> _marker = [];
  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  Set<Marker> _marker_my = {};
  final List<Marker> _list = const [

  ];


  bool _isSearching = false;
  LatLng _center = LatLng(40.7128, -74.0060);
  @override
  void initState() {

    super.initState();
    _getNearbyRestaurants();         //mark my location

  }
  Future<void> _getCurrentLocation() async {
    my_location.Location location = my_location.Location();
    my_location.LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
      _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      // _center = LatLng(40.7128, -74.0060);
    } catch (e) {
      currentLocation = null!;
      _center = LatLng(40.7128, -74.0060);
    }
    setState(() {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_center.latitude, _center.latitude),
          14.0,
        ),
      );
      // _markers.add(
      //   Marker(
      //     markerId: MarkerId('user_location'),
      //     position: LatLng(
      //       _center.latitude!,
      //       _center.longitude!,
      //     ),
      //   ),
      // );

      _marker_my.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: LatLng(
            _center.latitude,
            _center.longitude,
          ),

        ),
      );
    });



  }
  late GoogleMapController mapController;



  FocusNode _searchFocusNode = FocusNode();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyBGrqyjYmK4fhqZ1bayf93hCxcSfezSWDk');


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _getNearbyRestaurants();
  }

  Future<void> _getNearbyRestaurants({String? query}) async {


    PlacesSearchResponse response;
    if (query != null) { // If query parameter is not null, search for restaurants with the query
      response = await _places.searchNearbyWithRadius(
        Location(lat:_center.latitude,lng: _center.longitude),
        111500,
        type: 'restaurant',
        keyword: query,
      );
    } else { //
      // my_location.Location location = my_location.Location();
      // my_location.LocationData currentLocation;
      // currentLocation = await location.getLocation();

      response = await _places.searchNearbyWithRadius(
        Location(lat:_center.latitude,lng: _center.longitude),
        100500,
        type: 'restaurant',
        // keyword: 'restaurant',
      );
    }
    setState(() {
      // _markers.clear();
      response.results.forEach((result) {

        _markers.add(
          Marker(
            markerId: MarkerId(result.placeId),
            position: LatLng(
              result.geometry!.location.lat,
              result.geometry!.location.lng,
            ),
            infoWindow: InfoWindow(
              title: result.name,
              snippet: result.vicinity,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

            onTap: () {
              _showRestaurantInfo(result);
            },
          ),
        );
      });
    });
  }
  void _showRestaurantInfo(PlacesSearchResult result) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetailsScreen(restaurant: result),
      ),
    );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(result.name),
    //       content: SingleChildScrollView(
    //         child: ListBody(
    //           children: <Widget>[
    //             Text('Address: ${result.vicinity}'),
    //             Text('Rating: ${result.rating}'),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('OK'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
  void _updateMapState() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('new_marker'),
          position: LatLng(37.42796133580664, -122.085749655962),
          infoWindow: InfoWindow(
            title: 'My location',
            snippet: 'This is my location',
          ),
        ),
      );

      // _center.latitude=35;
      // _center.longitude=-121;
      _getNearbyRestaurants();
    });
  }
  void _moveToNewYork() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(40.7128, -74.0060),
        14.0,
      ),
    );
  }
  void _searchRestaurant() {
    String searchQuery = _searchController.text;

    _getNearbyRestaurants(query:searchQuery);
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        _center,
        104.0,
      ),
    );

  }


  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _searchFocusNode.requestFocus();
  }
  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  PlaceDetails _placesDetails(String placeId) {
    PlacesDetailsResponse response = _places.getDetailsByPlaceId(placeId) as PlacesDetailsResponse;
    return response.result;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ?
        TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ) :
        Text('Select the restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _isSearching ? _stopSearch:_startSearch,
          ),
        ],
      ),
      body: GoogleMap(

        onTap: (position) {
          setState(() {
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId('pointed Location'),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            );
            _marker_my.clear();
            _marker_my.add(
              Marker(
                markerId: MarkerId('currentLocation'),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            );
            _center = LatLng(position.latitude, position.longitude);
            _getNearbyRestaurants();
          });

          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              _center,
              14.0,
            ),
          );
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsListScreen(),
                ),
              );
            },
            child: Icon(Icons.person_add_alt),
            backgroundColor: Colors.greenAccent,
          ),
          SizedBox(width: 16),
          FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.man),
          ),
          SizedBox(width: 16),
          // FloatingActionButton(
          //   onPressed: _moveToNewYork,
          //   child: Icon(Icons.location_city),
          // ),
          // SizedBox(width: 16),
          if (_isSearching)
          FloatingActionButton(
            onPressed: _searchRestaurant,
            child: Icon(Icons.search),
          ),
          SizedBox(width: 16),
          // FloatingActionButton(         //restaurants list
          //   onPressed: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context)=>RestaurantListScreen()),
          //     );
          //   },
          //   child: Icon(Icons.add),
          // ),
        ],
      ),
    );
  }
}
