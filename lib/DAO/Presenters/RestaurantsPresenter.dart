import 'dart:async';

import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Restaurant.dart';

abstract class RestaurantContract {
  void onLoadingSuccess(List<Restaurant> restaurants);
  void onLoadingError();
  void onConnectionError();
}

class RestaurantPresenter {
  RestaurantContract _view;
  RestDatasource api = new RestDatasource();
  RestaurantPresenter(this._view);

  loadRestaurants() {
    new DatabaseHelper().getClient().then((List<Client> c) {
      print("client :" + c.length.toString());
      if (c != null || c.length > 0) {
        api.loadRestaurants(c[0].id).then((List<Restaurant> restaurants) {
          if (restaurants != null)
            _view.onLoadingSuccess(restaurants);
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

  Future<List<Restaurant>> loadRestaurantsRefresh() {
    return api.loadRestaurants(9).then((List<Restaurant> restaurants) {
      if (restaurants != null)
        return restaurants;
      else
        return null;
    });
  }

  Future<bool> accepterCommande(int deliver, int order) {
    return api.accepterCommande(deliver, order).then((bool etat) {
      if (etat != false)
        return true;
      else
        return false;
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
