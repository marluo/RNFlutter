import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import "../../api/user.dart";
import "../../api/incidents.dart";
import "../../db/database.dart";
import '../widgets/MainScreenAppbar.dart';
import '../../helpers/helpers.dart';
import 'package:Jeves_RN_App/main.dart';

class MainScreen extends StatefulWidget {
  MainScreen({@required this.db, @required this.getDB, Key key, this.title})
      : super(key: key);
  final String title;
  final DBHelper db;
  final dynamic getDB;

  @override
  MainScreenState createState() => MainScreenState(db: db, getDB: getDB);
}



class MainScreenState extends State<MainScreen> {
  MainScreenState({this.db, this.getDB});
  final DBHelper db;
  final dynamic getDB;

  String appTitle;
  int team;
bool refreshed;
bool refreshDone;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    appTitle = 'First Line';
    team = 2;
    refreshed = false;
    refreshDone = false;
    
  }

  @override
 void dispose(){
  // Additional disposal code
  super.dispose();
 }

  void refreshState() {
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {});
  }


  
Future<Null> refreshList() async {
    refreshed = true;

    setState(() {

    });
    Future.delayed(const Duration(milliseconds: 1000));

}


Future<int> getId(fullName, login, password) async {


int myId =await getMyId(fullName, login, password);

return myId;

}



  void setTitleTeam(int team, String appTitle) {
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      this.appTitle = appTitle;
      this.team = team;
    });
  }

  String getStatus(st) {

    if (st == '102') {
      return 'In Progress';
    }
    if (st == '110') {
      return 'Internally updated';
    }
    if (st == '1') {
      return 'New';
    }

    if (st == '104') {
      return 'Open';
    } if (st == '8') {
      return 'Updated';
    }

    else {
      return 'Ingen status';
    }

  }


  String getSeverity(sev) {
    if (sev == '4') {
      return '4 - Low';
    }
    if (sev == '3') {
      return '3 - Medium';
    }
    if (sev == '2') {
      return '2 - High';
    }

    if (sev == '1') {
      return '1 - Critical';
    } else {
      return 'Severity ej satt';
    }
  }

  Widget build(BuildContext context) {
  getMyIncidents(getDB, db, team) async {
  Database queryDB = await getDB(db);
  List<Map> list = await queryDB.rawQuery('SELECT * FROM User');
  if (list.length > 0) {
    String login = list[0]['USERNAME'];
    String password = list[0]['password'];
    String fullName = login.split('.').join(' ');
    int id = await getId(fullName, login, password);
    if(id == 9999999) {
        await queryDB.rawQuery('DELETE FROM User');
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(getDB: getDB, db: db,)),
  );


    }
    dynamic incidents = await queryMyIncidents(id, login, password, team, 'id');
    if(incidents.length > 0 && incidents[0] == 'error') {
      /*await queryDB.rawQuery('DELETE FROM User');
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(getDB: getDB, db: db,)),
  );*/

    return [];

    }
    if(incidents.length > 0 && incidents[0] == 'auth') {
      await queryDB.rawQuery('DELETE FROM User');
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(getDB: getDB, db: db,)),
  );
    }
    return incidents;
  }
}
    return Scaffold(
      appBar: mainAppBar(appTitle, setTitleTeam, refreshState),
      body:Container(
            child: FutureBuilder<dynamic>(
          future: getMyIncidents(getDB, db, team), // async work
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
                if(refreshed == false) {
                return Center(child: CircularProgressIndicator());
                }
                refreshed = false;

            }
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (snapshot.data.length == 0) return Container(padding: EdgeInsets.all(10),child:Center(child:Text('Finns inget i $appTitle-kön eller så suger marcus på att programmera', textAlign: TextAlign.center,),),);
                else
                return ListView(
                  children: [
                    for (var i in snapshot.data)
                      Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          //255,24, 68, 83
                          child: buildListTile(context, i),
                        ),
                      )

                    /*Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 16.0,
                                  left: 24.0,
                                  right: 24.0,
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.wysiwyg),
                                  title: Text(i[0]),
                                  subtitle: Text(i[30] + '\n\n' + i[2]),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/third',
                                        arguments: [i[0], getDB, db]);
                                  },
                                ),
                              ),
                            ],
                          ),
                     )*/
                  ],
                );
            }
          ,
        ))/*,floatingActionButton: FloatingActionButton(
        onPressed: null /*() {
          Navigator.pushNamed(context, '/fifth', arguments: [getDB,db]);
          
        }*/,
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey)*/
    );
  }

   ListTile buildListTile(BuildContext context, i) {
    return ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/third',
                                  arguments: {
                                    'incidentId': i['incidentId'],
                                    'status': i['status'],
                                    'subject': i['subject'],
                                    'getDB':getDB,
                                    'db': db,
                                    'orglookupName': i['orglookupName'],
                                    'orgId': i['orgId'],
                                    'namelookupName': i['namelookupName'] != null
                                        ? i['namelookupName']
                                        : 'Ej Assignat',
                                        'incidentlookupName': i['incidentlookupName']
                                  });
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              i['subject'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i['incidentlookupName'], textAlign: TextAlign.left),
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: Colors.blue),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(getSeverity(i['severity']),
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                      Row(
                                        children: [
                                          Icon(Icons.update,
                                              color: Colors.blue),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(convertDate(i['incidentUpdateTime']),
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: Row(children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.account_box_outlined,
                                              color: Colors.blue),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                                i['namelookupName'] != null
                                                    ? i['namelookupName']
                                                    : 'Ej Assignat',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                      Row(
                                        children: [
                                          Icon(Icons.linear_scale,
                                              color: Colors.blue),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text(getStatus(i['status']),
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        ],
                                      ),
                                    ])),
                                Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: Row(children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.business_outlined,
                                              color: Colors.blue),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                                i['orglookupName'] != null
                                                    ? i['orglookupName'].length > 29 ? i['orglookupName'].substring(0,26) + '...' : i['orglookupName']
                                                    : 'Ej Assignat',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                    ])),
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.blue, size: 30.0));
  }
}