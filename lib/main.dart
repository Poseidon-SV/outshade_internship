import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:outshade_internship/user_page.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String age_value;
  late String gender_value;
  late List data = [];
  late Box box1;
  late Box box2;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/data.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }

  void createBox() async {
    box1 = await Hive.openBox('database1');
    box2 = await Hive.openBox('database2');
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
    createBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  var name = data[index]['name'];
                  late String user_name;

                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Center(child: Text(name)),
                      ),
                      box1.get(name) == null
                          ? ElevatedButton(
                              child: Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.greenAccent),
                              onPressed: () {
                                user_name = data[index]['name'];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    backgroundColor: Colors.grey[200],
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 20),
                                        TextField(
                                          maxLength: 3,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Age',
                                            hintText: 'Age',
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 15),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          onChanged: (text) {
                                            age_value = text;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        TextField(
                                          maxLength: 6,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Gender',
                                            hintText: 'Gender',
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 15),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          onChanged: (text) {
                                            gender_value = text;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          child: Text('Sign In'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          onPressed: () {
                                            setState(() {});
                                            if (age_value == null ||
                                                gender_value == null) {
                                              print('Nothing');
                                            } else {
                                              box1.put(user_name, age_value);
                                              box2.put(user_name, gender_value);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserPage(
                                                          user_name,
                                                          age_value,
                                                          gender_value),
                                                ),
                                              );;
                                            }
                                          },
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : buildElevatedButton(
                              data[index]['name'], index, context),
                      Divider(),
                    ],
                  );
                })),
      ),
    );
  }

  Row buildElevatedButton(String user_name, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text('Sign Out'),
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          onPressed: () {
            user_name = data[index]['name'];
            setState(() {
              box1.delete(user_name);
              box2.delete(user_name);
            });
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
            onPressed: () {
              user_name = data[index]['name'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserPage(user_name, box1.get(user_name), box2.get(user_name)),
                ),
              );
            }),
        SizedBox(height: 10),
      ],
    );
  }
}
