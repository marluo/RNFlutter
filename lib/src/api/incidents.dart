import 'package:http/http.dart';
import 'dart:convert';
import '../data/orglist.dart';
import './queryHelpers.dart';




Future<List> queryContacts(username, password, from, to) async {

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName from Contacts I WHERE ID BETWEEN $from and $to"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
  if(r.statusCode == 401) {
      return ['auth'];
    }

  print(r.statusCode);

    var users = jsonDecode(utf8.decode(r.bodyBytes));
    List contacts = users['items'][0]['rows'];
    return contacts;




}


Future<List> queryMyIncidents(id, username, password, team, sort) async {


  try {
    print(team);
  String account = '';

  if(team == 99) {
    team = '6,7,8,2'; 
    account ='AND I.assignedTo.account = $id'; 
  }
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Response r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName, I.updatedTime, I.product, I.category, I.subject, I.severity, I.organization, I.queue, I.statusWithType.*, I.assignedTo.*, I.customFields.c.inc_types from INCIDENTS I where I.queue IN($team) and (I.statusWithType.status=1 or I.statusWithType.status=102 or I.statusWithType.status=104 or I.statusWithType.status=8 or I.statusWithType.status=110 or I.statusWithType.status=8) $account order by I.lookupName"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
      print(r.statusCode);
  if(r.statusCode == 401) {
      return ['auth'];
    }
  Response rAccountsStaffGroup = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName, staffGroup from accounts I where I.staffGroup=100352"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});


  if(r.statusCode == 401) {
      return ['auth'];
    }

    var users = jsonDecode(utf8.decode(rAccountsStaffGroup.bodyBytes));
    List accounts = users['items'][0]['rows'];



  var json = jsonDecode(utf8.decode(r.bodyBytes));
  List incidents = json['items'][0]['rows'];
  List orgs = orgsFullList['items'][0]['rows'];
  List formattedIncidents = [];


  if(r.statusCode == 401) {
      return ['auth'];
    }



  incidents.forEach((var incident) {
    formattedIncidents.add({
          'incidentId': incident[0],
          'subject': incident[5],
          'incidentlookupName': incident[1],
          'incidentUpdateTime': incident[2],
          'status': incident[9],
          'organizationId': incident[7],
          'nameId': incident[11],
          'queue': incident[8],
          'severity': incident[6]
    });
  });

 
  formattedIncidents.forEach((var incident) {
    orgs.forEach((var org) {
      if(org[0] == incident['organizationId'] && org[0] != null){
        incident['orglookupName'] = org[1];
        incident['orgId'] = org[0];
      }
  });
  });



  formattedIncidents.forEach((var incident) {
      accounts.forEach((var user) {
      if(user[0] == incident['nameId'] && user[0] != null){
        incident['namelookupName'] = user[1];
      }
  });
    });

/*   for(var acc in accs) {
    

      //print(acc['id'].toString() + ':accid-incident: ' + incident[7].toString());
      if(acc[0] == incident['nameId'] && acc[0] != null){
        incident['namelookupName'] = acc[1];
      } */

  formattedIncidents.sort((a, b) => int.parse(b['incidentId']).compareTo(int.parse(a['incidentId'])));
  if(r.statusCode == 200) {
    return formattedIncidents;
  } if (r.statusCode == 401) {
    return 
      ['error'];
  }
  else {
    return ['error'];
  }

  } catch (e) {
    print(e);
    return ['error'];
  }
}








