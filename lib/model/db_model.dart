import 'package:sqflite/sqflite.dart';

final String tableDB = "user";
final String columnId = "id";
final String columnUsername = "username";
final String columnPassword = "password";
final String columnName = "name";
final String columnAge = "age";

class Model{
  int id;
  String username, password, name, quote, age;
  Model({this.username, this.password, this.name, this.age});
  Model.formMap(Map<String, dynamic> map){
    this.id = map[columnId];
    this.username = map[columnUsername];
    this.password = map[columnPassword];
    this.name = map[columnName];
    this.age = map[columnAge];
  }
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
    columnUsername: username,
    columnPassword: password,
    columnName: name,
    columnAge: age
  };
  if (id != null){
    map[columnId] = id;
  }
  return map;

  }
}


class ModelProvider {
  Database db;


  Future open(String path) async{
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async{
        await db.execute('''
          create table $tableDB(
            $columnId integer primary key autoincrement,
            $columnUsername text not null,
            $columnPassword text not null,
            $columnName text,
            $columnAge text)
        ''');
      });
  }
  Future instert(Model temp) async{
    print(temp.username);
    print(temp.password);
    await db.insert(tableDB, temp.toMap());
    print("goooo");
    return Model;
  }

  Future<List<Model>> getUsers() async {
    var res = await db.query(tableDB);
    return res.isNotEmpty ? res.map((c) => Model.formMap(c)).toList() : [];
  }

  Future<List<Model>> getUser(int id) async {
    var res = await db.query(tableDB,
        where: '$columnId = ?',
        whereArgs: [id]);
    return res.isNotEmpty ? res.map((c) => Model.formMap(c)).toList() : [];
  }

  Future<List<Model>> authenUser(String uid, String pwd) async{
    print(uid);
    print(pwd);
    var res = await db.rawQuery("SELECT * FROM user WHERE username = ? AND password = ?", [uid, pwd]);
    return
    res.isNotEmpty ? res.map((c) => Model.formMap(c)).toList() : [];
  }

  Future<bool> regisControl(String uid) async{
    print(uid);
    var res = await db.rawQuery("SELECT * FROM user WHERE username = ?", [uid]);
    return res.isEmpty;
  }


  Future<int> updateUser(Model user) async {
    return await db.update(tableDB, user.toMap(),
        where: '$columnUsername = ?',
         whereArgs: [user.username]);
  }

  Future<int> deleteUsers() async {
    print("clean DB done");
    return await db.delete(tableDB);
    
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(tableDB, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}
