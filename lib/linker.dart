import 'dart:convert';

import 'package:cofffe/clipboard.dart';
import 'package:cofffe/database.dart';
import 'package:cofffe/link.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Linker extends StatefulWidget {
  const Linker({
    super.key,
    //required this.links,
    });

    //final List<Link> links;

  @override
  State<Linker> createState() => _LinkerState();
}

class _LinkerState extends State<Linker> {

  Database db = Database();

  final _myBox = Hive.box('meraData');



  final _formkey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
  String? currLink;

  void bitingLink(String s) async{
    showDialog(
      barrierDismissible: false,
      context: context,
       builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text("Generating")
                ],
              ),
            ),
            
          );
       }
       );
      try{
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

    if(response.statusCode == 200){
      copyToClipboard(currLink!);
    //if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard"),
        backgroundColor: Colors.green,
      ),
      );
    //}
    }else{
      throw Exception("Api Status code: ${response.statusCode}");
    }

    Navigator.of(context).pop();
      }
      catch (e){
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went Wrong $e"),backgroundColor: Colors.red,));
      }

      // final resultLink = Link(
      //   originalLink: s,
      //   bittenLink: currLink!,
      //   );

      //if(db.Links.contains(resultLink)){
        //db.Links.add([s,currLink]);
        //db.addData([s,currLink]);
        db.loadData();
        db.Links.add([s,currLink]);
        db.saveData();
      //}

      //https://spoo.me/Nsdq6V

  }





  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        // Lottie.asset(
        //   'assets/a1.json',
        //   width: 200,
        //   height: 200,
        // ),
        Lottie.asset('assets/a2.json'),

        Text('A Link Shorter App..',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

        SizedBox(height: 60,),

        Form(
          key: _formkey,
          child: TextFormField(
            controller: _controller1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Enter your Url',
              prefixIcon: Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100)
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8.0,
              ),
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return "Please enter a valid url";
                }
                
                if(!value.startsWith('https://') && !value.startsWith('www.')){
                  return "Please enter a valid url";
                }

                // final urlRegex = RegExp(
                //   r'/^(https?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+)(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/'
                // );

                // if(!urlRegex.hasMatch(value)) {
                //   return "Please enter a valid url";
                // }
                return null;
              },
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 8,
            ),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if(!_formkey.currentState!.validate()){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid Url')));
              return;
            }
            bitingLink(_controller1.text);
          },
           child: Text("Get Link"),
        ),


      ],
    );
  }
}