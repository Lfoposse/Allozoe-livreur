import 'dart:async';

import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:intl/intl.dart';

class MyNavigationAppBar extends StatelessWidget {
  MyNavigationAppBar(this.title);

  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        margin: EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ));
  }
}

class HomeAppBar extends StatefulWidget {
  final double extraHeight;
  HomeAppBar({@required this.extraHeight});

  @override
  createState() => new HomeAppBarState();
}

class HomeAppBarState extends State<HomeAppBar> {
  // Fields in a Widget subclass are always marked "final".
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _statusBarHeight = 0.0;
  VoidCallback _showPersBottomSheetCallBack;
  Future<void> initPlatformState() async {
    double statusBarHeight;
    statusBarHeight = await FlutterStatusbarManager.getHeight;
    setState(() {
      _statusBarHeight = statusBarHeight;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _showPersBottomSheetCallBack = _showBottomSheet;
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            color: Colors.greenAccent,
            child: new Center(
              child: new Text("Hi ModalSheet"),
            ),
          );
        });
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return new Container(
              color: Colors.greenAccent,
              child: new Center(
                child: new Text("yes i can"),
              ));
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      color: Colors.grey,
      child: Container(
          height: 60.0 + widget.extraHeight, // in logical pixels
          margin: EdgeInsets.only(
              top: _statusBarHeight == 0 ? 40.0 : _statusBarHeight),
          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              'images/logo-header.png',
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}

Widget researchBox(
    String hintText, Color bgdColor, Color textColor, Color borderColor) {
  return Container(
    padding: EdgeInsets.only(left: 20.0, right: 20.0),
    decoration: new BoxDecoration(
        color: bgdColor,
        border: new Border(
          top: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          bottom: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.0),
          left: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
          right: BorderSide(
              color: borderColor, style: BorderStyle.solid, width: 1.5),
        )),
    child: Row(children: [
      Icon(Icons.search, color: textColor),
      Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextFormField(
                  autofocus: false,
                  autocorrect: false,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: textColor)),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ))))
    ]),
  );
}

class TimeContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TimeContainerState();
  }
}

class TimeContainerState extends State<TimeContainer>
    with SingleTickerProviderStateMixin {
  int tabIndex;
  TabController controller;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  TimeOfDay timeStart, timeEnd, resetValue;

  @override
  void initState() {
    tabIndex = 0;
    resetValue = TimeOfDay.fromDateTime(DateTime.now());
    timeEnd = null;
    timeEnd = null;
    //var mapUtil = new MapUtil();
    //mapUtil.init(context);

    // print(mapUtil.getMyLocation());
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //brightness:Brightness.dark,
          leading: Container(),
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                tabs: [
                  new Tab(
                      child: Text(
                    "Aujourd'hui",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  )),
                  new Tab(
                      child: Text(
                    "Demain",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ],
          ),
        ),
        body: new TabBarView(controller: controller, children: <Widget>[
          new Screen1(),
          new Screen2(),
        ]),
      ),
    );

    /*return new Container(

        color: Colors.white,
        child: new Column(
            children:<Widget>[
              Row(
                children: <Widget>[
                  tabItem(0,"Aujourd'hui"),
                  tabItem(1,"Demain"),
                ],
              ),
              Expanded(child: Container(
                  child: Center(
                    child: Container(
                      child: ListView(
                        children: <Widget>[
                          TimePickerFormField(
                            textAlign: TextAlign.center,
                            format: timeFormat,
                            initialValue: resetValue,
                            decoration: InputDecoration(labelText: 'Begin Time'),
                            onChanged: (dt) => setState(() => timeStart = dt),
                          ),
                          SizedBox(height: 16.0),
                          TimePickerFormField(
                            textAlign: TextAlign.center,
                            format: timeFormat,
                            decoration: InputDecoration(labelText: ' End Time'),
                            onChanged: (t) => setState(() => timeEnd = t),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  )
              ),flex: 5,),
              Expanded(child:Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
                color: Colors.greenAccent,
                child: RaisedButton(
                  elevation: 0.0,
                  color: Colors.transparent,
                  onPressed: (){
                    setState(() {


                    });
                  },
                  child:  Text("Confirmer l'horaire de livraison",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ),),
                ),
              ),
              flex: 2,)
            ]
        )
    );*/
  }

  Widget tabItem(int index, String title) {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              elevation: 0.0,
              color: Colors.transparent,
              onPressed: () {
                setState(() {
                  tabIndex = index;
                  resetValue = null;
                  print(resetValue);
                  // timeStart=null;
                });
              },
              child: Text(title),
            ),
            tabIndex == index
                ? Container(
                    height: 2.0,
                    color: Colors.lightGreen,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class LocationContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LocationContainerState();
  }
}

class LocationContainerState extends State<LocationContainer> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: new Column(children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Adresse de livraison",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Expanded(
            child: Container(
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                // margin: EdgeInsets.only(left:10.0),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Colors.transparent,
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(
                    "Livrer ailleurs",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              //margin: EdgeInsets.only(left:10.0),
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.transparent,
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  "Me faire livrer ou je me trouve actuellement",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            flex: 1,
          )
        ]));
  }
}

class Screen1 extends StatelessWidget {
  int tabIndex;
  TabController controller;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  TimeOfDay timeStart, timeEnd, resetValue;

  @override
  void initState() {
    tabIndex = 0;
    resetValue = TimeOfDay.fromDateTime(DateTime.now());
    timeEnd = null;
    timeEnd = null;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        // 1

        color: Colors.white,
        child: new Column(children: <Widget>[
          Expanded(
            child: Container(
                child: Center(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    TimePickerFormField(
                      textAlign: TextAlign.center,
                      format: timeFormat,
                      initialValue: resetValue,
                      decoration: InputDecoration(labelText: 'Begin Time'),
                      //onChanged: (dt) => setState(() => timeStart = dt),
                    ),
                    SizedBox(height: 16.0),
                    TimePickerFormField(
                      textAlign: TextAlign.center,
                      format: timeFormat,
                      decoration: InputDecoration(labelText: ' End Time'),
                      //onChanged: (t) => setState(() => timeEnd = t),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            )),
            flex: 5,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(20.0),
              color: Colors.greenAccent,
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.transparent,
                child: Text(
                  "Confirmer l'horaire de livraison",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
            flex: 2,
          )
        ]));
  }
}

class Screen2 extends StatelessWidget {
  int tabIndex;
  TabController controller;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  TimeOfDay timeStart, timeEnd, resetValue;

  @override
  void initState() {
    tabIndex = 0;
    resetValue = TimeOfDay.fromDateTime(DateTime.now());
    timeEnd = null;
    timeEnd = null;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        // 1

        color: Colors.white,
        child: new Column(children: <Widget>[
          Expanded(
            child: Container(
                child: Center(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    TimePickerFormField(
                      textAlign: TextAlign.center,
                      format: timeFormat,
                      initialValue: resetValue,
                      decoration: InputDecoration(labelText: 'Begin Time'),
                      //onChanged: (dt) => setState(() => timeStart = dt),
                    ),
                    SizedBox(height: 16.0),
                    TimePickerFormField(
                      textAlign: TextAlign.center,
                      format: timeFormat,
                      decoration: InputDecoration(labelText: ' End Time'),
                      //onChanged: (t) => setState(() => timeEnd = t),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            )),
            flex: 5,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(20.0),
              color: Colors.greenAccent,
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.transparent,
                child: Text(
                  "Confirmer l'horaire de livraison",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
            flex: 2,
          )
        ]));
  }
}
