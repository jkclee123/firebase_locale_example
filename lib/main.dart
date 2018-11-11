import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'demolocalizations.dart';
import 'data.dart';


class LoginScreen extends StatefulWidget{
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context){
    if (localeMap.isNotEmpty) return _readyScreen(context);
    else return _loadingScreen(context);
  }

  Widget _readyScreen(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(DemoLocalizations.of(context).getLabel("title")),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Text(
              DemoLocalizations.of(context).getLabel("username"),
              style: font36black,
            ),
            new Text(
              DemoLocalizations.of(context).getLabel("password"),
              style: font36black,
            ),
          ],
        )
      ),
    );
  }

  Widget _loadingScreen(context){
    _loadSnapshot();
    return Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _loadSnapshot() async{
    QuerySnapshot result = await Firestore.instance.collection('example').getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    setState(() {
      documents.map((data){
        localeMap[data.data['key']] = data.data[DemoLocalizations.of(context).getLangCode()];
      }).toList();
    });
  }
}

void main() {
  runApp(
    new MaterialApp(
      title: "Firebase Example",
      home: new LoginScreen(),
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('zh', ''),
      ],
      theme: ThemeData(),
    )
  );
}