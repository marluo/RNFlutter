import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "../../api/incidents.dart";

class IncidentDropDown extends StatefulWidget {
  IncidentDropDown({this.category, this.picked, this.savedIncident, Key key})
      : super(key: key);

  final String category;
  final String picked;
  final Map savedIncident;

  @override
  IncidentDropDownState createState() =>
      IncidentDropDownState(category: category, picked: picked);
}

class IncidentDropDownState extends State<IncidentDropDown> {
  String category;
  String picked;
  String selectedCategory;
  String _pickedUser;
  bool noValueRN;
  Map data = {};
  List lol;
  int _selection;
  IncidentDropDownState({this.category, this.picked});

  var everythingInIncident;
  @override
  void initState() {
    _selection = null;
    noValueRN = false;
    super.initState();
    selectedCategory = this.category;
    queryDropDowns(selectedCategory).then((e) {
      setState(() {
        data = e;
        _selection = data[selectedCategory][0]['id'];
        _pickedUser = this.picked;
      });
    });
  }

  @override
 void dispose(){
  // Additional disposal code
  super.dispose();
 }

  int checkIfInMap(pickedUser) {
    if(pickedUser == null) {
      return 9932;
    }
    for(var val in data[selectedCategory]) {
      if(val['id'] == int.parse(pickedUser)) {
        return int.parse(_pickedUser);
      }

    }

    return 129954;

  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: data.length > 0
            ? DropdownButton(
                value: checkIfInMap(_pickedUser),
                items: [
                  for (var a in data[selectedCategory]) 
                    DropdownMenuItem(
                      child: Text(a['lookUpName'] == null ? 'placeholder' : a['lookUpName']),
                      value: a['id'],
                    )
                ],
                onChanged: (v) {
                  print(v);
                  print(_pickedUser);
                  if (v.toString() == _pickedUser.toString()) {
                    print('same');
                    return;
                  } if(selectedCategory == "assignedTo" && v == 9932) {
                    setState(() {
                      noValueRN = true;
                    });
                  }
                  switch (selectedCategory) {
                    case 'severity':
                      widget.savedIncident['severity'] = {"id": v};
                      break;
                    case 'products':
                      widget.savedIncident['product'] = {"id": v};
                      break;
                    case 'queue':
                      widget.savedIncident['queue'] = {"id": v};
                      break;
                    case 'assignedTo':
                      widget.savedIncident['assignedTo'] = {"account": noValueRN ? null : {"id": v} };
                      break;
                    case 'type':
                      if (widget.savedIncident.containsKey('customFields')) {
                        print(v.runtimeType);
                        widget.savedIncident["customFields"]["c"]["inc_types"] = {"id": v};
                       } else {
                        widget.savedIncident['customFields'] = {
                          "c": {
                            "inc_types": {"id": v}
                          }
                        };
                        print(widget.savedIncident);
                      }
                      break;

                    case 'status':
                        widget.savedIncident['statusWithType'] = {"status": {
            "id": v,
        }};
                      break;
                    case 'appversion':
                      if (widget.savedIncident.containsKey("customFields")) {
                        widget.savedIncident["customFields"]["c"]["app_version"] = {"id": v};
                      } else {  
                        widget.savedIncident['customFields'] = {
                          "c": {
                            "app_version": {"id": v}
                          }
                        };
                      }
                      break;
                    case 'kernelversion':
                        if (widget.savedIncident.containsKey('customFields')) {
                        widget.savedIncident["customFields"]["c"]["kernel_version"] = {"id": v};
                        } else {
                        widget.savedIncident['customFields'] = {
                          "c": {
                            "kernel_version": {"id": v}
                          }
                        };

                      }
                      break;
                      case 'serviceCategories':
                      widget.savedIncident['category'] = {"id": v};
                      break;
                    default:
                      break;
                  }
                  if (selectedCategory == 'severity') {
                    widget.savedIncident[selectedCategory] = {"id": v};
                  }

                  if (selectedCategory == 'product') {
                    widget.savedIncident[selectedCategory] = {
                      "product": {"id": 1}
                    };
                  }
                  
                  setState(() {
                    _pickedUser = v.toString();
                  });
                })
            : DropdownButton(
                value: "Loading",
                items: [
                  DropdownMenuItem(
                    child: Text('Loading'),
                    value: 'Loading',
                  )
                ],
                onChanged: (value) {
                  print(value);
                  if (value == _selection) {
                    return;
                  }

                  setState(() {
                    _selection = value;
                  });
                }));
  }
}
