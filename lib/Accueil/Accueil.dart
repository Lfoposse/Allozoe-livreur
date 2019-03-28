import 'dart:io';

import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DAO/Presenters/RestaurantsPresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../Models/Restaurant.dart';
import '../RestaurantCmdScreen.dart';
import '../Utils/AppBars.dart';
import '../Utils/Loading.dart';
import '../Utils/MyBehavior.dart';

class Accueil extends StatefulWidget {
  final List<Commande> payload;
  Accueil(this.payload);
  @override
  State<StatefulWidget> createState() => new AccueilState();
}

class AccueilState extends State<Accueil> implements RestaurantContract {
  int stateIndex;
  List<Restaurant> restaurants;
  RestaurantPresenter _presenter;
  DatabaseHelper db;
  List<Commande> commandes;
  int deliver;
  ValueNotifier<double> topOffsetLis = new ValueNotifier(0.0);
  ValueNotifier<double> bottomOffsetLis = new ValueNotifier(0.0);
  RefreshController _refreshController;
  AnimationController _headControll, _footControll;
  final key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    db = new DatabaseHelper();
    stateIndex = 0;
    restaurants = null;
    _presenter = new RestaurantPresenter(this);
    _presenter.loadRestaurants();
    // _presenter =new NotificationPresenter(this);
    // _presenter.getLivreur();
    commandes = widget.payload;
    _refreshController = new RefreshController();
    super.initState();
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadRestaurants();
    });
  }

  _openMap(double lat, double lng, String title) async {
    // Android
    String address = Uri.encodeQueryComponent(title);
    var url = 'geo:0,0?q=$title';
    if (Platform.isIOS) {
      // iOS
      url = 'maps://?address=$address';
    }
    if (await canLaunch(url)) {
      print("launching");
      await launch(url);
    } else {
      print("Could not launch");
      throw 'Could not launch $url';
    }
  }

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  void _fetch() {
    _presenter.loadRestaurantsRefresh().then((res) {
      this.restaurants = res;
      setState(() {});
      _refreshController.sendBack(false, RefreshStatus.idle);
    }).catchError(() {
      _refreshController.sendBack(false, RefreshStatus.failed);
    });
  }

  void _onOffsetCallback(bool isUp, double offset) {
    _refreshController.sendBack(false, RefreshStatus.idle);
  }

  void _onRefresh(bool up) {
    if (up)
      new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
        _refreshController.sendBack(true, RefreshStatus.completed);
      });
    else {
      new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
        _fetch();
      });
    }
  }

  Widget _headerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: "Chargement...",
      idleIcon: new Container(),
      idleText: "Rafraichir",
    );
  }

  Widget _footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: 'Chargement...',
      idleIcon: const Icon(Icons.arrow_downward),
      idleText: 'Rafraichir',
    );
  }

  @override
  Widget build(BuildContext context) {
    Container getItem(itemIndex) {
      return Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(10.0),
        // color: Colors.white,
        height: 160.0,
        child: Card(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              margin: EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //alignment: Alignment.centerLeft,
//                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                MergeSemantics(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                          child: Text(
                                              restaurants[itemIndex]
                                                  .name
                                                  .toString(),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: new TextStyle(
                                                color: Colors.black,
                                                decoration: TextDecoration.none,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    new Flexible(
                                      child: new Container(
                                        padding:
                                            new EdgeInsets.only(right: 13.0),
                                        child: new Text(
                                            restaurants[itemIndex]
                                                .address
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              decoration: TextDecoration.none,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        "(" +
                                            restaurants[itemIndex]
                                                .city
                                                .toString() +
                                            ")",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          decoration: TextDecoration.none,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                        )),
                                    GestureDetector(
                                      child: Icon(Icons.content_copy),
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: restaurants[itemIndex]
                                                .address
                                                .toString()));
                                        key.currentState
                                            .showSnackBar(new SnackBar(
                                          content: new Text("Adresse copié"),
                                        ));
                                      },
                                    ),
                                  ],
                                ),

                                StarRating(
                                  size: 25.0,
                                  rating: 0,
                                  color: Colors.orange,
                                  borderColor: Colors.grey,
                                  starCount: 5,
                                ),
                                //Icon(Icons.shopping_cart, color: Color.fromARGB(255, 255, 215, 0),size: 14.0, ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        OutlineButton(
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => RestaurantCmdScreen(
                                    restaurants[itemIndex].id)));
                          },
                          color: Colors.lightGreen,
                          borderSide: BorderSide(color: Colors.lightGreen),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Commandes",
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        OutlineButton(
                          onPressed: () {
                            _openMap(null, null,
                                this.restaurants[itemIndex].address);
                          },
                          color: Colors.lightGreen,
                          borderSide: BorderSide(color: Colors.lightGreen),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Voir Trajet",
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    }

    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return Material(
            child: Scaffold(
                key: key,
                body: Column(
                  children: <Widget>[
                    researchBox("Recherchez un restaurant", Colors.white70,
                        Colors.black54, Colors.transparent),
                    Flexible(
                        child: Container(
                            color: Colors.black12,
                            child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: new SmartRefresher(
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  headerBuilder: _headerCreate,
                                  footerBuilder: _footerCreate,
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  onOffsetChange: _onOffsetCallback,
                                  child: new ListView.builder(
                                      padding: EdgeInsets.all(0.0),
                                      scrollDirection: Axis.vertical,
                                      itemCount: restaurants.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return getItem(index);
                                      }),
                                ))))
                  ],
                )));
    }
  }

  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 2;
    });
  }

  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }

  @override
  void onLoadingSuccess(List<Restaurant> restaurants) {
    setState(() {
      this.restaurants = restaurants;
      stateIndex = 3;
    });
  }
}
