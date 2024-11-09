import 'dart:convert';

import 'package:cofffe/history.dart';
import 'package:cofffe/link.dart';
import 'package:cofffe/linker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Link> links = [];
  var activePage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [Linker(links: links,),History(links: links,)];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
          title: Text('Shortifyy'),

          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 10,
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: activePage,
          selectedItemColor: Colors.blue,
          onTap: (value) {
            setState(() {
              activePage = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              activeIcon: Icon(Icons.home),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              label: 'History',
              activeIcon: Icon(Icons.document_scanner)
            )
          ]
        ),


        body: screens[activePage]
        ),
    );
  }
}