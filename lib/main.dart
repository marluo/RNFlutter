import 'package:Jeves_RN_App/src/ui/pages/SearchOrgScreen.dart';
import 'package:flutter/material.dart';
import 'package:Jeves_RN_App/src/ui/pages/MessageScreen.dart';
/*import 'package:http/http.dart';*/
import 'package:sqflite/sqflite.dart';
import "./src/api/login.dart";
import 'dart:io';
/*import 'package:http/http.dart';
import './src/api/user.dart';*/
import "./src/db/database.dart";
import "./src/ui/pages/MainScreen.dart";
import "./src/ui/pages/IncidentScreen.dart";
import './src/ui/pages/MessageScreen.dart';
import './src/data/colorData.dart';
/*import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';*/

void main() async {

  // needed if you intend to initialize in the `main` function
    /*WidgetsFlutterBinding.ensureInitialized();
    Workmanager.initialize(
      
      // The top level function, aka callbackDispatcher
      callbackDispatcher,
      
      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true
  );
  // Periodic task registration
  Workmanager.registerPeriodicTask(
    "2",
      
    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",
      
    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 15),);*/
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

/*void callbackDispatcher() async {
  Workmanager.executeTask((task, inputData) async {
      var db = new DBHelper();

      getDb(db) async {
        return await db.db;
      }

    print('kek');

    Map userInfo = await getUserAndPassword(getDb, db);

    int userId = await getMyId(userInfo['fullName'], userInfo['login'], userInfo['password']);
    print(userId);
    //Map incidents = await getMyId(userInfo['fullName'], userInfo['login'], userInfo['password'])


    //String incidentUpdated = await queryIfIncidentUpdated()

        
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
      
    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('drawable/jeeves');
      
    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
    });
}*/



/*Future _showNotificationWithDefaultSound(flip) async {
    
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    
  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics );
  await flip.show(0, 'Incident updated!',
    'You have a new icnident updated!',
    platformChannelSpecifics, payload: 'Default_Sound'
  );
}*/


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var db = new DBHelper();
    Map userInfo;

    getDb(db) async {
      return await db.db;
    }
    

    return MaterialApp(
      title: 'Jeeves RN App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",  
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: MaterialColor(0xFF184453, color),
        primaryColor: Color.fromARGB(255, 30, 68, 84),
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>
            MyHomePage(db: db, getDB: getDb, title: 'Jeeves RN App'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) =>
            MainScreen(db: db, getDB: getDb, title: 'Jeeves RN App'),
        '/third': (context) => IncidentScreen(),
         '/fourth': (context) => MessageScreen(),
         '/fifth': (context) => SearchOrgScreen(),
         '/sixth': (context) => SearchOrgScreen()

        
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({@required this.db, @required this.getDB, Key key, this.title})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final DBHelper db;
  final dynamic getDB;

  @override
  _MyHomePageState createState() => _MyHomePageState(db: db, getDB: getDB);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({
    @required this.db,
    @required this.getDB,
  });
  final DBHelper db;
  final dynamic getDB;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isButtonDisabled;
  bool userFailedPw = false;
  String buttonText = "Login";

  _printLatestValue() {
    print("Second text field: ${usernameController.text}");
    print("Second text field: ${passwordController.text}");
  }

  Future<bool> isUserLoggedIn(context) async {
    Database queryDB = await getDB(db);
    List<Map> list = await queryDB.rawQuery('SELECT USERNAME, password FROM User');
    print(list.length);
    if (list.length > 0) {
      bool loggedIn =
          await loginzeUser(list[0]['USERNAME'], list[0]['password']);
      if (loggedIn == true) {
        Navigator.pushReplacementNamed(context, '/second');
        return true;
      }else {
      print('else');
      await queryDB.rawQuery('DELETE FROM User');
      return false;
    }
    }
    return false;
  } 

  Image jeevesLogo;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    usernameController.addListener(_printLatestValue);
    _isButtonDisabled = false;
    userFailedPw = false;
    buttonText = "Login";
    jeevesLogo = Image.asset("images/jeeves.png");
  }

 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(jeevesLogo.image, context);
    
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/second');
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 68, 84),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SingleChildScrollView(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            jeevesLogo,
            FutureBuilder(
                future: isUserLoggedIn(context),
                builder: (context, snapshot) {
                  if (snapshot.data == false) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(10),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                controller: usernameController,
                                decoration: InputDecoration(
   filled: true,
   fillColor:Theme.of(context).primaryColor,
   labelText: 'Username',
   labelStyle: TextStyle(
        color: Colors.white,
        
      ),
   focusedBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(20)),
     borderSide: BorderSide(width: 2,color: Colors.white),
   ),
   disabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(10)),
     borderSide: BorderSide(width: 2,color: Colors.orange),
   ),
   enabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(10)),
     borderSide: BorderSide(width: 2,color: Colors.white),
   ),
   border: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 2,)
   ),
   errorBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 1,color: Colors.black)
   ),
   focusedErrorBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
   )),
                              )),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
   filled: true,
   fillColor:Theme.of(context).primaryColor,
   labelText: 'Password',
   labelStyle: TextStyle(
        color: Colors.white,
        
      ),
   focusedBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(20)),
     borderSide: BorderSide(width: 2,color: Colors.white),
   ),
   disabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(10)),
     borderSide: BorderSide(width: 2,color: Colors.orange),
   ),
   enabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(10)),
     borderSide: BorderSide(width: 2,color: Colors.white),
   ),
   border: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 2,)
   ),
   errorBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 1,color: Colors.black)
   ),
   focusedErrorBorder: OutlineInputBorder(
     borderRadius: BorderRadius.all(Radius.circular(4)),
     borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
   ))
                              )),
                          Text.rich(TextSpan(
                              style: TextStyle(color: Colors.red[200]),
                              text: userFailedPw == true  
                                  ? 'Incorrect Password or Username'
                                  : '')),
                          Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
    primary: Color.fromARGB(255, 241, 91, 87)),
                            child: Text(buttonText == null ? '' : buttonText),
                            onPressed: _isButtonDisabled
                                ? null
                                : () async {
                                    bool correctUser = await loginzeUser(
                                        usernameController.text,
                                        passwordController.text);
                                    if (correctUser == true) {
                                      Database newDB = await getDB(db);
                                        db.insertUser(newDB, usernameController.text,
                                        passwordController.text);
                                        print('created user');

                                      _navigateToNextScreen(context);
                                    } else {
        
                                      if (!mounted) {
                                        return; // Just do nothing if the widget is disposed.
                                      }
                                      /*setState(() {
                                        buttonText = 'Login';
                                        userFailedPw = true;
                                        _isButtonDisabled = false;
                                      });*/
                                    }
                                  },
                          ))
                        ],
                      ),
                    );
                  } if(snapshot.connectionState == ConnectionState.waiting) {
                    print('Kollar..');
                    return const Center(child: CircularProgressIndicator());
 
                    
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

