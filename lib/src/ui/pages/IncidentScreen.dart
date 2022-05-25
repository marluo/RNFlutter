import 'package:Jeves_RN_App/main.dart';
import 'package:Jeves_RN_App/src/ui/pages/SearchOrgScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import '../../api/incidents.dart';
import '../widgets/IncidentDropDown.dart';
import '../../helpers/helpers.dart';
import 'package:path_provider/path_provider.dart';



class IncidentScreen extends StatefulWidget {
  final String id;
  IncidentScreen({Key key, this.id}) : super(key: key);

  @override
  _IncidentScreenState createState() => _IncidentScreenState(id: id);
}

class _IncidentScreenState extends State<IncidentScreen> {
  final String id;
  _IncidentScreenState({this.id});

  String testkek = 'lol';
  bool loading;
  bool downloading;
  String saved;

  @override
  void initState() {
    super.initState();
    testkek = 'Hejsan';
    loading = false;
    downloading = false;
    saved = 'Incident Saved, redirecting';
  }

  Widget build(BuildContext context) {
    print('new!');
    Map<dynamic, dynamic> savedIncident = {};

    List dropDownCategories = [
      'queue',
      'type',
      'severity',
      'products',
      'appversion',
      'kernelversion',
      'serviceCategories',
      'status',
      'assignedTo'
    ];

    final Map arguments = ModalRoute.of(context).settings.arguments;

    getOneIncident(id, getDB, db) async {
      Database queryDBx = await getDB(db);
      List<Map> userlist = await queryDBx.rawQuery('SELECT * FROM User');
      if (userlist.length > 0) {
        String login = userlist[0]['USERNAME'];
        String password = userlist[0]['password'];
        List<dynamic> stuff = await queryOneIncident(id, login, password, db, queryDBx);
        return stuff;
      } else {
        await queryDBx.rawQuery('DELETE FROM User');
        return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(getDB: getDB, db: db,)),
  );
      }
    }
    Future download2(Dio dio, String url, String savePath, String imgtype) async {
    try {
      Response response = await dio.get(
        url,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              print(status);
              return status < 250;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      OpenFile.open(savePath);
      await raf.close();
      if(imgtype != 'imgInIncident') {
      setState(() {
        downloading = false;
      });
      }
    } catch (e) {
      print(e);
    }
  }



      getUser(getDB, db) async{
      Database queryDBx = await getDB(db);
      List<Map> userlist = await queryDBx.rawQuery('SELECT * FROM User');
      if (userlist.length > 0) {
        String login = userlist[0]['USERNAME'];
        String password = userlist[0]['password'];
      return [login, password];
    };
    }

    updateIncident<bool>(id, data, getDB, db) async {
      Database queryDBx = await getDB(db);
      List<Map> userlist = await queryDBx.rawQuery('SELECT * FROM User');
      if (userlist.length > 0) {
        String login = userlist[0]['USERNAME'];
        String password = userlist[0]['password'];
        /*print(id);
        print(data);
        print(getDB);
        print(db);*/

        setState(() {
          loading = true;
        });
        var xx =
            await updateIncidentCategories(id, savedIncident, login, password);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    };

    return Scaffold(
        appBar: AppBar(
          title: Text(arguments['incidentlookupName']),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchOrgScreen()),
              );
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: Icon(
                  Icons.saved_search,
                )),
            TextButton(
                onPressed: () {
                  updateIncident(arguments['incidentId'], savedIncident,
                      arguments['getDB'], arguments['db']);
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: Icon(
                  Icons.save,
                ))
          ],
        ),
        body: FutureBuilder<dynamic>(
            future: getOneIncident(arguments['incidentId'], arguments['getDB'],
                arguments['db']), // async work
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  if (loading == true) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.length == 0)
                    return Center(
                        child: Text(
                            'Finns inget i kön eller så suger marcus på att programmera'));
                  else
                  return ListView(
                    children: [
                      Card(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        elevation: 8.0,
                        child: Column(
                          children: [
                            LiteTileCompSecond(
                                title: Text(arguments['subject']),
                                subtitle: Text('Ämne'),
                                icon: Icon(
                                  Icons.label_important,
                                  color: Colors.blue[500],
                                )),
                            Divider(),
                            LiteTileCompSecond(
                                title: Text(arguments['orglookupName']),
                                subtitle: Text('Organisation'),icon: Icon(
                                  Icons.business_outlined,
                                  color: Colors.blue[500],
                                )),
                            LiteTileCompSecond(
                                title: Text('Skapad av'),
                                subtitle: Text(snapshot.data[0]
                                    [snapshot.data[0].length - 1]['createdBy']),
                                icon: Icon(
                                  Icons.contact_mail,
                                  color: Colors.blue[500],
                                )),
                            LiteTileCompSecond(
                                title: Text('Assignad till'),
                                subtitle: Text(arguments['namelookupName']),
                                icon: Icon(
                                  Icons.contact_page_outlined,
                                  color: Colors.blue[500],
                                )),
                            LiteTileCompSecond(
                              title: Text(snapshot.data[2]['app'] == null
                                  ? 'Inget i assets'
                                  : snapshot.data[2]['app']),
                              subtitle: Text(snapshot.data[2]['kernel'] == null
                                  ? 'Inget i assets'
                                  : snapshot.data[2]['kernel']),
                              icon: Icon(
                                Icons.settings,
                                color: Colors.blue[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                          margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                          elevation: 8.0,
                          child: ExpansionTile( 
                            title: Center(
                                child:
                                    Text("Kategorier")),
                            children: [
                              for (String category in dropDownCategories)
                                Column(children: [
                                  Text(category),
                                  IncidentDropDown(
                                    category: category,
                                    picked: snapshot.data[1][category],
                                    savedIncident: savedIncident,
                                  ),
                                ],),
                                Container(padding: const EdgeInsets.all(8.0),child: Column(children:[
                                  Text('Namn (om ej från JIS): ${arguments['orglookupName']}'),
                                  TextField(onChanged: (text) async {
                                    savedIncident['customFields'] = {
                          "c": {
                            "cust_name": text
                          }
                        };
                        print(savedIncident);
                                  },decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: snapshot.data[1]['cust_id'] != null ? snapshot.data[1]['cust_name'] : 'Ej ifyllt!',
  ),),
   Text('Orgid (om ej från JIS): ${arguments['orgId']}'),
                                  TextField(onChanged: (text) async { savedIncident['customFields'] = {
                          "c": {
                            "assoc_org_id": int.parse(text)
                          }
                        };
                        print(savedIncident);},decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: snapshot.data[1]['cust_id'] != null ? snapshot.data[1]['cust_id'] : 'Ej ifyllt!',))                              ]),),
                            ],
                          )),
                          FileAttachmentCard(arguments: arguments, snapshot: snapshot, download2: download2, getUser: getUser),
                      Column(
                        children: [
                          for (var i in snapshot.data[0])
                            Card(
                              margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                              elevation: 8.0,
                              color: i['messageType'] == '1'
                                  ? Colors.yellow[100]
                                  : Colors.white,
                              child: ListTile(
                                leading: Icon(
                                  Icons.contact_mail,
                                  color: Colors.blue[500],
                                ),
                                title: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                                  child: Text(
                                      '${i['answerContact']} - ${convertDate(i['created'])}'),
                                ),
                                subtitle: ColumnImageInIncident(i: i, arguments: arguments, download: download2, getUser: getUser),
    
                              ),
                            ),
                        ],
                      )
                    ],
                  );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/fourth', arguments: [
              arguments['incidentId'],
              arguments['getDB'],
              arguments['db'],
              arguments[3],
              arguments[4],
              arguments
            ]);
          },
          child: const Icon(Icons.message),
          backgroundColor: Colors.blueAccent,
        ));
  }
}

