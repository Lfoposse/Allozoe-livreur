import 'dart:io';

import 'package:allozoe_livreur/DAO/Presenters/OrderDetailPresenter.dart';
import 'package:allozoe_livreur/Database/ClientPresenter.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/Produit.dart';
import 'package:allozoe_livreur/Models/StatusCommande.dart';
import 'package:allozoe_livreur/Utils/AppBars.dart';
import 'package:allozoe_livreur/Utils/Loading.dart';
import 'package:allozoe_livreur/Utils/MyBehavior.dart';
import 'package:allozoe_livreur/Utils/PriceFormated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:url_launcher/url_launcher.dart';

_openMap(String title) async {
  // Android
  print("adresse " + title.toString());
  String address = Uri.encodeQueryComponent(title);
  var url = 'geo:0,0?q=$title';
  if (Platform.isIOS) {
    // iOS
    url = 'maps://?q=$address';
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Could not launch");
    throw 'Could not launch $url';
  }
}

class DetailsCommande extends StatefulWidget {
  final Commande commande;

  const DetailsCommande({@required this.commande});

  @override
  State<StatefulWidget> createState() => new DetailsCommandeState();
}

class DetailsCommandeState extends State<DetailsCommande>
    implements OrderDetailContract {
  OrderDetailPresenter _presenter;
  ClientPresenter _presenterclient;
  List<Produit> produits;
  int stateIndex;
  int livreur;
  double PADDING_HORIZONTAL = 20.0;
  bool _isLoading = false;
  final key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    stateIndex = 0;
    produits = null;
    _presenter = new OrderDetailPresenter(this);
    _presenter.loadOrderDetails(widget.commande);
    //print("livreur id :" + _presenterclient.getClient().id.toString());
    super.initState();
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadOrderDetails(widget.commande);
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

  Widget getRecapCommandeSection() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: new ListView.builder(
          padding: EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          itemCount: produits.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return getItem(index);
          }),
    );
  }

  Widget getPricesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(3.0, horizontal: true),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  PriceFormatter.formatPrice(price: widget.commande.prix),
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        getDivider(3.0, horizontal: true)
      ],
    );
  }

  Widget getInfos(String title, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(value,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  String StatutCommande(String statut) {
    switch (statut) {
      case "PENDING":
        return "En attende";
      case "PAID":
        return "Commande Payé";
      case "SHIPPED":
        return "Commande Aprouvée";
      case "DECLINED":
        return "Commande Aprouvée";
      case "APPROUVED":
        return "Commande Aprouvée";
      default:
        return "Statut Inconnu";
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
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Détail de la commande",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              Expanded(child: getRecapCommandeSection()),
              getPricesSection(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Column(
                      children: <Widget>[
                        new GestureDetector(
                          child: getInfos(
                              "Adresse Client : ",
                              widget.commande.delivery_city.toString() +
                                  ", " +
                                  widget.commande.delivery_address.toString()),
                          onTap: () {
                            Clipboard.setData(new ClipboardData(
                                text: widget.commande.restaurant.address
                                    .toString()));
                            key.currentState.showSnackBar(new SnackBar(
                              content: new Text("Adresse copié"),
                            ));
                          },
                        ),
                        getInfos(
                            "Téléphone client : ",
                            widget.commande.delivery_phone.toString() +
                                " (" +
                                widget.commande.client.lastname.toString() +
                                ")"),
                      ],
                    ),
                  )),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        OutlineButton(
                          onPressed: () {
                            _openMap(
                                widget.commande.delivery_address.toString());
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
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
                child: Center(
                  child: PositionedTapDetector(
                      onTap: (position) {
                        setState(() {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            child: new Dialog(
                              child: new Container(
                                width: 30.0,
                                height: 40.0,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                          _presenter
                              .livrerCommande(livreur, widget.commande.id)
                              .then((bool etat) {
                            Navigator.pop(context);
                            if (etat) {
                              widget.commande.status =
                                  new StatusCommande(4, "SHIPPED");
                              _showDialog(
                                  "Commande " + widget.commande.reference,
                                  "Commande Livré");

                              setState(() {});
                            } else {
                              _showDialog(
                                  "Commande " + widget.commande.reference,
                                  "Erreur de livraison");
                            }
                            widget.commande.acceptee = etat;
                          });
                        });
                        if (widget.commande.status.id == 4) {
                          widget.commande.livree = true;
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightGreen,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: widget.commande.acceptee &&
                                    !widget.commande.livree
                                ? Colors.lightGreen
                                : Colors.black38),
                        child: Text(
                            widget.commande.livree
                                ? "Commande livrée"
                                : "Livraison effectuée ?",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: widget.commande.acceptee &&
                                      !widget.commande.livree
                                  ? Colors.white
                                  : Colors.black54,
                              decoration: TextDecoration.none,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      )),
                ),
              )
            ],
          ),
        );
    }
  }

  Widget getItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(3.0, horizontal: true),
        Container(
          height: 120.0,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Image.network(
                    produits[index].photo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(produits[index].name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                            "Quantité: " + produits[index].nbCmds.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Text(
                          PriceFormatter.formatPrice(
                              price: produits[index].prix),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),
                flex: 3,
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: key,
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
//            isLoading
//                ? Container(
//              color: Colors.black26,
//              width: double.infinity,
//              height: double.infinity,
//              child: Center(
//                child: new CircularProgressIndicator(),
//              ),
//            )
//                : IgnorePointer(ignoring: true)
          ],
        ),
      ),
    );
  }

// user defined function
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
              child: new Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
  void onApprouvedOrder(int code) {
    setState(() {
      if (code == 400) {
        _showDialog("Commande " + widget.commande.reference,
            "Cette commande a déja été accepté");
        widget.commande.acceptee = true;
      }
      _isLoading = false;
    });
  }

  @override
  void onLoadingSuccess(List<Produit> produits, int livreur1) {
    setState(() {
      stateIndex = 3;
      this.livreur = livreur1;
      this.produits = produits;
    });
  }
}

class CustomToolTip extends StatelessWidget {
  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    print("copier");
    return new GestureDetector(
      child: new Tooltip(
          preferBelow: false, message: "Copy", child: new Text(text)),
      onTap: () {
        Clipboard.setData(
            new ClipboardData(text: text)); // ignore: undefined_class
      },
    );
  }
}
