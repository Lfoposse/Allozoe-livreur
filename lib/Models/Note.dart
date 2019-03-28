class Note {
  int _stars;
  int _avis;

  Note.empty() {
    this._stars = 0;
    this._avis = null;
  }

  Note(this._stars, this._avis);

  Note.map(dynamic obj) {
    this._stars = obj["stars"];
    this._avis = obj["avis"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["stars"] = _stars;
    map["avis"] = _avis;
    return map;
  }

  int get avis => _avis;

  set avis(int value) {
    _avis = value;
  }

  int get stars => _stars;

  set stars(int value) {
    _stars = value;
  }

  @override
  String toString() {
    return 'Note{_stars: $_stars, _avis: $_avis}';
  }
}
