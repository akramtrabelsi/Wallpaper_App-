import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'pagemodel.dart';
import 'home_page.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(
      home: OnBoarding(),
      debugShowCheckedModeBanner: false,
    ));

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<PageModel> pages = List<PageModel>();

  ValueNotifier<int> _pageViewNotifier = ValueNotifier(0);

  void __addPages() {
    pages.add(PageModel(
      'Welcome',
      '1- Making friends is easy as waving your hand back and forth in easy step ',
      'assets/images/bg1.jpg',
    ));

    pages.add(PageModel(
        'Alarm',
        '2- Making friends is easy as waving your hand back and forth in easy step ',
        'assets/images/bg2.jpg'));

    pages.add(PageModel(
        'Print',
        '3- Making friends is easy as waving your hand back and forth in easy step ',
        'assets/images/bg3.jpg'));

    pages.add(PageModel(
        'Map',
        '4- Making friends is easy as waving your hand back and forth in easy step ',
        'assets/images/bg4.jpg'));
  }

  @override
  Widget build(BuildContext context) {
    __addPages();
    return Stack(
      children: <Widget>[
        Scaffold(
          body: PageView.builder(
            itemBuilder: (context, index) {
              print(pages.length);
              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.darken),
                        image: ExactAssetImage(
                          pages[index].image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0, -110),
                      ),
                      Text(
                        pages[index].title,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 48, right: 48, top: 15),
                        child: Text(
                          pages[index].description,
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            itemCount: pages.length,
            onPageChanged: (index) {
              _pageViewNotifier.value = index;
            },
          ),
        ),
        Transform.translate(
          offset: Offset(0, 260),
          child: Align(
            alignment: Alignment.center,
            child: _displayPageIndicators(pages.length),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25, left: 13, right: 13),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.red.shade900,
                child: Text(
                  'GET STARTED',
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      });
                      return AlertDialog(
                        backgroundColor: Colors.transparent.withOpacity(0),
                        content: LoadingIndicator(
                          indicatorType: Indicator.circleStrokeSpin,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayPageIndicators(int length) {
    return PageViewIndicator(
      pageIndexNotifier: _pageViewNotifier,
      length: length,
      normalBuilder: (animationController, index) => Circle(
        size: 8.0,
        color: Colors.white.withOpacity(0.5),
      ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
        child: Circle(
          size: 12.0,
          color: Colors.red.shade900,
        ),
      ),
    );
  }
}