Future<List<dynamic>> queryOneIncident(id, username, password, db, queryDB) async {

  try {
    
  List incidentTexts = [];
  List fileAttachmentList = [];
  String usersList = '';
  String namn;
  List cleanedHtml;
  String assignedAccount;
  Response r;
  Response rOrg;
  Response fileAttachments;
  Response rAccountsStaffGroup;

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

    
  r = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName, I.product,  I.threads.createdTime, I.threads.entryType, I.threads.text, I.category, I.subject, I.severity, I.organization, I.threads.mailHeader, I.queue, I.statusWithType.*, I.assignedTo.*, I.customFields.c.app_version,I.customFields.c.kernel_version,I.customFields.c.product_version, I.customFields.c.product_other, I.customFields.c.inc_types, I.customFields.c.inc_types_jeeves_portals, I.threads.account, I.threads.createdTime, I.threads.contact, I.customFields.c.cust_name, I.customFields.c.assoc_org_id from INCIDENTS I where I.id=$id Order by I.threads.text"),
  headers: <String, String>{'authorization': basicAuth});
  if(r.statusCode == 401) {
      return ['error'];
    }
  var jsonIncident = jsonDecode(utf8.decode(r.bodyBytes));
  rOrg = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT Version, Other, Product, orgid from CO.AssetData C where orgid=${jsonIncident['items'][0]['rows'][0][9]} and (Product is NULL or Product=1)"),
    headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
  if(rOrg.statusCode == 401) {
      return ['error'];
    }
  var jsonOrg = jsonDecode(utf8.decode(rOrg.bodyBytes));

    fileAttachments = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/incidents/$id/fileAttachments"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
      if(fileAttachments.statusCode == 401) {
        return ['error'];
      }

    rAccountsStaffGroup = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName, staffGroup from accounts I where I.staffGroup=100352"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
      dynamic accountsJson = jsonDecode(utf8.decode(rAccountsStaffGroup.bodyBytes));
      List accounts = accountsJson['items'][0]['rows'];

    /*Response rContacts = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/queryResults?query=SELECT DISTINCT I.ID, I.lookupName from Contacts I"),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
      var contcatsJson = jsonDecode(utf8.decode(rContacts.bodyBytes));
      List contacts = contcatsJson['items'][0]['rows'];*/

    dynamic fileJson = jsonDecode(utf8.decode(fileAttachments.bodyBytes));
    await Future.forEach(fileJson['items'],(var fileId) async{
      Response singleFileAttachment = await get(Uri.parse(fileId['href']),
      headers: <String, String>{'Content-Type': 'application-json', 'authorization': basicAuth});
      var data = jsonDecode(utf8.decode(singleFileAttachment.bodyBytes));
      fileAttachmentList.add({'fileName': data['fileName'], 'link': fileId['href']});
    });

  await Future.forEach(jsonIncident['items'][0]['rows'], (incident) async {
     int index = jsonIncident['items'][0]['rows'].indexOf(incident);
     cleanedHtml = removeAllHtmlTags(incident[5]);
     String name = await db.checkContacts(db, username, password, queryDB, incident[24]);
     //namn = await getContact(incident[24], username, password, usersList);
     incidentTexts.add({'text': cleanedHtml, 'messageType': incident[4], "created": incident[23], "answerContact":incident[24] == null ? accountFinder(incident[22], accounts) : name, 'createdBy': index == 0 && incident[22] == null ?  name : accountFinder(incident[22], accounts) });

   });

  

  /*jsonIncident['items'][0]['rows'].asMap().forEach((index, incident){
    print(index);
    String cleanedHtml = removeAllHtmlTags(incident[5]);
    incidentTexts.add({'text': cleanedHtml, 'messageType': incident[4], "contact": accountFinder(incident[14], contacts), "created": incident[23], "answerContact":incident[24] == null ? accountFinder(incident[22], accounts) : accountFinder(incident[24], contacts), 'createdBy': index == 0 && incident[22] == null ?  accountFinder(incident[24], contacts) : accountFinder(incident[22], accounts) });
  });*/

  assignedAccount = jsonIncident['items'][0]['rows'][0][14];





  
  /*int accountid = json['items'][0]['rows'][0][14] != null ? int.parse(json['items'][0]['rows'][0][14]) : null;

if(accountid != null) {


  Response accountR = await get(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/accounts/$accountid"),
  headers: <String, String>{'authorization': basicAuth});
  var accountjson = jsonDecode(utf8.decode(accountR.bodyBytes));
  account = accountjson['lookupName'];
    
} else {

  account = 'Ingen';
}*/


  /*Map app_version = json['customFields']['c']['app_version'];
  Map kernel_version = json['customFields']['c']['kernel_version'];
  String updated = json['updatedTime'];
  String created = json['createdTime'];
  String assignedTo = json['createdTime'];
  String severity = json['severity']['id'];
  String subject = json['subject']['id'];*/
  if(r.statusCode == 200) {
    return [List.from(incidentTexts.reversed), {
      'products': jsonIncident['items'][0]['rows'][0][2],
      'serviceCategories': jsonIncident['items'][0]['rows'][0][6],
      'queue': jsonIncident['items'][0]['rows'][0][11],
      'severity': jsonIncident['items'][0]['rows'][0][8],
      'status': jsonIncident['items'][0]['rows'][0][12],
      'account': 'if removed, will be problems..',
      'type':jsonIncident['items'][0]['rows'][0][20],
      'appversion':jsonIncident['items'][0]['rows'][0][16],
      'kernelversion':jsonIncident['items'][0]['rows'][0][17],
      'assignedTo':assignedAccount,
      'fileAttachmentList': fileAttachmentList,
      'cust_id': jsonIncident['items'][0]['rows'][0][26],
      'cust_name': jsonIncident['items'][0]['rows'][0][25]
    },{'app':   jsonOrg['items'][0]['rows'].length > 0 ? jsonOrg['items'][0]['rows'][0][0] : null,'kernel':   jsonOrg['items'][0]['rows'].length > 0 ? jsonOrg['items'][0]['rows'][0][1] : null }];
  } else {
    return ['Error'];
  }

   } catch (e) {
     print(e);
     return ['asasdasd'];
  }
}


