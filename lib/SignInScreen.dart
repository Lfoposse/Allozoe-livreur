import 'package:allozoe_livreur/DAO/Presenters/LoginPresenter.dart';
import 'package:allozoe_livreur/HomeScreen.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Utils/AppBars.dart';
import 'package:allozoe_livreur/Utils/AppSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class SignInScreen extends StatefulWidget {
  @override
  createState() => new SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> implements LoginContract {
  bool _isLoading = false;
  bool _showError = false;
  bool hide_content = true;
  String _errorMsg;
  static const double padding_from_screen = 30.0;

  final emailKey = new GlobalKey<FormState>();
  final passKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _email;

  LoginPresenter _presenter;

  SignInScreenState() {
    _presenter = new LoginPresenter(this);
  }

  void _submit() {
    emailKey.currentState.save();
    passKey.currentState.save();

    if (_email.length == 0 || _password.length == 0) {
      setState(() {
        _errorMsg = "Renseigner vos identifiants";
        _showError = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(_email)) {
        setState(() {
          _errorMsg = "Email invalide";
          _showError = true;
        });
      } else {
        setState(() {
          _isLoading = true;
          _showError = false;
        });
        _presenter.doLogin(_email, _password, false);
      }
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Widget showError() {
    return _showError
        ? Container(
      margin: EdgeInsets.only(
          left: padding_from_screen, right: padding_from_screen),
      child: Center(
        child: Text(
          _errorMsg,
          style: TextStyle(
              color: Colors.red,
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    void _update_state() {
      setState(() {
        hide_content = !hide_content;
      });
    }

    Container buildEntrieRow(IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType, bool hide_content) {
      Color color = Colors.black;
      return Container(
        decoration:
        new BoxDecoration(border: new Border.all(color: color, width: 2.0)),
        padding:
        EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(
            top: 40.0, left: padding_from_screen, right: padding_from_screen),
        child: new Form(
            key: emailKey,
            child: Row(
              children: [
                Icon(
                  startIcon,
                  color: color,
                  size: 30.0,
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                            onSaved: (val) => _email = val,
                            obscureText: hide_content,
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            keyboardType: inputType,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: hintText,
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Icon(endIcon, color: color),
              ],
            )),
      );
    }

    Container buildPassEntry(String hintText) {
      Color color = Colors.black;
      return Container(
        decoration:
        new BoxDecoration(border: new Border.all(color: color, width: 2.0)),
        padding:
        EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 30.0,
            bottom: 10.0),
        child: Form(
          key: passKey,
          child: Row(
            children: [
              PositionedTapDetector(
                onTap: (position) {
                  _update_state();
                },
                child: Icon(
                  hide_content ? Icons.visibility_off : Icons.visibility,
                  color: color,
                  size: 30.0,
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextFormField(
                          onSaved: (val) => _password = val,
                          obscureText: hide_content,
                          autofocus: false,
                          autocorrect: false,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintText,
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )))),
            ],
          ),
        ),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 40.0,
            bottom: 15.0),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          onPressed: _submit,
          child: SizedBox(
            width: double.infinity,
            child: Text("CONNEXION",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Color.fromARGB(255, 126, 186, 11),
          elevation: 1.0,
        ));

    return Material(
      child: Scaffold(
          key: scaffoldKey,
          body: Column(
            children: <Widget>[
              HomeAppBar(extraHeight: 40.0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Connexion au compte",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          buildEntrieRow(Icons.mail_outline, null, "Email",
                              TextInputType.emailAddress, false),
                          buildPassEntry("Mot de passe"),
                          showError(),
                          _isLoading
                              ? Container(
                            padding: const EdgeInsets.only(
                                left: padding_from_screen,
                                right: padding_from_screen,
                                top: 30.0,
                                bottom: 15.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : buttonSection,
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void onLoginError() {
    setState(() {
      _isLoading = false;
      _errorMsg = "Email ou mot de passe erroné";
      _showError = true;
    });
  }

  @override
  void onUserAlreadyLoggedIn() {
    setState(() {
      _isLoading = false;
      _errorMsg = "Compte actif. Veuillez vous déconnecter";
      _showError = true;
    });
  }

  @override
  void onLoginSuccess(Client client) async {
    setState(() => _isLoading = false);
    if (true) {
      // si le compte est active
      // new DatabaseHelper().listTable();
      AppSharedPreferences()
          .setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => HomeScreen(0)),
          ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  @override
  void onConnectionError() {
    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }
}
