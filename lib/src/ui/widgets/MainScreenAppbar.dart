import 'package:flutter/material.dart';

dynamic mainAppBar(appTitle, setTitleTeam, refreshState) {
  return AppBar(
    title: Text(appTitle),
    actions: <Widget>[
      FlatButton(
        textColor: Colors.white,
        onPressed: () {
          refreshState();
        },
        child: Icon(
          Icons.refresh,
        ),
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
      PopupMenuButton<String>(
        onSelected: (String result) {
          switch (result) {
            case 'First Line':
              setTitleTeam(2, 'First Line');
              break;
            case 'Tech':
              setTitleTeam(7, 'Tech');
              break;
            case 'SCM':
              setTitleTeam(8, 'SCM');
              break;
            case 'Finance':
              setTitleTeam(6, 'Finance');
              break;
              case 'My Incidents':
              setTitleTeam(99, 'My Incidents');
              break;
            default:
              setTitleTeam(2, 'First Line');
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: "My Incidents",
            child: Text('My Incidents'),
          ),
          const PopupMenuItem<String>(
            value: "First Line",
            child: Text('First Line'),
          ),
          const PopupMenuItem<String>(
            value: "Tech",
            child: Text('Tech'),
          ),
          const PopupMenuItem<String>(
            value: "SCM",
            child: Text('SCM'),
          ),
          const PopupMenuItem<String>(
            value: "Finance",
            child: Text('Finance'),
          )
        ],
      ),
    ],
  );
}
