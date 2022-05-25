import 'package:http/http.dart';
import 'dart:convert';


Future<bool> loginzeUser(username,password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print(basicAuth);

  Response r = await get(Uri.parse('https://jeeves.custhelp.com/services/rest/connect/v1.3/'),
      headers: <String, String>{'authorization': basicAuth});


  if(r.statusCode == 401) {
    return Future<bool>.value(false);
  }    

  if(r.statusCode == 200) {
    return Future<bool>.value(true);
  } else {
    return Future<bool>.value(false);
  }
}