
class StatusCommande {

  int _id;
  String _name;

  StatusCommande.empty(){
    this._id = -1;
    this._name = null;
  }

  StatusCommande(this._id, this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


  StatusCommande.map(dynamic obj) {

    this._id = obj["id"];
    this._name = obj["name"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

}