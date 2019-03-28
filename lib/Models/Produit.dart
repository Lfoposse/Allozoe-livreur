import 'package:allozoe_livreur/Models/Restaurant.dart';

class Produit {
  int _qteCmder;
  bool _favoris;

  int _id;
  String _name;
  String _description;
  String _photo;
  double _prix;
  Restaurant _restaurant;

  Produit.empty() {
    this._id = -1;
    this._qteCmder = 1;
    this._name = null;
    this._description = null;
    this._photo = null;
    this._prix = null;
    this._favoris = false;
    this._restaurant = null;
  }

  Produit(this._qteCmder, this._favoris, this._id, this._name,
      this._description, this._photo, this._prix);

  Produit.map(dynamic obj) {
    this._qteCmder = 1;
    this._favoris = false;

    this._id = obj["id"];
    this._name = obj["name"];
    this._description = obj["description"];
    this._photo = obj["image"];
    this._prix = double.parse(obj["price"].toString());
    //this._restaurant = Restaurant.map(obj["restaurant"]);
  }

  int get id => _id;
  int get nbCmds => _qteCmder;
  String get name => _name;
  String get description => _description;
  double get prix => _prix;
  String get photo => _photo;
  bool get isFavoris => _favoris;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["prod_id"] = _id;
    map["name"] = _name;
    map["description"] = _description;
    map["prix"] = _prix;
    map["photo"] = _photo;
    map["favoris"] = _favoris;
    map["nbCmds"] = _qteCmder;
    return map;
  }

  set qteCmder(int value) {
    _qteCmder = value;
  }

  set name(String value) {
    _name = value;
  }

  set description(String value) {
    _description = value;
  }

  set photo(String value) {
    _photo = value;
  }

  set prix(double value) {
    _prix = value;
  }

  set favoris(bool value) {
    _favoris = value;
  }
}
