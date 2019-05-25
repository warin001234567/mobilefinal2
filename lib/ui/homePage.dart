import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences jark;
  String name='';
  
  
  @override
  void initState() {
    super.initState();
    readLocal();
  }
  void readLocal() async {
    jark = await SharedPreferences.getInstance();
    name = jark.getString('name' ?? '');

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
                  subtitle: Text('this is my quote'),
                ),
                RaisedButton(
                  child: Text("PROFILE SETUP"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => ProfileScreen(user: user),
                      ),
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