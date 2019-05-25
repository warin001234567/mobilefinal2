import 'package:flutter/material.dart';
import '../model/db_model.dart';
import './loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
    return double.parse(s, (e) => null) != null;
  }

  TextEditingController uid = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController nam = TextEditingController();
  TextEditingController old = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Model> user = List();
  ModelProvider temp = ModelProvider();
  bool controluid;

  @override
  void initState() {
    super.initState();
    temp.open('model.db').then((r) {
      print("open success");
    });
  }

  controlRegis()async{
    await temp.regisControl(uid.text).then((r){
        setState(() {
        controluid = r;
        });
      });
  }
  
  void checkRegis()async{
    _formKey.currentState.save();
    if(uid.text != '' || pwd.text != '' ){
      await controlRegis();
      if(controluid){
        Model test = Model(
          username: uid.text,
          password: pwd.text,
          name: nam.text,
          age: old.text
        );
        temp.instert(test).then((r){
          print("regist pass!!!");
          Navigator.pushNamed(
                  context, '/'
                );
        });
      }else{
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('userid duplicate, please fill new userid')));
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
                  if (value.length < 6 || value.length > 12)
                    return "Userid must be 6-12 character";
                },
          ),TextFormField(
            autofocus: false,
            controller: nam,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Name'
            ),
            validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "Name is required";
                  for (int i = 0; i < value.length; i++) {
                    if (value[i] == " ") {
                      count = 1;
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
              icon: Icon(Icons.person),
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
              icon: Icon(Icons.person),
              hintText: 'Password'
            ),
            validator: (value) {
                  if (value.isEmpty && value.length < 6)
                    return "Password is required";
                },
          ),
          TextFormField(
                decoration: InputDecoration(
                  labelText: "Re-Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) return "Password is required";
                  if (value != pwd.text) return "Password does not match";
                },
              ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.grey,
              child: Text('Register', style: TextStyle(color: Colors.white)),
              onPressed: checkRegis,
            ),
          ),
          ],
        ),
      ),
    );
  }
}