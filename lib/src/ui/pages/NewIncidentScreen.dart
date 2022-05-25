import 'package:flutter/material.dart';
import '../widgets/MessageBox.dart';

class NewIncidentScreen extends StatefulWidget {
  NewIncidentScreen({Key key}) : super(key: key);

  @override
  _NewIncidentScreenState createState() => _NewIncidentScreenState();


}

class _NewIncidentScreenState extends State<NewIncidentScreen> {
  @override
  final messageController = TextEditingController();
  final subjectController = TextEditingController();

  _printLatestValuelol() {
    print(messageController.text);
  }

    void initState() {
    super.initState();
    subjectController.addListener(_printLatestValuelol);
    messageController.addListener(_printLatestValuelol);
  }
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(
          title: Text('Skriv in text'),
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
        ),body:(Container(
       child: Column(
         children: [
           MessageBox(messageController: messageController, placeholder: 'Ämne'),
           Expanded(
                flex: 3,
           child:MessageBox(messageController: subjectController, placeholder: 'Vad handlar ärendet om?'),
           ),
                    ElevatedButton(
                      
                                style: ElevatedButton.styleFrom(
    primary: Color.fromARGB(255, 241, 91, 87), minimumSize: const Size(60.0, 40.0),), child: Text('Till kategorival'))],
       ),
    )));
  }
}