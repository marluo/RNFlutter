import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../api/incidents.dart';
import '../widgets//MessageBox.dart';

//ignore: must_be_immutable
class MessageScreen extends StatefulWidget {
  final String id;
  MessageScreen({Key key, this.id}) : super(key: key);
  String dropDownValue;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String dropdownValue;
  bool sending;
  final messageController = TextEditingController();
  bool _isButtonEnabled;

  _printLatestValuelol() {
    print(messageController.text);
  }



  int convertMessageTypeToInt(typeOfMessage) {
    int typeInt = typeOfMessage == 'Normal Message' ? 2 : 1;
    return typeInt;
  }

  
  void initState() {
    super.initState();
    dropdownValue = 'Normal Message';
    sending = false;
    messageController.addListener(_printLatestValuelol);
    _isButtonEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;


    void _buildMessageAndSendToIncident(incidentId, message, dropdownValue) async {
      Map typeofMessage;
      Map messageToIncident;
      String endpoint;

      Database queryDBx = await arguments[1](arguments[2]);
      List<Map> userlist = await queryDBx.rawQuery('SELECT * FROM User');
      if (userlist.length > 0) {
        String login = userlist[0]['USERNAME'];
        String password = userlist[0]['password'];


    if(dropdownValue == 'Normal Message') {
      endpoint = 'incidentResponse/';

      messageToIncident = {
        "incident": {
          "id": incidentId,
          "threads": [
            {
              "text": message,
              "entryType": {"id": 2},
            }
          ],
        },
    
      };
    } else if (dropdownValue== 'Private Note') {
      print('what');
      endpoint = 'incidents/${incidentId}/';

      messageToIncident = {
        "threads": [
          {
            "text": message,
            "entryType": {"id": 1},
          }
        ]
    };

    }

    bool responseSuccess = await addResponseToIncident(incidentId, messageToIncident, login, password, endpoint);

    if(responseSuccess == true) {

      setState(() {
        sending = true;
      });
      Navigator.pushReplacementNamed(context, '/third', arguments: arguments[5]);

    } else {

    }

      }
  }

    return Scaffold(
      appBar: AppBar(title: Text('Skicka ett svar..')),
      body: sending == false ?Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Container(
                height: 100,
                child: Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Normal Message', 'Private Note']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ))),
            Expanded(
                flex: 3,
                child: MessageBox(messageController: messageController, placeholder: 'Skriv ett svar...')),
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _isButtonEnabled ? () {
          setState(() {
            _isButtonEnabled = false;
          });
          _buildMessageAndSendToIncident(
              int.parse(arguments[0]), messageController.text, dropdownValue);
           _isButtonEnabled = true;
        } : null,
        child: Icon(Icons.send),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
