class Contador {
  int _index;
  String _title;
  int _value;

  Contador(this._index, this._title, this._value);

  Contador.fromJson(Map<String, dynamic> m) {
    _index = m['index'];
    _title = m['title'];
    _value = m['value'];
  }

  int get index => _index;
  String get title => _title;
  int get value => _value;

  Map<String, dynamic> toJson() => {
    'index': _index,
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
