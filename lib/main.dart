import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Api Filter list Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List names = [];
  List filteredNames = [];
  List filteredEmails = [];
  List filteredAvatar = [];
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Search Suggestions');

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(filteredAvatar[index]),
          ),
          title: Text(filteredNames[index]),
          subtitle: Text(filteredEmails[index]),
          onTap: () => print(filteredNames[index]),
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    var url = Uri.parse('https://reqres.in/api/users?page=2');
    http.Response response = await http.get(
      url,
      // headers: <String, String>{
      //   'Authorization':
      //       '',
      //   'Customer-ID': '',
      // },
    );
    var data = json.decode(response.body);
    List tempListName = [];
    List tempListEmail = [];
    List tempListAvatar = [];
    for (int i = 0; i < data['data'].length; i++) {
      tempListName.add(data['data'][i]['first_name']);
      tempListEmail.add(data['data'][i]['email']);
      tempListAvatar.add(data['data'][i]['avatar']);
    }
    print(tempListName);
    setState(() {
      names = tempListName;
      filteredNames = names;
      filteredEmails = tempListEmail;
      filteredAvatar = tempListAvatar;
    });
  }
}
