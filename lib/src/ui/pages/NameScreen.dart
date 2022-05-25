import 'package:flutter/material.dart';
import '../widgets/ClassListIncident.dart';
import '../../api/orgs.dart';

class NameScreen extends StatefulWidget {
  final dynamic db;
  final dynamic asd;
  Map org;
  NameScreen({Key key, this.org, this.db, this.asd}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override

  Widget build(BuildContext context) {


getUsersFromOrg(getDB, db, org) async {
var queryDB = await widget.asd(widget.db);
 List<Map> list = await queryDB.rawQuery('SELECT * FROM User');
  if (list.length > 0) {
    String login = list[0]['USERNAME'];
    String password = list[0]['password'];
    String fullName = login.split('.').join(' ');
    List users = await usersFromOrgs(login, password, org);
    if(users == null) {
      print('lol');
    }
    return users;
  }

}



    
     return Scaffold(appBar:AppBar(
          title: Text('Välj användare från '+ widget.org['orgname']),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: Icon(
                  Icons.save,
                ))
          ],
        ),body: FutureBuilder(
          future: getUsersFromOrg(widget.asd, widget.db, widget.org['id']),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (snapshot.data.length == 0)
                    return Center(
                        child: Text(
                            'Finns inget i kön eller så suger marcus på att programmera'));
                  else
                  return ListView(
                  children: [
                    for (var i in snapshot.data)
                  ClassListIncident(arguments: [widget.asd, widget.db, i], orgOrName: 'user')]);
          }},
        ));
  }
}
        
      