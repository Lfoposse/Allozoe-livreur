import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Models/Commande.dart';

class PositionLivreurPresenter {
  RestDatasource api = new RestDatasource();

  UpdatePosition(int order, double laltitude, double longitude) {
    api.updatePositionLivreur(order, laltitude, longitude).then((bool code) {
      if (code == true)
        print("update position");
      else
        print("Error update position");
    }).catchError((onError) {
      print("Exception" + onError.toString());
    });
  }

  Future<List<Commande>> checkCommande(int livreur) {
    return api.checkCommande(livreur).then((List<Commande> commande) {
      print("commande livreur :" + commande.toString());
      if (commande != null)
        return commande;
      else
        return null;
    }).catchError((onError) {
      print("Une erreur est survenue");
    });
  }
}
