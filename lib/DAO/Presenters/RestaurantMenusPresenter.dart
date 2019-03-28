import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Models/Produit.dart';

abstract class RestaurantMenusContract {
  void onLoadingSuccess(List<Produit> produits);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantMenusPresenter {
  RestaurantMenusContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantMenusPresenter(this._view);

  loadRestaurantMenusList(int restaurantID) {
    api.loadRestaurantMenus(restaurantID).then((List<Produit> produits) {
      if (produits != null)
        _view.onLoadingSuccess(produits);
      else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
