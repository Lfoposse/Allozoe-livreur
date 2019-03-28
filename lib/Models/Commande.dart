import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Note.dart';
import 'package:allozoe_livreur/Models/Restaurant.dart';
import 'package:allozoe_livreur/Models/StatusCommande.dart';

class Commande {
  int _id;
  String _reference;
  String _date;
  String _heure;
  double _prix;
  Restaurant _restaurant;
  StatusCommande _status;
  Client _client;
  String _delivery_address;
  String _delivery_city;
  String _delivery_phone;
  String _delivery_local;
  String _delivery_note;
  String _delivery_hour;
  String _delivery_date;
  double _delivery_stars;
  bool _acceptee;
  bool _livree;
  Note _note;

  Commande.empty() {
    this._id = -1;
    this._acceptee = false;
    this._livree = false;
    this._reference = "KSJDKSK";
    this._prix = 20.0;
    this._restaurant =
        new Restaurant(8, "casyan", "", "douala", "paris", 23.0, 9.45, 0);
    this._status = new StatusCommande(1, "SHIPPED");
    this._date = null;
    this._heure = null;
    this._client = null;
    this._delivery_address = "paris";
    this._delivery_city = "paris";
    this._delivery_phone = null;
    this._delivery_local = null;
    this._delivery_note = null;
    this._delivery_hour = null;
    this._delivery_date = null;
    this._note = null;
  }

  Commande.map(dynamic obj) {
    this._acceptee = false;
    this._livree = false;
    this._id = obj["id"];
    this._reference = obj["reference"].toString();
    this._date = obj["date"].toString();
    this._heure = obj["hour"].toString();
    this._prix = double.parse(obj["amount"].toString());
    this._restaurant = Restaurant.map(obj["restaurant"]);
    this._status = StatusCommande.map(obj["status"]);
    this._client = Client.map(200, obj["client"]);
    this._delivery_address = obj['delivery_address'].toString();
    this._delivery_city = obj['delivery_city'];
    this._delivery_phone = obj['delivery_phone'].toString();
    this._delivery_local = obj['delivery_local'].toString();
    this._delivery_hour = obj['delivery_hour'].toString();
    this._delivery_date = obj['delivery_date'].toString();
    this._delivery_note = obj['delivery_note'];
    if (obj['deliver'] != null) {
      this._delivery_stars = double.parse(obj['deliver']['note'].toString());
    }
  }

  Commande.notif(this._id, this._date, this._heure, this._prix, this._reference,
      this._restaurant, this._status, this._client);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["reference"] = _reference;
    map["date"] = _date;
    map["hour"] = _heure;
    map["amount"] = _prix;
    map["restaurant"] = _restaurant.toMap();
    map["status"] = _status.toMap();
    map["client"] = _client.toMap();
    map["acceptee"] = _acceptee;
    map["livree"] = _livree;
    map["note"] = _note;

    return map;
  }

  double get delivery_stars => _delivery_stars;

  set delivery_stars(double value) {
    _delivery_stars = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Note get note => _note;

  set note(Note value) {
    _note = value;
  }

  String get delivery_address => _delivery_address;

  set delivery_address(String value) {
    _delivery_address = value;
  }

  bool get livree => _livree;

  set livree(bool value) {
    _livree = value;
  }

  bool get acceptee => _acceptee;

  set acceptee(bool value) {
    _acceptee = value;
  }

  Client get client => _client;

  set client(Client value) {
    _client = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _reference = value;
  }

  StatusCommande get status => _status;

  set status(StatusCommande value) {
    _status = value;
  }

  Restaurant get restaurant => _restaurant;

  set restaurant(Restaurant value) {
    _restaurant = value;
  }

  double get prix => _prix;

  set prix(double value) {
    _prix = value;
  }

  String get heure => _heure;

  set heure(String value) {
    _heure = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get delivery_city => _delivery_city;

  set delivery_city(String value) {
    _delivery_city = value;
  }

  String get delivery_date => _delivery_date;

  set delivery_date(String value) {
    _delivery_date = value;
  }

  String get delivery_hour => _delivery_hour;

  set delivery_hour(String value) {
    _delivery_hour = value;
  }

  String get delivery_note => _delivery_note;

  set delivery_note(String value) {
    _delivery_note = value;
  }

  String get delivery_local => _delivery_local;

  set delivery_local(String value) {
    _delivery_local = value;
  }

  String get delivery_phone => _delivery_phone;

  set delivery_phone(String value) {
    _delivery_phone = value;
  }

  @override
  String toString() {
    return 'Commande{_id: $_id, _reference: $_reference, _date: $_date, _heure: $_heure, _prix: $_prix, _restaurant: $_restaurant, _status: $_status, _client: $_client, _delivery_address: $_delivery_address, _delivery_city: $_delivery_city, _delivery_phone: $_delivery_phone, _delivery_local: $_delivery_local, _delivery_note: $_delivery_note, _delivery_hour: $_delivery_hour, _delivery_date: $_delivery_date, _acceptee: $_acceptee, _livree: $_livree, _note: $_note}';
  }
}
