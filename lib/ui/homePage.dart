import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences jark;
  String name='', text;
  
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      print(contents);
      this.text = contents;
      return contents;
    } catch (e) {
      return '';
    }
  }
  
  @override
  void initState() {
    super.initState();
    readLocal();
  }
  void readLocal() async {
    jark = await SharedPreferences.getInstance();
    name = jark.getString('name' ?? '');
    text = readCounter().toString();

    // Force refresh input
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Hello'+name,
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text('this is my quote "${text == null ? '' : text }" '),
                ),
                RaisedButton(
                  child: Text("PROFILE SETUP"),
                  onPressed: () {
                    Navigator.pushNamed(
                  context, '/profile'
                );
                  },
                ),
                RaisedButton(
                  child: Text("MY FRIENDS"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => FriendScreen(user: user),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("SIGN OUT"),
                  onPressed: () async{
                    final jark = await SharedPreferences.getInstance();
                    jark.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}