import '../Models/StatusCommande.dart';

/**
 * Les statuts en paramètre sont des entiers
    1: PENDING    Commande enregistree
    2: APPROVED   Commande approuvee par le restaurant
    3: DECLINED   Commande rejetee par le restaurant
    4: SHIPPED    Commande livree
    5: PAID       Commande payee
    6: SHIPPING   En cours de livraison
    7: PREPARING  En cours de preparation
 */
class Config {
  static final PENDING = 1;
  static final APPROVED = 2;
  static final DECLINED = 3;
  static final SHIPPED = 4;
  static final PAID = 5;
  static final SHIPPING = 6;
  static final PREPARING = 7;

  String getStatusCommandValue(StatusCommande statusCommande) {
    switch (statusCommande.id) {
      case 1:
        return "Enregistrée";
      case 2:
        return "Approuvée";
      case 3:
        return "Rejetée";
      case 4:
        return "Livrée";
      case 5:
        return "Payée";
      case 6:
        return "Livraison en cours";
      case 7:
        return "Préparation en cours";
      default:
        return "Inconnue";
    }
  }
}
