import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../api/incidents.dart';




class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }


initDb() async {
  //joins path + "users.db"
  String path = join(await getDatabasesPath(), "users.db");
  var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
  return theDb;
}


void _onCreate(Database db, int version) async  {
  await db.execute(
      "CREATE TABLE User(USERNAME TEXT PRIMARY KEY, password TEXT)",
    );
  await db.execute(
      "CREATE TABLE Contacts(ID INT PRIMARY KEY, contact TEXT, created TEXT)",
    );

    await db.execute('CREATE INDEX index1 ON Contacts(ID);');
}

void insertUser(Database db, String username, String password) async {
    var row = {
        'username': username,
        'password': password
    };
    await db.insert('User', row);
    print('created user');
}
Future<String> checkContacts(db, username, password, queryDB, id) async {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String currentTimeString = dateFormat.format(DateTime.now());
  DateTime currentTimeDT = dateFormat.parse(currentTimeString);
  List user = [];

    List<Map> list = await queryDB.rawQuery('SELECT ID, created FROM Contacts LIMIT 1');
    print(list);
    if(list.length > 0) {
      DateTime insertedTime = dateFormat.parse(list[0]['created']);
      DateTime insertedTimePlusFourteen = insertedTime.add(Duration(days:14));


      if(currentTimeDT.isAfter(insertedTimePlusFourteen)) {
        print('deleting');
        await queryDB.rawQuery('DELETE FROM Contacts');
        print('made it here');
        await insertUsersToContacts(queryDB, username, password, currentTimeString);
        list = await queryDB.rawQuery('SELECT ID, contact FROM Contacts where ID=$id');
        print('length >1');
        if(list.length > 0) {
          user = list.toList();
        return user[0]['contact'];
        }
        return null;
      } else {
        print('doing this');
        list = await queryDB.rawQuery('SELECT ID, contact FROM Contacts where ID=$id');
        print(list);
        if(list.length > 0) {
        user = list.toList();
        return user[0]['contact'];
        }
        return null;
      }

    } else if(list.length == 0) {
      print('made it here!!!!');
      await insertUsersToContacts(queryDB, username, password, currentTimeString);
      list = await queryDB.rawQuery('SELECT ID, contact FROM Contacts where ID=$id');
      print('length 0');
      if(list.length > 0) {
        user = list.toList();
        return user[0]['contact'];
        }
        return null;
      

    }
    return null;
    
}
Future<List<Map>> insertUsersToContacts(db, username, password, currentTimeString) async{
  //sqlite limited so only 0 to 9999...
  List contacts = await queryContacts(username, password, 0, 9999);
  print('are we here yet');
  Batch batch = db.batch();
      contacts.forEach((var contact) {
        batch.insert('Contacts',{
        'ID': contact[0],
        'contact': contact[1],
        'created': currentTimeString
        });
      });

  await batch.commit();
  List contactsTwo = await queryContacts(username, password, 10000, 19999);
  Batch batchTwo = db.batch();
      contactsTwo.forEach((var contact) {
        batchTwo.insert('Contacts',{
        'ID': contact[0],
        'contact': contact[1],
        'created': currentTimeString
        });
      });

  await batchTwo.commit();
  print('inserted everything');
      
      
       //await batch.insert('Contacts', contactsRow.toMap());

}


Future<List> getAllContactsFromDB(db, username, password, currentTimeString) async{
  List contacts = await queryContacts(username, password, 0, 9999999);
  List contactsRow;
      contacts.forEach((var contact) {
        contactsRow.add({
        'ID': contact[0],
        'contact': contact[1],
        'created': currentTimeString
        });
       print('row completed');
      });
      
       await db.insert('Contacts', contactsRow);
       print('inserted to conctacts');
}



}

Future<Map> getUserAndPassword(getDB, db) async {
Database queryDB = await getDB(db);
  List<Map> list = await queryDB.rawQuery('SELECT * FROM User');
  if (list.length > 0) {
    String login = list[0]['USERNAME'];
    String password = list[0]['password'];

    return {'login':login, 'password':password, 'fullName': login.replaceAll('.', ' ')};
  } else {
    return {'login': 'error', 'password': 'error'};
  }

}

/*
class User {
  final String password;
  final String username;

  User({this.username, this.password});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }





  
}


final Future<Database> database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
  join(await getDatabasesPath(), 'user.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      "CREATE TABLE User(USERNAME TEXT PRIMARY KEY, password TEXT)",
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);

Future<void> insertUser(User user) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'user',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print('inserted user');
}



Future<List<User>> users() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('user');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return User(
      username: maps[i]['username'],
      password: maps[i]['password'],
    );
  });
}


}



// Open the database and store the reference.*/