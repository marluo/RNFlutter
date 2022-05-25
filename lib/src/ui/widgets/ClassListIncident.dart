import 'package:flutter/material.dart';
import '../pages/NewIncidentScreen.dart';
import '../pages/NameScreen.dart';

class ClassListIncident extends StatelessWidget {
  const ClassListIncident({
    Key key,
    @required this.arguments,
    @required this.company,
    @required this.orgOrName,
  }) : super(key: key);

  final List arguments;
  final Map company;
  final String orgOrName;

  @override
  Widget build(BuildContext context) {
    
    return Container(child:Card(child:ListTile(
                        onTap: () {
                          /*Navigator.push(context,
                                  MaterialPageRoute(
      builder: (context) => arguments.length > 2 ? NewIncidentScreen() :NameScreen(org: company, asd:arguments[0], db:arguments[1]),
    ));
                        */},
                        title: Text(arguments.length > 2 ? arguments[2][1] : company['orgname']),
                        subtitle: Text(arguments.length > 2 ? arguments[2][1] : company['orgid']),
                        leading: Icon(
                          orgOrName == 'org' ? Icons.business_outlined : Icons.contact_mail,
                          color: Colors.blue[500],
                        ),
                        trailing: Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.blue[500],
                        ),
                      ),
    ),
    );
  }
}