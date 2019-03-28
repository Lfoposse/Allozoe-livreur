import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Utils/Config.dart';

abstract class CmdLivreurContract {
  void onLoadingSuccess(List<Commande> commandes, int livreur);
  void onLoadingError();
  void onConnectionError();
}

class CmdLivreurPresenter {
  CmdLivreurContract _view;
  RestDatasource api = new RestDatasource();
  CmdLivreurPresenter(this._view);

  loadCmdLivreurList() {
    new DatabaseHelper().getClient().then((List<Client> c) {
      print("client :" + c.length.toString());
      if (c != null || c.length > 0) {
        api
            .loadCmdLivreur(c[0].id, Config.SHIPPED, 1, 100)
            .then((List<Commande> commande) {
          print("commande livreur :" + commande.toString());
          if (commande != null)
            _view.onLoadingSuccess(commande, c[0].id);
          else
            _view.onLoadingError();
        }).catchError((onError) {
          _view.onConnectionError();
        });
      } else {
        _view.onConnectionError();
      }
    });
  }

  Future<List<Commande>> loadCmdLivreurListByPage(
      int livreur, int page, int limit) {
    return api
        .loadCmdLivreur(livreur, Config.SHIPPED, page, 100)
        .then((List<Commande> commande) {
      return commande;
    }).catchError((onError) {
      //_view.onConnectionError();
    });
  }
}
