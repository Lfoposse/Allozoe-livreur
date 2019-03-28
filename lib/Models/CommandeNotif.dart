

class CommandeNotif{
  int _commande_id;
  String _reference;
  String _date;
  String _heure;
  double _prix;
  String _client_name;
  int _restaurant_id;
  int _client_id;
  String _delivery_address;


  CommandeNotif(this._client_id,this._commande_id,
      this._restaurant_id,  this._client_name, this._reference, this._date,this._prix, this._delivery_address,this._heure);

  String get client_name => _client_name;

  set client_name(String value) {
    _client_name = value;
  }

  int get commande_id => _commande_id;

  String get reference => _reference;

  String get delivery_address => _delivery_address;

  int get client_id => _client_id;

  int get restaurant_id => _restaurant_id;

  double get prix => _prix;

  String get heure => _heure;

  String get date => _date;

  set delivery_address(String value) {
    _delivery_address = value;
  }

  set client_id(int value) {
    _client_id = value;
  }

  set restaurant_id(int value) {
    _restaurant_id = value;
  }

  set prix(double value) {
    _prix = value;
  }

  set heure(String value) {
    _heure = value;
  }

  set date(String value) {
    _date = value;
  }

  set reference(String value) {
    _reference = value;
  }

  set commande_id(int value) {
    _commande_id = value;
  }


}