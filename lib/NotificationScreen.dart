import 'dart:async';

import 'package:allozoe_livreur/DAO/Presenters/NotificationPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/DetailsCommande.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/Restaurant.dart';
import 'package:allozoe_livreur/RestaurantCmdScreen.dart';
import 'package:allozoe_livreur/Utils/MyBehavior.dart';
import 'package:allozoe_livreur/Utils/NotificationProgress.dart';
import 'package:allozoe_livreur/Utils/PriceFormated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationScreen extends StatefulWidget {
  final List<Commande> payload;
  final int livreur;
  NotificationScreen(this.payload, this.livreur);
  @override
  State<StatefulWidget> createState() => new NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen>
    implements NotificationContract {
  Restaurant restaurants;
  List<Commande> commandes;
  NotificationPresenter _presenter;
  int deliver;
  int commandeLenght = 0;
  Timer _timer;
  bool disposed;
  final key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _timer = new Timer(const Duration(seconds: 60), () {
      if (disposed) return;
      int size = 0;
      for (var c in commandes) {
        _presenter.refuserCommande(deliver, c.id).then((bool etat) {
          print("commande refuser etat:" + etat.toString());

          size++;
          if (size == commandes.length) new DatabaseHelper().clearNotif();
        });
      }
      Navigator.pop(context);
    });

    _presenter = new NotificationPresenter(this);
    _presenter.getLivreur();
    commandes = widget.payload;
    deliver = widget.livreur;
    commandeLenght = widget.payload.length;
    disposed = false;
  }

  @override
  void dispose() {
    disposed = true;
    _timer.cancel();

    int size = 0;
    for (var c in commandes) {
      _presenter.refuserCommande(deliver, c.id).then((bool etat) {
        print("commande refuser etat:" + etat.toString());

        size++;
        if (size == commandes.length) new DatabaseHelper().clearNotif();
      });
    }
    super.dispose();
  }

  Widget getItem(int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //getDivider(1.0, horizontal: true),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                            text: "Référence: ",
                            style: new TextStyle(
                              color: Colors.blue[900],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        new TextSpan(
                            text: this.commandes[index].reference,
                            style: new TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
//                      new Flexible(
//                          child:
                  Text(this.commandes[index].restaurant.name,
                              textAlign: TextAlign.left,
//                              softWrap: true,
//                              overflow: TextOverflow.ellipsis,
//                              maxLines: 1,
                              style: new TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.none,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              )),
//                      ),
                      new Flexible(
                        child: new Container(
                          padding: new EdgeInsets.only(right: 13.0),
                          child: new Text(
                              "(" +
                                  this.commandes[index].restaurant.address +
                                  ")",
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.none,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      new GestureDetector(
                        child: Icon(Icons.content_copy),
                        onTap: () {
                          Clipboard.setData(new ClipboardData(
                              text: this
                                  .commandes[index]
                                  .restaurant
                                  .address
                                  .toString()));
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("Adresse copié"),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text("Client: ",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: Colors.black54,
                                  decoration: TextDecoration.none,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.normal,
                                )),
                            Text(this.commandes[index].delivery_address,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: new TextStyle(
                                  color: Colors.black54,
                                  decoration: TextDecoration.none,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            _presenter
                                .accepterCommande(
                                    deliver, this.commandes[index].id)
                                .then((bool etat) {
                              Navigator.of(context)
                                  .pop(); // ferme la boite d'attente

                              if (etat) {
                                this.commandes[index].acceptee = true;
                                print("Commande accepté: statut" +
                                    this.commandes[index].acceptee.toString());

                                //
                                if (this.commandeLenght == 1) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) => DetailsCommande(
                                              commande:
                                                  this.commandes[index])));
                                } else {
                                  if (this.commandes.length > 1) {
                                    this
                                        .commandes
                                        .remove(this.commandes[index]);
                                    setState(() {});
                                  } else {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .push(new MaterialPageRoute(
                                            builder: (context) =>
                                                RestaurantCmdScreen(this
                                                    .commandes[index]
                                                    .restaurant
                                                    .id)))
                                        .then((Null) {
                                      // Navigator.of(context).pop();
                                    });
                                  }

                                  /*Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (context) => DetailsCommande(
                                          commande: this.commandes[index])));*/
                                }
                                // this.commandes.remove(this.commandes[index]);
                              } else {
                                //this.commandes.remove(this.commandes[index]);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: new Text("Alerte"),
                                      content: new Text(
                                          "Désolé cette commande a déja été accepté par un autre livreur"),
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
                                // print("commande a pb ::" +this.commandes[index].restaurant.id.toString());
                                // Navigator.of(context).pop();
                              }
                              setState(() {
                                //this.commandes.remove(this.commandes[index]);
                                // this.commandes[index].acceptee=false;
                              });
                            });
                            setState(() {
                              //this.commandes.remove(this.commandes[index]);
                            });
                            if (this.commandes.length <= 0 &&
                                this.commandeLenght != 1) {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => RestaurantCmdScreen(
                                      this.commandes[index].restaurant.id)));
                            }
                          }, //DFBF00
                          color: this.commandes[index].acceptee
                              ? Colors.black12
                              : Colors.lightGreen,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              this.commandes[index].acceptee
                                  ? Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Text(
                                      "Accepter",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      )
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

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Future<bool> _exitApp(BuildContext context) {
    print("bye bye");
    for (var c in commandes) {
      _presenter.refuserCommande(deliver, c.id).then((bool etat) {
        print("commande refuser etat:" + etat.toString());
      });
    }
    new DatabaseHelper().clearNotif();
    Navigator.pop(context);
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("nouvelle commande :" + commandes.toString());
    return new WillPopScope(
        onWillPop: () => _exitApp(context),
        child: new Material(
            type: MaterialType.transparency,
            child: Scaffold(
                key: key,
                backgroundColor: Colors.transparent,
                body: Container(
                    height: double.infinity,
                    margin: EdgeInsets.all(10.0),
                    //color: Colors.white,

                    child: new Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.bottomCenter,
                              height: 20.0,
                              color: Colors.white,
                            ),
                            Container(
                              child: new NotificationProgress(commandes[0]),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: new ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      commandes == null ? 0 : commandes.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return getItem(index);
                                  }),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    )))));
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
          Text(title + ": " + value,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void onConnectionError() {
    // TODO: implement onConnectionError
  }

  @override
  void onLoadingError() {
    // TODO: implement onLoadingError
  }

  @override
  void onLoadingSuccess(int livreur) {
    setState(() {
      this.deliver = livreur;
    });
  }
}
