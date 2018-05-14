class Config {
  String _defaultWP;

  Config(this._defaultWP);

  String get defaultWP => _defaultWP;
  set setWP(String newWP) => _defaultWP = newWP;
}
