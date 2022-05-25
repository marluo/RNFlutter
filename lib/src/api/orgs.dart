import 'package:http/http.dart';
import 'dart:convert';




Future<String> queryOrg(id, username, password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  String orgname;

  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/organizations/$id"),
      headers: <String, String>{'authorization': basicAuth});
  print(r.statusCode);
  var json = jsonDecode(utf8.decode(r.bodyBytes));
  orgname = json['lookupName'];
  
  if(r.statusCode == 200) {
    return orgname;
  } else {
    return orgname; 
  }
}



Future<List> usersFromOrgs(username, password, id) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT id, lookupName, organization from contacts I where organization=$id"),
  headers: <String, String>{'authorization': basicAuth});
  print(r.statusCode);
  var json = jsonDecode(utf8.decode(r.bodyBytes));


  if(r.statusCode == 200) {
    return json['items'][0]['rows'];
  } else {
    return [[200, 'hej', 200]];
  }


}


/*Future<String> searchForOrgs(searchValue, username, password) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  String orgname;

  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/organizations/$id"),
      headers: <String, String>{'authorization': basicAuth});
  print(r.statusCode);
  var json = jsonDecode(utf8.decode(r.bodyBytes));
  orgname = json['lookupName'];
  
  if(r.statusCode == 200) {
    return orgname;
  } else {
    return orgname; 
  }
}*/