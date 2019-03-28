class Restaurant {
  int _id;
  String _name;
  String _photo;
  String _city;
  String _address;
  double _latitude;
  double _longitude;
  double _note;

  Restaurant.empty() {
    this._id = -1;
    this._name = null;
    this._photo = null;
    this._city = null;
    this._address = null;
    this._latitude = 0.0;
    this._longitude = 0.0;
    this._note = null;
  }

  Restaurant(this._id, this._name, this._photo, this._city, this._address,
      this._latitude, this._longitude, this._note);

  Restaurant.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"].toString();
    this._photo = obj["image"].toString();
    this._city = obj["city"].toString();
    this._address = obj["address"].toString();
    this._latitude = obj["position"] != null
        ? double.parse(obj["position"]["latitude"])
        : 0.0;
    this._longitude = obj["position"] != null
        ? double.parse(obj["position"]["longitude"])
        : 0.0;
    if (obj['note'] != null) {
      this._note = double.parse(obj["note"].toString());
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["image"] = _photo;
    map["city"] = _city;
    map["address"] = _address;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["note"] = _note;
    return map;
  }

  String get name => _name;

  int get id => _id;

  String get address => _address;

  double get longitude => _longitude;

  double get latitude => _latitude;

  String get photo => _photo;

  String get city => _city;

  set longitude(double value) {
    _longitude = value;
  }

  set latitude(double value) {
    _latitude = value;
  }

  set address(String value) {
    _address = value;
  }

  set id(int value) {
    _id = value;
  }

  set photo(String value) {
    _photo = value;
  }

  set city(String value) {
    _city = value;
  }

  set name(String value) {
    _name = value;
  }

  double get note => _note;

  set note(double value) {
    _note = value;
  }
}