Future<Map<String, dynamic>> queryDropDowns(category) async {
  if(category == 'queue') {

    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/queue.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;
  }

  if(category == 'type') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/type.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;

  }

  if(category == 'severity') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/severity.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;

  }

  if(category == 'serviceCategories') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/serviceCategories.json"),
      headers: <String, String>{'Content-Type': 'application/json'}); 
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    json['serviceCategories'].sort((a, b) {
    return a['lookUpName'].toString().compareTo(b['lookUpName'].toString());
});
    return json;

  }

  if(category == 'status') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/status.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;

  }

  if(category == 'products') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/products.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;

  }
  if(category == 'category') {

  }
  if(category == 'appversion') {

    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/appversion.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;

  }

  if(category == 'kernelversion') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/kernelversion.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;
  }

  if(category == 'assignedTo') {
    Response r = await get(Uri.parse("https://dandelion-silky-lodge.glitch.me/assignedTo.json"),
      headers: <String, String>{'Content-Type': 'application/json'});
    var json = jsonDecode(utf8.decode(r.bodyBytes));
    return json;
  }

  return {'ee': 'dd', 'dd': []};

}


Future<bool> updateIncidentCategories(incidentid, data, username, password)async {

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Response r = await post(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/incidents/$incidentid"),
      headers: <String, String>{'Content-Type': 'application/json', 'authorization': basicAuth, "X-HTTP-Method-Override": "PATCH"},
      body: jsonEncode(data));
     if(r.statusCode == 200) {
       print('updated');
      return true;
    } else {
      print('ej updated');
      return false;
    }
}

Future<bool> addResponseToIncident(incidentid, data, username, password, endpoint)async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Response r = await post(Uri.parse("https://jeeves.custhelp.com/services/rest/connect/v1.3/${endpoint}"),
      headers: <String, String>{'Content-Type': 'application/json', 'authorization': basicAuth, "X-HTTP-Method-Override": "PATCH"},
      body: jsonEncode(data));
     if(r.statusCode == 200) {
      return true;
    } else {
      return false;
    }
}
