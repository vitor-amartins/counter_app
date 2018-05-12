class Contador {
  String _title;
  int _value;

  Contador(this._title, this._value);

  Contador.fromJson(Map<String, dynamic> m) {
    _title = m['title'];
    _value = m['value'];
  }

  String get title => _title;
  int get value => _value;
  set setTitle(String newTitle) => _title = newTitle;

  Map<String, dynamic> toJson() => {
    'title': _title,
    'value': _value,
  };

  int inc() {
    return ++_value;
  }

  int dec() {
    return --_value;
  }
}
