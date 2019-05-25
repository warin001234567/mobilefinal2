import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../model/db_model.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController uid = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController nam = TextEditingController();
  TextEditingController old = TextEditingController();
  TextEditingController quote = TextEditingController();
  ModelProvider temp = ModelProvider();
  SharedPreferences jark;


   @override
  void initState() {
    super.initState();
    temp.open('model.db').then((r) {
      print("open success");
    });
  }
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/quote.txt');
  }
  Future<File> writeCounter(String counter) async {
    final file = await _localFile;
    final temp = file.writeAsString('$counter');
    print(counter);
    return temp;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
      return double.parse(s, (e) => null) != null;
  }

  void updateProfile() async{
    _formKey.currentState.save();
    String iduser;
    if(_formKey.currentState.validate()){
      jark = await SharedPreferences.getInstance();
      iduser =await jark.getString('userid' ?? '');
      print(iduser);
      if(iduser == uid.text){
        Model test = Model(
            username: uid.text,
            password: pwd.text,
            name: nam.text,
            age: old.text,
          );
          writeCounter(quote.text);
      await temp.updateUser(test);
       Navigator.pushNamed(
                  context, '/home'
                );
        
      
      }
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('register'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
            autofocus: false,
            controller: uid,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'User Id',
            ),
            validator: (value) {
                  if (value.isEmpty) return "Userid is required";
                  if (value.length <= 6 || value.length >= 12)
                    return "Userid must be 6-12 character";
                },
          ),TextFormField(
            autofocus: false,
            controller: nam,
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline),
              hintText: 'Name'
            ),
            validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "Name is required";
                  for (int i = 0; i < value.length; i++) {
                    if (value[i] == " ") {
                      count = count+1;
                    }
                  }
                  if (count == 0 || count > 1) {
                    return "Please fill name correctly";
                  }
                },
          ),TextFormField(
            autofocus: false,
            controller: old,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Age'
            ),
            validator: (value) {
                  if (value.isEmpty) return "Age is required";
                  if (!isNumeric(value)) return "Age incorrect";
                  if (int.parse(value) < 10 || int.parse(value) > 80)
                    return "Age must be between 10 and 80";
                },
          ),TextFormField(
            autofocus: false,
            controller: pwd,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Password'
            ),
            validator: (value) {
                  if (value.isEmpty)
                    return "Password is required";
                  if(value.length <= 6)
                    return "Password must be more than 6";
                },
          ),
          TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'RE-Password'
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) return "Password is required";
                  if (value != pwd.text) return "Password does not match";
                },
              ),
              TextFormField(
                  controller: quote,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Quote"),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    color: Colors.grey,
                    child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                    onPressed: updateProfile,
            ),
          ),
          ],
        ),
      ),
    );
  }
}