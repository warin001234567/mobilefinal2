import 'package:flutter/material.dart';
import './registerPage.dart';
import '../model/db_model.dart';
import './homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController uid = TextEditingController();
  TextEditingController pwd = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Model> user = List();
  ModelProvider temp = ModelProvider();
  SharedPreferences jark;
  

  @override
  void initState() {
    super.initState();
    temp.open('model.db').then((r) {
      print("open success");
    });
  }
  
  void getuser()async{
    await temp.authenUser(uid.text, pwd.text).then((r) {
      setState(() {
        user = r;
      });
    });
  }

  void checkLogin()async{
    _formKey.currentState.save();
    if(_formKey.currentState.validate()){
      if (uid.text != '' && pwd.text != '')
      {
        await getuser();
        if(user.isEmpty){
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('username or password worng!!!')));
        }else{
          jark = await SharedPreferences.getInstance();
          await jark.setString('name', user[0].name);
          await jark.setString('userid', user[0].username);
          if(jark.getString('name' ?? '').isNotEmpty && jark.getString('userid' ?? '').isNotEmpty){
            print('eiei');
            Navigator.pushReplacementNamed(
            context, '/home'
          );
          }
        }
      }
      else{
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please fill out this form')));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
        padding: EdgeInsets.only(top: 20, left: 25,right: 25),
        children: <Widget>[
          Image.asset(
            'image/logo.png',
            height: 200,
            width: 200,
          ),
          TextFormField(
            autofocus: false,
            controller: uid,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'User Id'
            ),
          ),
          TextFormField(
            autofocus: false,
            controller: pwd,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Password'
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.grey,
              child: Text('LOGIN', style: TextStyle(color: Colors.white)),
              onPressed: checkLogin,
            ),
          ),
          FlatButton(
            child: SizedBox
              (
                  width: double.infinity,
                  child: Text('Register new account',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.right)
              ),
              onPressed: () 
              {
                Navigator.pushNamed(
                  context, '/register'
                );
              },
          ),
          FlatButton(
            child: SizedBox
              (
                  width: double.infinity,
                  child: Text('clean DB',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.right)
              ),
              onPressed: () 
              {
                temp.deleteUsers().then((r){
                  print("dai laew ja");
                });
              },
          )
        ],
      ),),
    );
  }
}