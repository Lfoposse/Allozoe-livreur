import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/ClientPresenter.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';

abstract class LoginContract {
  void onLoginSuccess(Client client);
  void onLoginError();
  void onUserAlreadyLoggedIn();
  void onConnectionError();
}

class LoginPresenter {
  ClientPresenter _presenter;
  LoginContract _view;
  RestDatasource api = new RestDatasource();
  LoginPresenter(this._view);

  doLogin(String username, String password, bool checkAccountExists) {
    api.login(username, password, checkAccountExists).then((Client client) {

      switch(client.code) {
        case 200:
          new DatabaseHelper().addClient(client);
          _view.onLoginSuccess(client);
          break;
        case 4008:
          _view.onLoginError();
          break;
        case 4024:
          _view.onUserAlreadyLoggedIn();
          break;

      }
      /*
      if (client != null) {
        new DatabaseHelper().addClient(client);
        _view.onLoginSuccess(client);
      } else {
        switch(client.code) {
          case 4008:
            _view.onLoginError();
            break;
          case 4024:
            _view.onUserAlreadyLoggedIn();
            break;

        }
      } */
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