class ColumnImageInIncident extends StatefulWidget {
  const ColumnImageInIncident({
    Key key,
    @required this.i,
    @required this.arguments,
    @required this.download,
    @required this.getUser,
  }) : super(key: key);

  final i;
  final Map arguments;
  final Function download;
  final Function getUser;

  @override
  _ColumnImageInIncidentState createState() => _ColumnImageInIncidentState();
}

class _ColumnImageInIncidentState extends State<ColumnImageInIncident> {
  bool picClicked;
  @override
  void initState() {
    super.initState();
      picClicked = false;
  }

  @override
 void dispose(){
  // Additional disposal code
  super.dispose();
 }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for(var widgetIncidentText in widget.i['text'])
        widgetIncidentText['widgetType'] is Image ? GestureDetector(
        onTap: picClicked == false ? ()  async {
        setState(() {
          picClicked = true;
        });
        List user = await widget.getUser(widget.arguments['getDB'], widget.arguments['db']);
        var tempDir = await getTemporaryDirectory();
        String fullPath = tempDir.path + '/' + 'img.jpg';
        var dio = Dio();
        String fullUrl ='https://' + user[0] + ':' + user[1] + '@' + widgetIncidentText['url'].replaceAll('https://', '') + '?download';
        await widget.download(dio, fullUrl, fullPath, 'imgInIncident');
        setState(() {
          picClicked = false;
        });
        } : null,child:widgetIncidentText['widgetType']) : widgetIncidentText['widgetType']
      ],
    );
  }
}

