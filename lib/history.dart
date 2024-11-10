import 'package:cofffe/clipboard.dart';
import 'package:cofffe/database.dart';
import 'package:cofffe/link.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  const History({
    super.key,
    // required this.links,
    });

    // final List<Link> links;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  Database db = Database();

  void initState() {
    super.initState();
    if(_myBox.get('key') == null) {
      //db.initial();
      db.Links = [];
    }else{
      db.loadData();
    }
  }


  final _myBox = Hive.box('meraData');

  void removeLink(int index) {
    setState(() {
      db.Links.removeAt(index);
    });
    db.saveData();
  }

  void openUrl(String url) async{
    Uri uri = Uri.parse(url);
    await launchUrl(uri,mode: LaunchMode.externalApplication);
  }


  @override
  Widget build(BuildContext context) {
    return db.Links.isEmpty?
    Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Image.asset('assets/empty.jpg'),),
    ) :
    ListView.separated(
      itemCount: db.Links.length,
      itemBuilder: (context , index){
        return ListTile(
          onTap: () {
            openUrl(db.Links[index][1]);
          },
          onLongPress: () {
             copyToClipboard(db.Links[index][1]);
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Copied to clipboard"),
                    backgroundColor: Colors.green,
               ),
      );
          },
          title: Text(db.Links[index][0]),
          subtitle: Text(db.Links[index][1]),
          trailing: IconButton(
            onPressed: () => removeLink(index),
             icon: Icon(Icons.delete,color: Colors.red),
             ),
        );
      },

      separatorBuilder: (context , index) => const Divider(height: 0,)
      );
  }
}