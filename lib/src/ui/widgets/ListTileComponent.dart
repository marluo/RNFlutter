import 'package:flutter/material.dart';

ListTile buildListTile(BuildContext context, i, getDB, db, getSeverity, convertDate, getStatus) {
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
                                    'namelookupName': i['namelookupName'] != null
                                        ? i['namelookupName']
                                        : 'Ej Assignat'
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