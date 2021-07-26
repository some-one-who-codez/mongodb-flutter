import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/material.dart';
import 'package:mongo/database/database.dart';

void main() async {
  await Database.connect();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Database.read(), // documents
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // if loading
          return Scaffold(
            body: Center(
              child: Text('Loading data...'),
            ),
          );
        } else {
          // if loaded
          if (snapshot.hasError) {
            // if error
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Something went wrong, try again.',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            );
          } else {
            // if success
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'MongoDB',
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Database.create(_makeUser()); // create
                      setState(() {}); // rebuild
                    },
                    icon: Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data![index];

                  return ListTile(
                    title: Text(
                      // display data
                      '${data['name']} is ${data['age']} years old. I like these colors: ${data['favouriteColors'][0]}, ${data['favouriteColors'][1]}, ${data['favouriteColors'][2]}',
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Database.update(_updateUser(data['_id'])); // update
                        setState(() {}); // rebuild
                      },
                      icon: Icon(
                        Icons.update,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Database.delete(data['_id']); // delete
                        setState(() {}); // rebuild
                      },
                      icon: Icon(
                        Icons.delete,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }

  // make user with random values
  Map<String, dynamic> _makeUser() {
    List names = [
      'Harry',
      'Bob',
      'Dylan',
      'Michael',
      'Junior',
      'Martin',
      'Luther'
    ];
    List ages = [
      35,
      47,
      12,
      48,
      47,
      23,
      43,
    ];
    List colors = [
      'Red',
      'Orange',
      'Yellow',
      'Green',
      'Blue',
      'Indigo',
      'Violet',
      'White',
      'Black'
    ];

    Random nameRand = Random();
    Random ageRand = Random();
    Random colorRand = Random();

    // generate random value from list and populate map
    Map<String, dynamic> user = {
      'name': '${names[nameRand.nextInt(names.length)]}',
      'age': ages[ageRand.nextInt(ages.length)],
      'favouriteColors': [
        '${colors[colorRand.nextInt(colors.length)]}',
        '${colors[colorRand.nextInt(colors.length)]}',
        '${colors[colorRand.nextInt(colors.length)]}',
      ],
    };

    return user;
  }

  // update user with random values
  Map<String, dynamic> _updateUser(mongo.ObjectId _id) {
    List names = [
      'Harry',
      'Bob',
      'Dylan',
      'Michael',
      'Junior',
      'Martin',
      'Luther'
    ];
    List ages = [
      35,
      47,
      12,
      48,
      47,
      23,
      43,
    ];
    List colors = [
      'Red',
      'Orange',
      'Yellow',
      'Green',
      'Blue',
      'Indigo',
      'Violet',
      'White',
      'Black'
    ];

    Random nameRand = Random();
    Random ageRand = Random();
    Random colorRand = Random();

    Map<String, dynamic> user = {
      'name': '${names[nameRand.nextInt(names.length)]}',
      'age': ages[ageRand.nextInt(ages.length)],
      'favouriteColors': [
        '${colors[colorRand.nextInt(colors.length)]}',
        '${colors[colorRand.nextInt(colors.length)]}',
        '${colors[colorRand.nextInt(colors.length)]}',
      ],
      '_id': _id,
    };

    return user;
  }
}
