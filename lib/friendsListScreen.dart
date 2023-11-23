import 'package:flutter/material.dart';
import 'package:google_map/friendsDB.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firendsAddingScreen.dart';
import 'Friend.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}
class _FriendsListScreenState extends State<FriendsListScreen> {


  Future<List<Friend>> _friends=Future.value([]);// = [
    // Friend(
    //     id: 1,
    //     name: 'Friend A',
    //     phone: '1234567890',
    //     address: 'adf',
    //     // logo: Icon(Icons.person)
    //     // selectedRestaurants: []),
    // )
   //];
  // Future<List<Friend>> getFriends() async {
  //   List<Friend> friends = []; // assume you have a list of friends
  //   // perform some async operation to get the friends list, e.g. from an API
  //   await Future.delayed(Duration(seconds: 1)); // simulate a delay of 1 second
  //   return friends; // return the list of friends inside a Future object
  // }
  void initState() {
    super.initState();
         setState(() {

             _friends = getFriendsFromDatabase();

         }
        );
  }

  List<Friend> _selectedFriends = [];
  void _sendSelectedRestaurants() {
    String message = '';
    for (Friend friend in _selectedFriends) {
      message += '${friend.name} selected the following restaurants:\n';
      // for (Restaurant restaurant in friend.selectedRestaurants) {
      //   message += '- ${restaurant.name}\n';
      // }
      message += '\n';
      String url = 'sms:${friend.phone}?body=$message';
      launch(url);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddFriendDialog();
                },
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
      body: FutureBuilder<List<Friend>>(
        future: _friends,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Friend> friends = snapshot.data!;
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // leading: _friends[index].logo != null ?
                  // CircleAvatar(backgroundImage: FileImage(_friends[index].logo!)):
                  //   Icon(Icons.person,size: 45,),
                  title: Text(friends[index].name),
                  subtitle:
                  Text('Phone Number: ${friends[index].phone}'),
                  trailing: Checkbox(
                    value: _selectedFriends.contains(friends[index]),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          _selectedFriends.add(friends[index]);
                        } else {
                          _selectedFriends.remove(friends[index]);
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: _selectedFriends.isNotEmpty
          ? FloatingActionButton(
        onPressed: _sendSelectedRestaurants,
        child: Icon(Icons.send),
      )
          : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
