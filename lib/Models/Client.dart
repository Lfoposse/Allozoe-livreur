class Client {
  int _client_id;

  String _email;
  String _password;

  String _username;
  String _lastname;
  String _phone;

  int _code;
  // List<String> _roles;

  Client.empty(int code) {
//    print("empty_fun   ");
//    print(code);
    this._username = null;
    this._lastname = null;
    this._email = null;
    this._phone = null;
    this._password = null;
    this._code = code;
  }

  Client(this._client_id, this._username, this._lastname, this._email);

  Client.map(int code, dynamic obj) {
    this._code = code;
    this._client_id = obj["id"];
    this._username = obj["username"].toString();
    this._lastname = obj["lastname"].toString();
    this._email = obj["email"];
    //this._roles = obj["role"];
  }

  int get id => _client_id;
  String get username => _username;
  String get password => _password;
  String get lastname => _lastname;
  String get email => _email;
  String get phone => _phone;

  int get code => _code;

  set code(int value) {
    _code = value;
  }
  //List<String> get roles => _roles;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["client_id"] = _client_id;
    map["username"] = _username;
    map["firstname"] = lastname;
    map["lastname"] = _lastname;
    map["email"] = _email;
    map["phone"] = _email;
    //map["roles"] = _roles;

    return map;
  }

  set phone(String value) {
    _phone = value;
  }

  set id(int value) {
    _client_id = value;
  }

  set email(String value) {
    _email = value;
  }

  set lastname(String value) {
    _lastname = value;
  }

  set username(String value) {
    _username = value;
  }

  set password(String value) {
    _password = value;
  }

  @override
  String toString() {
    return 'Client{_client_id: $_client_id, _email: $_email, _password: $_password, _username: $_username, _lastname: $_lastname, _phone: $_phone}';
  }
}
