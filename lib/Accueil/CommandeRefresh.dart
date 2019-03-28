import 'package:allozoe_livreur/DAO/Presenters/CommandeLivreurPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Utils/Loading.dart';
import 'package:allozoe_livreur/Utils/MyBehavior.dart';
import 'package:allozoe_livreur/Utils/PriceFormated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CommandeRefresh extends StatefulWidget {
  CommandeRefresh();
  @override
  State<StatefulWidget> createState() => new CommandeRefreshState();
}

class CommandeRefreshState extends State<CommandeRefresh>
    implements CmdLivreurContract {
  int stateIndex;
  List<Commande> commandes;
  CmdLivreurPresenter _presenter;
  DatabaseHelper db;
  int livreur;
  List searchResultCommandes;
  bool isSearching; // determine si une recherche est en cours ou pas
  final controller = new TextEditingController();
  int indexPage = 2;
  RefreshController _refreshController;
  SuperTooltip tooltip;
  String note = "";
  double notePositionLeft, notePositionTop = 0.0;
  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  Future<bool> _willPopCallback() async {
    if (tooltip.isOpen) {
      tooltip.close();
      return false;
    }
    return true;
  }

  notePopup() {
    if (tooltip != null && tooltip.isOpen) {
      tooltip.close();
      return;
    }
    notePositionLeft = 30.0;
    notePositionTop = 300;

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.left,
      content: new Material(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          note,
          softWrap: true,
        ),
      )),
    );

    tooltip.show(context);
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
    //_refreshController.sendBack(false, RefreshStatus.completed);
  }

  @override
  void initState() {
    _refreshController = new RefreshController();
    db = new DatabaseHelper();
    stateIndex = 0;
    isSearching = false;
    _presenter = new CmdLivreurPresenter(this);
    _presenter.loadCmdLivreurList();
    controller.addListener(() {
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

  Widget _headerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: "Chargement...",
      idleIcon: new Container(),
      idleText: "Voir plus ...",
    );
  }

  Widget _footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: 'Chargement...',
      idleIcon: const Icon(Icons.arrow_downward),
      idleText: 'Voir plus ...',
    );
  }

  void _fetch() {
    _presenter.loadCmdLivreurListByPage(livreur, indexPage, 5).then((res) {
      for (var item in res) {
        commandes.add(item);
      }
      setState(() {
        _refreshController.sendBack(false, RefreshStatus.idle);
      });

      indexPage++;
    }).catchError(() {
      _refreshController.sendBack(false, RefreshStatus.failed);
    });
  }

  void _onRefresh(bool up) {
    if (up)
      new Future.delayed(const Duration(seconds: 3)).then((val) {
        _fetch();
        _refreshController.sendBack(true, RefreshStatus.completed);
      });
    else {
      new Future.delayed(const Duration(seconds: 6)).then((val) {
        _fetch();
        _refreshController.sendBack(true, RefreshStatus.completed);
      });
    }
  }

  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadCmdLivreurList();
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

  String _value = new DateTime.now().toString().substring(0, 11);
  int cliked = 0;

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019));
    if (picked != null)
      setState(() => _value = picked.toString().substring(0, 11));
  }

  Widget getDatedBox() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 0;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.only(right: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: cliked == 0 ? Colors.lightGreen : Colors.grey,
                    width: 2.0),
              ),
              child: Center(
                child: Text("Semaine"),
              ),
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 1;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: cliked == 1 ? Colors.lightGreen : Colors.grey,
                      width: 2.0)),
              child: Center(
                child: Text("Mois"),
              ),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              setState(() {
                cliked = 2;
              });

              // Todo : traiter l'action ensuite
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0),
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: cliked == 2 ? Colors.lightGreen : Colors.grey,
                      width: 2.0)),
              child: Center(
                child: Text("Année"),
              ),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: PositionedTapDetector(
            onTap: (position) {
              _selectDate();
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              height: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: cliked == 3 ? Colors.lightGreen : Colors.grey,
                      width: 2.0)),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      size: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(_value),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
          flex: 6,
        ),
      ],
    );
  }

  Widget getItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getDivider(4.0, horizontal: true),
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
            Text(StatutCommande(commandes[index].status.name.toString()),
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
                      price: commandes[index].prix,
                    ),
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
              Text(commandes[index].date,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  )),
              StarRating(
                size: 25.0,
                rating: commandes[index].delivery_stars.toDouble(),
                color: Colors.orange,
                borderColor: Colors.grey,
                starCount: 5,
              ),
              Text(commandes[index].heure.toString(),
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        )
      ],
    );
  }

  String StatutCommande(String statut) {
    switch (statut) {
      case "PENDING":
        return "En Attende";
      case "PAID":
        return "Commande Payé";
      case "SHIPPED":
        return "Livraison Effectué";
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

  @override
  Widget build(BuildContext context) {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return new Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            color: Color.fromARGB(25, 0, 0, 0),
            child: new Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  /*Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: getDatedBox(),
                    ),
                    flex: 1,
                  ),*/
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: researchBox(
                        "Rechercher une commande",
                        Color.fromARGB(15, 0, 0, 0),
                        Colors.grey,
                        Colors.transparent),
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
                                      itemCount:
                                          this.searchResultCommandes.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
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
                        : new Container(
                            height: 200.0,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: new Container(
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
                                          reverse: true,
                                          //itemExtent: 100.0,
                                          itemCount: commandes.length,
                                          itemBuilder: (context, index) =>
                                              getItem(index),
                                        ))))),
                    flex: 8,
                  )
                ],
              ),
            ));
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
  void onLoadingSuccess(List<Commande> commandes, int deliver) {
    setState(() {
      this.livreur = deliver;
      this.commandes = commandes.reversed.toList();
      // print("liste des commandes ---->" + this.commandes.toString());
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
    if (tooltip.isOpen) {
      tooltip.close();
      return false;
    }
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
