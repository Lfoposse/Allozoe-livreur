import 'package:allozoe_livreur/DAO/Presenters/AccountPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Utils/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class AccountScreen extends StatefulWidget {
  @override
  createState() => new AccountStateScreen();
}

class AccountStateScreen extends State<AccountScreen>
    implements AccountContract {
  bool isOnEditingMode = false;
  AccountPresenter _presenter;
  Client delivery;
  int stateIndex;
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.account();
    });
  }

  @override
  void initState() {
    super.initState();
    _presenter = new AccountPresenter(this);
    _presenter.account();
    var db = new DatabaseHelper();
    db.getClient().then((List<Client> clients) {
      delivery = clients[0];
    }).catchError((onError) {});
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Widget getAppropriateItem(String hintText) {
    if (isOnEditingMode) {
      return TextFormField(
          obscureText: false,
          autofocus: false,
          autocorrect: false,
          maxLines: 1,
          initialValue: hintText,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ));
    } else {
      return Text(hintText,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ));
    }
  }

  Expanded buildUserItem(String label, String titleText, bool show_border) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        decoration: new BoxDecoration(
            border: !show_border
                ? new Border()
                : new Border(
                    bottom: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1.0)),
            color: Colors.white),
        child: Center(
          child: Container(
            width: double
                .infinity, // remove this line in order to center the content of each element
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    )),
                Container(
                    color: isOnEditingMode
                        ? Color.fromARGB(5, 0, 0, 0)
                        : Colors.transparent,
                    margin: EdgeInsets.only(top: 10.0),
                    child: getAppropriateItem(titleText))
              ],
            ),
          ),
        ),
      ),
      flex: 1,
    );
  }

  Widget getActionButton() {
    if (isOnEditingMode) {
      return Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 15.0),
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: RaisedButton(
            onPressed: () {
              setState(() {
                isOnEditingMode = false;
              });
            },
            child: SizedBox(
              width: double.infinity,
              child: Text("Enregistrer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            textColor: Colors.white,
            color: Colors.lightGreen,
            elevation: 1.0,
          ));
    } else {
      return Expanded(
        child: Container(
          color: Colors.white,
        ),
        flex: 1,
      );
    }
  }

  Widget getAppropriateRootView(Widget child) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      body: child,
      floatingActionButton: !isOnEditingMode
          ? Container(
              margin: EdgeInsets.only(bottom: 30.0, right: 10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    isOnEditingMode = true;
                  });
                },
                mini: false,
                child: Icon(Icons.edit, size: 30.0),
              ),
            )
          : null,
    );
  }

  Widget getPageBody() {
    _presenter.account();
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'images/plat.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Color.fromARGB(30, 0, 255, 0),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  isOnEditingMode
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: PositionedTapDetector(
                              onTap: (position) {
                                // TODO: select picture in Gallery or launch camera
                              },
                              child: Icon(Icons.camera_enhance),
                            ),
                          ),
                        )
                      : new Container()
                ],
              ),
              flex: 5,
            ),
            buildUserItem("Nom", delivery.username, true),
            buildUserItem("Prénom", delivery.lastname, true),
            buildUserItem("Email", delivery.email, true),
            buildUserItem("Numéro", "", true),
            buildUserItem("Pays", "France", true),
            buildUserItem("Ville", "Paris", isOnEditingMode),
            getActionButton()
          ],
        ),
        Container(
          height: AppBar().preferredSize.height+50,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
      ],
    );
  }

  Widget getAppropriateScene() {
    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 1:
        return ShowLoadingErrorView(_onRetryClick);

      case 2:
        return ShowConnectionErrorView(_onRetryClick);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: getAppropriateRootView(getPageBody()));
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
  void onLoadingSuccess(Client client) {
    setState(() {
      delivery = client;
      print("client account " + client.username);
    });
  }
}
