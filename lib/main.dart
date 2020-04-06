import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'util/http.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API pagination',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple api pagination '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // request limitation records
  int limitByRequest = 15;

  void login() {
    // do login to api endpoint, then set dio token with endpoint returned token
    // after login process
    //
    dioDefaults(token: "YOUR Authorization API TOKEN");
  }

  @override
  void initState() {
    // login method.
    login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      // use page wise library to simple unlimited scroll pagination ...
      body: PagewiseListView(
        pageSize: limitByRequest,
        itemBuilder: (context, entry, _) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  entry['gender'] == 'male' ? Icons.person : Icons.person_pin,
                  color: Colors.brown[200],
                ),
                title: Text(
                    "${entry['name']['title']}. ${entry['name']['first']} ${entry['name']['last']}"),
                subtitle: Text(entry['email']),
                trailing: CachedNetworkImage(
                    imageUrl: '${entry['picture']['thumbnail']}'),
              ),
              Divider()
            ],
          );
        },
        pageFuture: (pageIndex) async {
          var result =
              await dio.get('?results=$limitByRequest&page=${pageIndex + 1}');
          return result.data['results'];
        },
      ),
    );
  }
}
