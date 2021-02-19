import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Gallery extends StatefulWidget {
  final String docs;
  Gallery(this.docs);
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int _index = 0;
  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 3;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 300;
    var _aspectRatio = _width / cellHeight;
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text('Wallpapers'),
        elevation: 1.0,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Tunisia_Wallpaper')
              .document(widget.docs)
              .collection('gallery')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator();
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                crossAxisSpacing: 0.5,
                mainAxisSpacing: 0.5,
                childAspectRatio: _aspectRatio,
              ),
              padding: EdgeInsets.only(top: 25, bottom: 120),
              physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot image = snapshot.data.documents[index];
                return Container(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, color: Colors.white24)),
                    child: SizedBox(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Scaffold(
                              bottomNavigationBar: FloatingNavbar(
                                selectedBackgroundColor: Colors.transparent,
                                selectedItemColor: Colors.white,
                                unselectedItemColor: Colors.white,
                                onTap: (int val) {
                                  setState(() async {
                                    _index = val;
                                    print(_index);
                                    if (_index == 0) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.of(context).pop();
                                          });
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballRotate,
                                            ),
                                          );
                                        },
                                      );
                                      _save(image['images']);
                                    }
                                    if (_index == 1) {
                                      switch (await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              backgroundColor: Color.fromRGBO(
                                                  58, 66, 86, 1.0),
                                              titlePadding: EdgeInsets.all(10),
                                              elevation: 5,
                                              title: const Text(
                                                'Set Image As:',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
                                              children: <Widget>[
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.all(10),
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 3),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              LoadingIndicator(
                                                            indicatorType:
                                                                Indicator
                                                                    .ballRotate,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    String result;
                                                    var file =
                                                        await DefaultCacheManager()
                                                            .getSingleFile(
                                                                image[
                                                                    'images']);
                                                    try {
                                                      result = await WallpaperManager
                                                          .setWallpaperFromFile(
                                                              file.path,
                                                              WallpaperManager
                                                                  .HOME_SCREEN);
                                                    } on PlatformException {
                                                      result =
                                                          'Failed to get wallpaper.';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            Icons.home,
                                                            color: Colors
                                                                .blueAccent,
                                                          )),
                                                          WidgetSpan(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                          )),
                                                          TextSpan(
                                                              text:
                                                                  'Home Screen'),
                                                        ],
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.all(10),
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 3),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              LoadingIndicator(
                                                            indicatorType:
                                                                Indicator
                                                                    .ballRotate,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    String result;
                                                    var file =
                                                        await DefaultCacheManager()
                                                            .getSingleFile(
                                                                image[
                                                                    'images']);
                                                    try {
                                                      result = await WallpaperManager
                                                          .setWallpaperFromFile(
                                                              file.path,
                                                              WallpaperManager
                                                                  .LOCK_SCREEN);
                                                    } on PlatformException {
                                                      result =
                                                          'Failed to get wallpaper.';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            Icons.lock_outlined,
                                                            color: Colors
                                                                .blueAccent,
                                                          )),
                                                          WidgetSpan(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                          )),
                                                          TextSpan(
                                                              text:
                                                                  'Lock Screen'),
                                                        ],
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  padding: EdgeInsets.all(10),
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 3),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              LoadingIndicator(
                                                            indicatorType:
                                                                Indicator
                                                                    .ballRotate,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    String result;
                                                    var file =
                                                        await DefaultCacheManager()
                                                            .getSingleFile(
                                                                image[
                                                                    'images']);
                                                    try {
                                                      result = await WallpaperManager
                                                          .setWallpaperFromFile(
                                                              file.path,
                                                              WallpaperManager
                                                                  .BOTH_SCREENS);
                                                    } on PlatformException {
                                                      result =
                                                          'Failed to get wallpaper.';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            Icons.smartphone,
                                                            color: Colors
                                                                .blueAccent,
                                                          )),
                                                          WidgetSpan(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                          )),
                                                          TextSpan(
                                                              text:
                                                                  'Both Screens'),
                                                        ],
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                              ],
                                            );
                                          })) {
                                      }
                                    }
                                    if (_index == 2) {
                                      Flushbar(
                                        title: "Tunisia",
                                        message: "image info",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        reverseAnimationCurve:
                                            Curves.decelerate,
                                        forwardAnimationCurve:
                                            Curves.elasticOut,
                                        backgroundColor: Colors.red,
                                        boxShadows: [
                                          BoxShadow(
                                              color: Colors.blue[800],
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient: LinearGradient(
                                            colors: [
                                              Colors.blueGrey,
                                              Colors.black
                                            ]),
                                        duration: Duration(seconds: 3),
                                        mainButton: IconButton(
                                          color: Colors.red[800],
                                          icon: Icon(Icons.favorite_outline),
                                          onPressed: () {},
                                          alignment: Alignment.topRight,
                                        ),
                                      )..show(context);
                                    }
                                    if (_index == 3) {}
                                  });
                                },
                                currentIndex: _index,
                                backgroundColor:
                                    Color.fromRGBO(58, 66, 86, 1.0),
                                items: [
                                  FloatingNavbarItem(
                                    icon: Icons.save,
                                    title: 'Save',
                                  ),
                                  FloatingNavbarItem(
                                    icon: Icons.wallpaper,
                                    title: 'Wallpaper',
                                  ),
                                  FloatingNavbarItem(
                                      icon: Icons.info_outline, title: 'Info'),
                                ],
                                width: double.infinity,
                                margin: EdgeInsets.all(0),
                                borderRadius: 0,
                              ),
                              body: GestureDetector(
                                child: Center(
                                  child: InteractiveViewer(
                                    panEnabled: false,
                                    boundaryMargin: EdgeInsets.all(0),
                                    minScale: 1.01,
                                    maxScale: 2,
                                    child: Container(
                                      child: Image.network(
                                        image['images'],
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }));
                        },
                        child: Container(
                          child: Image.network(
                            image['images'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    elevation: 5,
                  ),
                );
              },
            );
          }),
    );
  }
}

_requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  final info = statuses[Permission.storage].toString();
  print(info);
  _toastInfo(info);
}

_save(String http) async {
  var response =
      await Dio().get(http, options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
  );
  print(result);
  _toastInfo("$result");
}

_toastInfo(String info) {
  Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
}
