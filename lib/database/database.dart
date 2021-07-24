import 'package:mongo_dart/mongo_dart.dart';
import '/keys/keys.dart' as keys;

class Database {
  static late Db db;
  static late DbCollection userCollection;

  // connect to the database
  static connect() async {
    db = await Db.create(
      'mongodb+srv://${keys.user}:${keys.password}@${keys.host}/${keys.databaseName}?${keys.parameters}',
    );
    await db.open(secure: true);
    userCollection = db.collection('Users'); // get collection
  }

  // read all the documents in the database
  static Future<List<Map<String, dynamic>>> read() async {
    try {
      final users = await userCollection.find().toList(); // get all docs
      return users;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static create(Map<String, dynamic> user) async {
    await userCollection.insert(user); // create
  }

  static update(Map<String, dynamic> user) async {
    await userCollection.replaceOne(where.id(user['_id']), user); // update
  }

  static delete(ObjectId id) async {
    await db.collection('Users').remove(where.id(id)); // delete
  }
}
