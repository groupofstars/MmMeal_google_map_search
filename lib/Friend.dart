
class Friend {
  int id;
  String name;
  String phone;
  String address;
  // File? logo;
  // List<Restaurant> selectedRestaurants;
  Friend(
      { required this.id,
        required this.name,
        required this.phone,
        required this.address,
        // required this.selectedRestaurants,
        // this.logo,
       });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      // 'logo':logo,
      // 'selectedRestaurants':selectedRestaurants
    };
  }
  Map<String, dynamic> toMapforInsert() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      // 'logo':logo,
      // 'selectedRestaurants':selectedRestaurants
    };
  }
  static Friend fromMap(Map<String, dynamic> map) {
    return Friend(
        id: map['id'],
        name: map['name'],
        // logo:map['logo'],
        phone: map['phone'],
        address: map['address'],
        // selectedRestaurants: map['selectedRestaurants']
    );
  }
}

