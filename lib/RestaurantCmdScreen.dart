import 'dart:io';

import 'package:allozoe_livreur/DAO/Presenters/RestaurantCmdPresenter.dart';
import 'package:allozoe_livreur/Database/ClientPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/DetailsCommande.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Utils/AppBars.dart';
import 'package:allozoe_livreur/Utils/Loading.dart';
import 'package:allozoe_livreur/Utils/MyBehavior.dart';
import 'package:allozoe_livreur/Utils/PriceFormated.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantCmdScreen extends StatefulWidget {
  final int restaurant;
  RestaurantCmdScreen(this.restaurant);

  @override
  State<StatefulWidget> createState() => new RestaurantCmdScreenState();
}

class RestaurantCmdScreenState extends State<RestaurantCmdScreen>
    implements RestaurantCmdContract {
  int stateIndex;
  List<Commande> commandes;
  RestaurantCmdPresenter _presenter;
  static ClientPresenter _presenterclient;
  DatabaseHelper db;
  int livreur;
  List<Commande> searchResultCommandes;
  bool isSearching; // determine si une recherche est en cours ou pas
  final controller = new TextEditingController();

  @override
  void initState() {
    db = new DatabaseHelper();
    db.clearNotif();
    isSearching = false;
    stateIndex = 0;
    _presenter = new RestaurantCmdPresenter(this);
    new DatabaseHelper().getClient().then((List<Client> c) {
      print("client :" + c.length.toString());
      if (c == null || c.length == 0)
        onConnectionError();
      else
        _presenter.loadRestaurantCmdList(widget.restaurant, c[0].id);
    });

    controller.addListener(() {
      print("search");
      String currentText = controller.text;
      if (currentText.length > 0) {
        setState(() {
          searchResultCommandes = new List();
          for (Commande commande in commandes) {
            // pour chaque commande
            if (commande.reference
                .toLowerCase()
                .contains(currentText.toLowerCase())) {
              searchResultCommandes.add(commande);
            }
          }
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      new DatabaseHelper().getClient().then((List<Client> c) {
        print("client :" + c.length.toString());
        if (c == null || c.length == 0)
          onConnectionError();
        else
          _presenter.loadRestaurantCmdList(widget.restaurant, c[0].id);
      });
    });
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget researchBox(
      String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: bgdColor,
          border: new Border(
            top: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            bottom: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            left: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            right: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
          )),
      child: Row(children: [
        Icon(
          Icons.search,
          color: textColor,
          size: 25.0,
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }

  Widget getItem(int index) {
    // print("livreur :" + livreur.toString());

    this.commandes[index].acceptee =
        this.commandes[index].status.name == "PENDING" ? false : true;
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getDivider(6.0, horizontal: true),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(children: <Widget>[
                    RichText(
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                              text: "Commande N° ",
                              style: new TextStyle(
                                color: Colors.blue[900],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                          new TextSpan(
                              text: (commandes[index].reference).toString(),
                              style: new TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    commandes[index].delivery_note != null
                        ? TargetWidget(note: commandes[index].delivery_note)
                        : Container()
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        StatutCommande(
                            this.commandes[index].status.name.toString()),
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                        "Total: " +
                            PriceFormatter.formatPrice(
                                price: this.commandes[index].prix),
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.none,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(this.commandes[index].date,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black54,
                            decoration: TextDecoration.none,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(this.commandes[index].heure,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black54,
                            decoration: TextDecoration.none,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            child: new Dialog(
                              child: new Container(
                                width: 30.0,
                                height: 40.0,
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                          setState(() {
                            _presenter
                                .livrerCommande(
                                    livreur, this.commandes[index].id)
                                .then((bool etat) {
                              Navigator.pop(context);
                              if (etat) {
                                _showDialog(
                                    "Commande " +
                                        this.commandes[index].reference,
                                    "Commande Livré");
                                this.commandes.remove(this.commandes[index]);
                                setState(() {});
                              } else {
                                _showDialog(
                                    "Commande " +
                                        this.commandes[index].reference,
                                    "Erreur de livraison");
                              }
                              this.commandes[index].acceptee = etat;
                            });
                          });
                        }, //DFBF00
                        color: Colors.lightGreen,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Livrée",
                              style: new TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      OutlineButton(
                        onPressed: () {
                          _openMap(null, null,
                              this.commandes[index].delivery_address);
                        },
                        color: Colors.lightGreen,
                        borderSide: BorderSide(color: Colors.lightGreen),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text

                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Voir Trajet",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      OutlineButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute(
                                  builder: (context) => DetailsCommande(
                                      commande: this.commandes[index])))
                              .then((Null) {
                            List<Commande> newList = new List();

                            for (Commande c in this.commandes) {
                              if (c.status.id != 4) {
                                newList.add(c);
                              }
                            }
                            this.commandes = newList;
                            setState(() {});
                          });
                        },
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        borderSide: BorderSide(color: Colors.lightGreen),
                        child: Column(
                          // Replace with a Row for horizontal icon + text

                          children: <Widget>[
                            Text("Details",
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String StatutCommande(String statut) {
    switch (statut) {
      case "PENDING":
        return "En attende";
      case "PAID":
        return "Commande Payé";
      case "SHIPPED":
        return "Livraison en Cours";
      case "DECLINED":
        return "Commande Décliné";
      case "APPROUVED":
        return "Commande Aprouvée";
      case "SHIPPING":
        return "Livraison en Cours";
      default:
        return "Statut Inconnu";
    }
  }

  _openMap(double lat, double lng, String title) async {
    // Android
    String address = Uri.encodeQueryComponent(title);
    var url = 'geo:0,0?q=$title';
    if (Platform.isIOS) {
      // iOS
      url = 'maps://?q=$address';
    }
    if (await canLaunch(url)) {
      print("launching");
      await launch(url);
    } else {
      print("Could not launch : "+address);
      throw 'Could not launch $url';
    }
  }

  viewLocation() {}
  Widget getAppropriateScene() {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              //getHeader(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: researchBox("Chercher ici", Color.fromARGB(15, 0, 0, 0),
                    Colors.grey, Colors.transparent),
              ),
              Expanded(
                child: isSearching
                    ? (searchResultCommandes != null &&
                            searchResultCommandes.length > 0)
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: this.searchResultCommandes.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return getItem(index);
                                  }),
                            ))
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Commande inexistante",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            ))
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              scrollDirection: Axis.vertical,
                              itemCount: this.commandes.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return getItem(index);
                              }),
                        )),
                flex: 8,
              )
            ],
          ),
        );
    }
  }

  Widget getAppropriateView() {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: researchBox(
                              "Chercher une Commande",
                              Color.fromARGB(15, 0, 0, 0),
                              Colors.grey,
                              Colors.transparent),
                        ),
                        Expanded(
                          child: isSearching
                              ? (searchResultCommandes != null &&
                                      searchResultCommandes.length > 0)
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ScrollConfiguration(
                                        behavior: MyBehavior(),
                                        child: ListView.builder(
                                            padding: EdgeInsets.all(0.0),
                                            scrollDirection: Axis.vertical,
                                            itemCount: this
                                                .searchResultCommandes
                                                .length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return getItem(index);
                                            }),
                                      ))
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "Commande inexistante",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ))
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(0.0),
                                        scrollDirection: Axis.vertical,
                                        itemCount: this.commandes.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return getItem(index);
                                        }),
                                  )),
                          flex: 8,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                HomeAppBar(
                  extraHeight: 0.0,
                ),
                Expanded(child: getAppropriateView())
              ],
            ),
            Container(
              height: AppBar().preferredSize.height+50,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
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
  void onLoadingSuccess(List<Commande> cmd, int livreur1) {
    setState(() {
      this.commandes = cmd.reversed.toList();
      this.livreur = livreur1;
      stateIndex = 3;
    });
  }
}

class TargetWidget extends StatefulWidget {
  String note;
  TargetWidget({Key key, this.note}) : super(key: key);

  @override
  _TargetWidgetState createState() => new _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  SuperTooltip tooltip;

  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip

    return true;
  }

  void onTap() {
    if (tooltip != null && tooltip.isOpen) {
      tooltip.close();
      return;
    }

    RenderBox renderBox = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    var targetGlobalCenter = renderBox
        .localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.left,
      left: 30.0,
      arrowTipDistance: 10.0,
      showCloseButton: ShowCloseButton.inside,
      closeButtonColor: Colors.red,
      borderColor: Colors.green,
      closeButtonSize: 30.0,
      hasShadow: false,
      touchThrougArea:
          new Rect.fromCircle(center: targetGlobalCenter, radius: 40.0),
      touchThroughAreaShape: ClipAreaShape.rectangle,
      content: new Material(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          widget.note,
          softWrap: true,
        ),
      )),
    );

    tooltip.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _willPopCallback,
      child: new GestureDetector(
        onTap: onTap,
        child: Container(
          width: 20.0,
          height: 20.0,
          child: Icon(Icons.info_outline, color: Colors.green),
        ),
      ),
    );
  }
}
