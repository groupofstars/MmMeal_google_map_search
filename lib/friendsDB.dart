
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Friend.dart';

Future<Database> openDatabase1() async {
  final databasePath = await getDatabasesPath();
  String path = join(databasePath, 'friends.db');

  final Database database = await openDatabase(
    path,
    version: 3,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE friends (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, address TEXT)',
      );
    },
  );
  return database;
}

Future<void> addFriendToDatabase(Friend friend) async {
  final db = await openDatabase1();

  await db.insert(
    'friends',
    friend.toMapforInsert(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteFriendFromDatabase(int id) async {
  final db = await openDatabase1();

  await db.delete(
    'friends',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<List<Friend>> getFriendsFromDatabase() async {
  final db = await openDatabase1();

  final List<Map<String, dynamic>> maps = await db.query('friends');

  return List.generate(maps.length, (i) {

    return Friend.fromMap(maps[i]);
  });
}
