import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Android Request in Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = '';

  Future<void> fetchData() async {
    var url = Uri.parse('http://127.0.0.1:8000/get');
    var response = await http.get(url);
    if (response.statusCode == 200){
      print('Data fetch sucessfully! : ${response.statusCode}');
      setState(() {
        _data = response.body;
      });
    } else {
      print('Data fetch failed!');
      setState(() {
        _data = 'Data fetch failed! : ${response.statusCode}';
      });
    }
  } 

  Future<void> createData() async{
    var url = Uri.parse('http://127.0.0.1:8000/post');
    var response = await http.post(url, body: {'tittle':'New Post', 'body':'Here is the body', 'userId':'1'});
    if (response.statusCode == 200 || response.statusCode == 201){
      setState(() {
        _data = 'Data created sucessfully! : ${response.body}';
      });
    } else {
      setState(() {
        _data = 'Data created failed!';
      });
    }
  }

  Future<void> deleteData() async {
    var url = Uri.parse('http://127.0.0.1:8000/');
    var response = await http.delete(url);
    if (response.statusCode == 200 || response.statusCode == 201){
      print('Data fetch sucessfully! : ${response.body}');
      setState(() {
        _data = 'Data deleted';
      });
    } else {
      print('Data fetch failed!');
      setState(() {
        _data = 'Data deleted failed';
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: fetchData, child: Text('Fetch Data')),
                ElevatedButton(onPressed: createData, child: Text('Create Data')),
                ElevatedButton(onPressed: deleteData, child: Text('Update Data')),
              ],
            ),
            Expanded(child: SingleChildScrollView(
              child: Text(_data),
            ))
          ],
        ),
      ),
    );
  }
}
