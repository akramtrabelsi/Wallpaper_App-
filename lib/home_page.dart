import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_app/galery.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          'Tunisia_Wallpaper',
          style: GoogleFonts.aladin(fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Tunisia_Wallpaper').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 12, bottom: 25),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot image = snapshot.data.documents[index];
              return Card(
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                elevation: 8.0,
                child: ListTile(
                  tileColor: Color.fromRGBO(64, 75, 96, .9),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  hoverColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gallery(image.documentID)));
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: Image.network(
                      image['img'],
                      width: 120.0,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  title: Text(
                    image['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Tunisia_Wallpaper')
                            .document(image.documentID)
                            .collection('gallery')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null)
                            return CircularProgressIndicator();
                          return RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.linear_scale,
                                  color: Colors.amber,
                                )),
                                TextSpan(
                                    text: snapshot.data.documents.length
                                        .toString()),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
