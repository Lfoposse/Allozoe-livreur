import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Models/Client.dart';

abstract class ConfirmContract {
  void onConfirmSuccess();
  void onConfirmError();
  void onConnectionError();
}

class ConfirmPresenter {
  ConfirmContract _view;
  RestDatasource api = new RestDatasource();
  ConfirmPresenter(this._view);

  verifyCode(String code) {
    api.login("", "", false).then((Client client) {
      if (client != null)
        _view.onConfirmSuccess();
      else
        _view.onConfirmError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
