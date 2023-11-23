import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'friendsListScreen.dart';
class RestaurantDetailsScreen extends StatelessWidget {
  final PlacesSearchResult restaurant;
  RestaurantDetailsScreen({required this.restaurant});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              itemCount: restaurant.photos.length,
              itemBuilder: (context, index) {
                return Image.network(
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${restaurant.photos[index].photoReference}&key=AIzaSyBGrqyjYmK4fhqZ1bayf93hCxcSfezSWDk',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 8),
                      Text(
                        '${restaurant.rating}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    restaurant.vicinity!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child:Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child:IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendsListScreen(),
                                  ),
                                );
                              },

                              icon: Column(
                                children: [

                                  Icon(Icons.discount_rounded),

                                ],
                              ),
                              iconSize: 50.0,
                              color: Colors.green,
                              splashColor: Colors.white,
                              highlightColor: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              tooltip: '8% discount',
                            ),
                          ),

                        ],
                      )

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}