import 'package:Jeves_RN_App/src/ui/pages/MessageScreen.dart';
import 'package:Jeves_RN_App/src/ui/pages/NameScreen.dart';
import 'package:flutter/material.dart';
import '../../data/orglist.dart';

class SearchOrgScreen extends StatefulWidget {
  final dynamic db;
  final dynamic asd;
  String searchPlaceHolder;
  String orgOrName;
  SearchOrgScreen({Key key, this.searchPlaceHolder='Sök efter en organisation', this.orgOrName='org', this.db, this.asd}) : super(key: key);

  @override
  _SearchOrgScreenState createState() => _SearchOrgScreenState();
}

class _SearchOrgScreenState extends State<SearchOrgScreen> {

  final searchController = TextEditingController();
  List listOfSearchResults;
  List accounts = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOfSearchResults = [];
    searchController.addListener(_printLatestValuelol);
  }

    _printLatestValuelol() {

  }


  searchOrgs(fty, orgsFullList, fullAcountList, orgOrName) async {
    List searchResults = [];
    if(orgOrName == 'org'){
    for (var orgname in orgsFullList) {
          searchResults.add({'id': orgname[0],'orgname': orgname[1]});
    }
    } else if (orgOrName == 'user') {
      for (var user in fullAcountList) {
          if(user[1] != null) {
          searchResults.add({'id': user[0],'orgname': user[1]});
          }
      }

    }


  String checkOrgOrName(check) {

    if(check == 'org') {
      return 'orgname';
    }

    return 'name';

  }


  for(var x in searchResults) {


  }

  


  List filteredOrgs = searchResults.where(
  (name) => name['orgname']?.toLowerCase().contains(searchController.text.toLowerCase())).toList();



    setState(() {
      listOfSearchResults = filteredOrgs;

    });
    /*for(var a in orgsFullList['items'][0]['rows']) {
      print(a);
    }*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(
          title: Text('Sök efter ord/id'),
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
        ),
        body:Container(
        padding: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: <Widget>[
                Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(controller: searchController, decoration: InputDecoration(
                        suffixIcon: IconButton(
      onPressed: () {searchOrgs(searchController.text, orgsFullList['items'][0]['rows'], accounts, widget.orgOrName);},
      icon: Icon(Icons.search),
    ),
    border: InputBorder.none,
    hintText: widget.searchPlaceHolder
    
  ),
                    ))),
            if(listOfSearchResults.length>0)
            for(var company in listOfSearchResults )
            CompanyButton(company:company, orgOrName: widget.orgOrName) else Center(child:Text('Inget framsökt'))],
        ),
      ));
  }
}

class CompanyButton extends StatelessWidget {
  

  final Map company;
  final String orgOrName;

  const CompanyButton({
    Key key, this.company, this.orgOrName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    return CardListIncident(arguments: arguments, company: company, orgOrName: orgOrName);
  }
}

class CardListIncident extends StatelessWidget {
  const CardListIncident({
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
                        /*onTap: () {
                          Navigator.push(context,
                                  MaterialPageRoute(
      builder: (context) => NameScreen(org: company, asd:arguments[0], db:arguments[1]),
    ));
                        }*/
                        title: Text(company['orgname']),
                        subtitle: Text('ID: ${company['id']}'),
                        leading: Icon(
                          orgOrName == 'org' ? Icons.business_outlined : Icons.contact_mail,
                          color: Colors.blue[500],
                        ),
                        /*trailing: Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.blue[500],
                        ),*/
                      ),
    ),
    );
  }
}