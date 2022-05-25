import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';


Future<int> getMyId(fullName, username, password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  
  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT id FROM accounts a where a.lookupName='$fullName'"),
      headers: <String, String>{'authorization': basicAuth});
  var json = jsonDecode(r.body);
  if(r.statusCode == 401) {

    return 9999999;
  }
    return int.parse(json['items'][0]['rows'][0][0]);

}

Future<String> getContactFuckFlutter(id, username, password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  print(id);

    print('asdasdadsadsadsadsasdasddas');

  if(id== null) {
    return 'hmmm';  
  }
  
  Response rContacts = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName from Contacts I where id=9001"),
  headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
  var contcatsJson = jsonDecode(utf8.decode(rContacts.bodyBytes));
  print('asdasdadsadsadsadsasdasddas');
  print(contcatsJson);
  

  if(contcatsJson.length > 0 && rContacts.statusCode== 200) {
    print('e');
  }

  return 'Hittade ej kontakt';
}



Future<String> getContact(id, username, password, users)async{

  if(id== null) {
    return 'hmmm';  
  }

  for(var user in users) {
    if(user['ID'] == null) {
      continue;
    }
    if(user['ID']  == int.parse(id)){
      return user['contact'];
    }


  };


  return 'Hittade ej kontakt';



}


Future<int> getUsersFromOrg(fullName, username, password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  
  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT id FROM accounts a where a.lookupName='$fullName'"),
      headers: <String, String>{'authorization': basicAuth});
  var json = jsonDecode(r.body);
  if(r.statusCode == 200) {
    return int.tryParse(json['items'][0]['rows'][0][0]);
  } else {
    return 9710;
  }
}