import 'package:allozoe_livreur/Models/Produit.dart';

class Categorie {
  int _id;
  String _name;
  List<Produit> _produits;
  String _description;
  String _photo;

  Categorie.empty() {
    this._id = -1;
    this._name = null;
    this._produits = null;
    this._description = null;
    this._photo = null;
  }

  Categorie(
      this._id, this._name, this._produits, this._description, this._photo);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<Produit> get produits => _produits;

  set produits(List<Produit> value) {
    _produits = value;
  }

  Categorie.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
    this.description = obj["description"];
    this._photo = obj["image"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["description"] = _description;
    map["photo"] = _photo;
    map["produits"] = _produits;
    return map;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }
}