class FileAttachmentCard extends StatefulWidget {
  const FileAttachmentCard({
    Key key,
    @required this.arguments,
    @required this.snapshot,
    @required this.getUser,
    @required this.download2
  }) : super(key: key);

  final Map arguments;
  final AsyncSnapshot snapshot;
  final Function getUser;
  final Function download2;

  @override
  _FileAttachmentCardState createState() => _FileAttachmentCardState();
}

class _FileAttachmentCardState extends State<FileAttachmentCard> {
  bool downloadingFile;
  @override
  void initState() {
    super.initState();
      downloadingFile = false;
  }
  

  Widget build(BuildContext context) {
    return Card(
    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
    elevation: 8.0,
    child: ExpansionTile(
      title: Center(
          child:
              Text("Bifogade Filer")),
      children: widget.snapshot.data[1]['fileAttachmentList'].length > 0 ?[
        for (Map fileList in widget.snapshot.data[1]['fileAttachmentList'])
          Column(children: [
            TextButton(child: Text(fileList['fileName']), onPressed: downloadingFile == false ? () async {
              setState(() {
              downloadingFile = true;
              });
              List user = await widget.getUser(widget.arguments['getDB'], widget.arguments['db']);
              var tempDir = await getTemporaryDirectory();
              String fullPath = tempDir.path + '/' + fileList['fileName'];
              var dio = Dio();
              String fullUrl ='https://' + user[0] + ':' + user[1] + '@' + fileList['link'].replaceAll('https://', '') + '?download';
              await widget.download2(dio, fullUrl, fullPath, 'attachment');
              setState(() {
              downloadingFile = false;
              });
            }: null ,)
          ])
      ] : [Column(children:[Padding(padding: EdgeInsets.all(16.0),child:Text('Inga Bifogade än!'))])] 
    ));
  }
}

class LiteTileCompSecond extends StatelessWidget {
  final data;
  final icon;
  final title;
  final subtitle;
  const LiteTileCompSecond(
      {Key key, this.data, this.icon, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: title,
      subtitle: subtitle,
      leading: icon,
    );
  }
}

class ListTileComponent extends StatefulWidget {
  final String snapshotdata;
  final Function getOrgInfo;
  final getDB;
  final db;
  final String id;
  final String type;
  const ListTileComponent(
      {Key key,
      this.snapshotdata,
      this.getOrgInfo,
      this.getDB,
      this.db,
      this.id,
      this.type})
      : super(key: key);

  @override
  _ListTileComponentState createState() => _ListTileComponentState();
}

class _ListTileComponentState extends State<ListTileComponent> {
  String dataToWrite;

  _ListTileComponentState();
  @override
  void initState() {
    super.initState();
    /*dataToWrite = '..';
    if (widget.id != null) {
      widget.getOrgInfo(widget.id, widget.getDB, widget.db).then((name) {
        setState(() {
          dataToWrite = name;
        });
      });
    } else {
      dataToWrite = widget.snapshotdata;
    }*/
  }

  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.snapshotdata),
        subtitle:
            widget.type == 'inci' ? Text('Incident Info') : Text('Org Info'),
        leading: widget.type == 'inci'
            ? Icon(Icons.label_important, color: Colors.blue[500])
            : Icon(Icons.business, color: Colors.blue[500]));
  }
}
