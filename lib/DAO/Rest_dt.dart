import 'dart:async';

import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Commande.dart';
import 'package:allozoe_livreur/Models/Note.dart';
import 'package:allozoe_livreur/Models/Produit.dart';
import 'package:allozoe_livreur/Models/Restaurant.dart';
import 'package:allozoe_livreur/Models/StatusCommande.dart';

import 'NetworkUtil.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://allozoe.fr";
  static final LOGIN_URL = BASE_URL + "/auth/login";
  static final LOAD_CATEGORIE_LIST_URL = BASE_URL + "/api/categories/";
  static final LOAD_ALL_MENUS_LIST_URL = BASE_URL + "/api/menus/";
  static final LOAD_RESTAURANT_LIST_URL = BASE_URL + "/api/restaurants/";
  static final COMMANDS_URL = BASE_URL + "/api/orders/";
  static final DELIVER_URL = BASE_URL + "/api/delivers/";

  ///retourne les informations d'un compte client a partir de ses identifiants
  Future<Client> login(String username, String password,
      bool checkAccountExists) {
    return _netUtil.post(LOGIN_URL,
        body: {"login": username, "pass": password}).then((dynamic res) {
      print("LOGIN_REQUEST   " + res.toString());
      if (res["code"] == 200 &&
          (res["data"]["role"][0].toString() == "ROLE_DELIVER"))
        return Client.map(res["code"], res["data"]);
      else
        return Client.empty(res["code"]);
      /*else
        return null; */
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Notifie le serveur que le livreur est déconnecté
  Future<bool> logout(int livreur) {
    return _netUtil.post(DELIVER_URL + livreur.toString() + "/deconnexion",
        body: {"id": "9"}).then((dynamic res) {
      print(res.toString());
      if (res["code"] == 200) {
        print(" you are deconnected bye bye");
        return true;
      } else {
        return false;
      }
    }).catchError((onError) => print("errrrrrrrrror"));
  }

  ///retourne les informations d'un compte client a partir de ses identifiants
  Future<Note> getDeliver(int livreur) {
    return _netUtil.get(DELIVER_URL + livreur.toString()).then((dynamic res) {
      if (res["code"] == 4008)
        return Note.empty();
      else if (res["code"] == 200)
        return Note.map(res["data"]["note"]);
      else
        return null;
    }).catchError((onError) => print("errrrrrrrrror"));
  }

  ///Retourne la liste des produits d'une categorie precise
  Future<List<Produit>> loadCategorieMenus(int categorieID) {
    return _netUtil
        .get(LOAD_CATEGORIE_LIST_URL + categorieID.toString() + "/menus")
        .then((dynamic res) {
      // print(res.toString());
      if (res["code"] == 200)
        return (res['items'] as List)
            .map((item) => new Produit.map(item))
            .toList();
      else
        return null as List<Produit>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste des restaurants
  Future<List<Restaurant>> loadRestaurants(int livreur) {
    return _netUtil
        .get(DELIVER_URL +
        livreur.toString() +
        "/orders?status=6&limit=100&page=1")
        .then((dynamic res) {
      if (res["code"] == 200) {
        var items = new List<Restaurant>();
        Restaurant item;
        var qte = new List<int>();
        List<Commande> cmd = (res['items'] as List)
            .map((item) => new Commande.map(item))
            .toList();
        for (var c in cmd) {
          item = new Restaurant(
              c.restaurant.id,
              c.restaurant.name,
              c.restaurant.photo,
              c.restaurant.city,
              c.restaurant.address,
              c.restaurant.latitude,
              c.restaurant.longitude,
              c.restaurant.note);
          if (qte.length >= 0 && !qte.contains(c.restaurant.id)) {
            items.add(item);
            qte.add(c.restaurant.id);
          }
        }
        //  print(qte.toString());
        return items;
      } else {
        return null as List<Restaurant>;
      }
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste des restaurants appartenant a une categorie precise
  Future<List<Restaurant>> loadCategorieRestaurants(int categorieID) {
    return _netUtil
        .get(LOAD_CATEGORIE_LIST_URL + categorieID.toString() + "/restaurants")
        .then((dynamic res) {
      // print(res.toString());
      if (res["code"] == 200)
        return (res['items'] as List)
            .map((item) => new Restaurant.map(item))
            .toList();
      else
        return null as List<Restaurant>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste des produits d'un restaurant precis
  Future<List<Produit>> loadRestaurantMenus(int restaurantID) {
    return _netUtil
        .get(LOAD_RESTAURANT_LIST_URL + restaurantID.toString() + "/menus")
        .then((dynamic res) {
      // print(res.toString());
      if (res["code"] == 200)
        return (res['items'] as List)
            .map((item) => new Produit.map(item))
            .toList();
      else
        return null as List<Produit>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste de toutes les commandes
  Future<List<Commande>> loadCommands() {
    return _netUtil.get(COMMANDS_URL).then((dynamic res) {
      if (res["code"] == 200 && res['items'] != null)
        return (res['items'] as List)
            .map((item) => new Commande.map(item))
            .toList();
      else
        return null as List<Commande>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste de toutes les commandes d'un restaurant
  Future<List<Commande>> loadCommandsRestaurant(int idRestaurant, livreur) {
    return _netUtil
        .get(DELIVER_URL +
        livreur.toString() +
        "/orders?status=6&restaurant=" +
        idRestaurant.toString())
        .then((dynamic res) {
      if (res["code"] == 200 && res['items'] != null) {
        // print("id restaurant :" + idRestaurant.toString());
        var items = new List<Commande>();

        List<Commande> cmd = (res['items'] as List)
            .map((item) => new Commande.map(item))
            .toList();
        for (var c in cmd) {
          if (c.status.name.toString() != "PAID" &&
              c.status.name.toString() != "APPROVED" &&
              c.status.name.toString() != "DECLINED") {
            items.add(c);
          }
        }
        return items;
      } else
        return null as List<Commande>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste de toutes les commandes effectué par un livreur
  Future<List<Commande>> loadCmdLivreur(int livreur, int status, int page,
      int limit) {
    return _netUtil
        .get(DELIVER_URL +
        livreur.toString() +
        "/orders?status=" +
        status.toString() +
        "&limit=" +
        limit.toString() +
        "&page=" +
        page.toString())
        .then((dynamic res) {
      if (res["code"] == 200 && res['items'] != null) {
        print("commandeLivreur :" + res['items'].toString());
        return (res['items'] as List)
            .map((item) => new Commande.map(item))
            .toList();
      } else {
        return null as List<Commande>;
      }
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  Future<List<Produit>> loadOrderDetails(Commande commande) {
    return _netUtil
        .get(COMMANDS_URL + commande.id.toString())
        .then((dynamic res) {
      if (res["code"] == 200) {
        commande.client = Client.map(200, res["data"]["client"]);
        commande.status = StatusCommande.map(res["data"]["status"]);
        commande.restaurant = Restaurant.map(res["data"]["restaurant"]);
        return (res["data"]['menus'] as List)
            .map((item) => new Produit.map(item))
            .toList();
      } else
        return null as List<Produit>;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  /// Accepter commande

  Future<bool> accepterCommande(int deliver, int order) {
    return _netUtil
        .put(DELIVER_URL +
        deliver.toString() +
        "/orders/" +
        order.toString() +
        "/approved")
        .then((dynamic res) {
      if (res["code"] == 200) {
        return true;
      } else
        return false;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  /// mise à jour de la position d'un client par rapport à une  commande

  Future<bool> updatePositionLivreur(int order, double laltitude,
      double longitude) {
    return _netUtil
        .put(DELIVER_URL +
        order.toString() +
        "/position?latitude=" +
        laltitude.toString() +
        "&longitude=" +
        longitude.toString())
        .then((dynamic res) {
      if (res["code"] == 200) {
        print("position mis à jour :" + res["code"].toString());
        return true;
      } else
        return false;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ///Retourne la liste des nouvelles commandes
  Future<List<Commande>> checkCommande(int livreur) {
    return _netUtil
        .get(DELIVER_URL +
        livreur.toString() +
        "/orders-to-deliver?limit=100&page=1")
        .then((dynamic res) {
      //  print(res.toString());
      if (res["code"] == 200 && res['items'] != null) {
        return (res['items'] as List)
            .map((item) => new Commande.map(item))
            .toList();
      } else {
        return null;
      }
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ////api/delivers/{deliver}/orders/{order}/shipped
  Future<bool> refuserCommande(int deliver, int order) {
    return _netUtil
        .put(DELIVER_URL +
        deliver.toString() +
        "/orders/" +
        order.toString() +
        "/declined")
        .then((dynamic res) {
      if (res["code"] == 200) {
        return true;
      } else
        return false;
    }).catchError(
            (onError) => new Future.error(new Exception(onError.toString())));
  }

  ////api/delivers/{deliver}/orders/{order}/shipped
  Future<bool> statusCommande(int deliver, int order) {
    return _netUtil
        .put(DELIVER_URL +
        deliver.toString() +
        "/orders/" +
        order.toString() +
        "/shipped")
        .then((dynamic res) {
      print(res.toString());
      if (res["code"] == 200) {
        return true;
      } else
        return false;
    }).catchError((onError) =>
    new Future.error(new Exception("erooooooor" + onError.toString())));
  }
}
