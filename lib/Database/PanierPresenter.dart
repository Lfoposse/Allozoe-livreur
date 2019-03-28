import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Produit.dart';

abstract class PanierContract {
  void onLoadingSuccess(List<Produit> categories);
  void onLoadingError();
}

class PanierPresenter {
  PanierContract _view;
  PanierPresenter(this._view);

  loadPanier() {
    var db = new DatabaseHelper();
    db.getPanier().then((List<Produit> produits) {
      if (produits == null || produits.length == 0)
        _view.onLoadingError();
      else
        _view.onLoadingSuccess(produits);
    }).catchError((onError) {
      _view.onLoadingError();
    });
  }
}
