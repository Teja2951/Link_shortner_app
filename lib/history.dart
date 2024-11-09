import 'package:cofffe/link.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  const History({
    super.key,
    required this.links,
    });

    final List<Link> links;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  void removeLink(Link link) {
    setState(() {
      widget.links.remove(link);
    });
  }

  void openUrl(String url) async{
    Uri uri = Uri.parse(url);
    await launchUrl(uri,mode: LaunchMode.externalApplication);
  }


  @override
  Widget build(BuildContext context) {
    return widget.links.isEmpty?
    Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Image.asset('assets/empty.jpg'),),
    ) :
    ListView.separated(
      itemCount: widget.links.length,
      itemBuilder: (context , index){
        return ListTile(
          onTap: () {
            openUrl(widget.links[index].bittenLink);
          },
          title: Text(widget.links[index].originalLink),
          subtitle: Text(widget.links[index].bittenLink),
          trailing: IconButton(
            onPressed: () => removeLink(widget.links[index]),
             icon: Icon(Icons.delete,color: Colors.red),
             ),
        );
      },

      separatorBuilder: (context , index) => const Divider(height: 0,)
      );
  }
}