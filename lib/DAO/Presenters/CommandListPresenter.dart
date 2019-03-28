import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Models/Commande.dart';

abstract class CommandListContract {
  void onLoadingSuccess(List<Commande> commandes);
  void onLoadingError();
  void onConnectionError();
}

class CommandListPresenter {
  CommandListContract _view;
  RestDatasource api = new RestDatasource();
  CommandListPresenter(this._view);

  loadCommands() {
    api.loadCommands().then((List<Commande> commandes) {
      if (commandes != null)
        _view.onLoadingSuccess(commandes);
      else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
