import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Produit.dart';

abstract class CommandeDetailContract {
  void onLoadingSuccess(List<Produit> produits, int livreur);
  void onLoadingError();
  void onConnectionError();
}

class CommandeDetailPresenter {
  CommandeDetailContract _view;
  RestDatasource api = new RestDatasource();
  CommandeDetailPresenter(this._view);

  loadCommandeDetailList(int restaurantID) {
    api.loadRestaurantMenus(restaurantID).then((List<Produit> produits) {
      if (produits != null) {
        new DatabaseHelper().getClient().then((List<Client> c) {
          if (c == null || c.length == 0)
            _view.onLoadingError();
          else
            _view.onLoadingSuccess(produits, c[0].id);
        });
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
