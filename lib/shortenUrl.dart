import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Shortenurl extends StatefulWidget {

  Shortenurl({super.key});

  @override
  State<Shortenurl> createState() => _ShortenurlState();
}

class _ShortenurlState extends State<Shortenurl> {
  final _controller = TextEditingController();
  String? currLink;

  void getLink(String s) async{

  const String baseUrl = 'https://spoo.me/';

  final headers = {
    "Accept": "application/json",
    "Content-Type": 'application/x-www-form-urlencoded',
  };

  final payload = {
    'url' : s,
  };

  final encodedPayload = payload.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

  final response = 
  await http.post(
    Uri.parse(baseUrl),
    headers: headers,
    body: encodedPayload,
    );

    final data = jsonDecode(response.body);
    print(data['short_url']);
    setState(() {
      currLink = data['short_url'];
    });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(controller: _controller,),
              currLink != null ? Text(currLink!) : CircularProgressIndicator.adaptive(),
              ElevatedButton(onPressed: () => getLink(_controller.text), child: Text('Shorten lin')),
            ],
          ),
        ),
      ),
    );
  }
}