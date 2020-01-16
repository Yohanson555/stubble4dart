class StubbleContext {
  Map _data;
  Map <String, Function(List<dynamic>, Function)> _helpers;

  StubbleContext(Map data, Map <String, Function(List<dynamic>, Function)> helpers) {
    _data = data;
    _helpers = helpers;
  }

  bool callable(String helper) {
    return _helpers.containsKey(helper);
  }

  String call(String helper, List<dynamic> attributes, Function fn) {
    if(!_helpers.containsKey(helper)) {
      throw Exception('Helper "$helper" is not registered');
    }

    return _helpers[helper](attributes, fn);
  }

  dynamic get(String path) {
    final query = path.split('.');
    dynamic res;
    var depth = 0;

    if (query.length == 1) {
      if (_data.containsKey(path)) {
        res = _data[path];
      }
    } else {
      for (var q in query) {
        if (depth == 0) {
          res = _data[q];
        } else {
          if (res != null && res is Map) {
            res = res[q];
          } else {
            return null;
          }
        }

        depth++;
      }
    }

    return res;
  }

  Map get data {
    return _data;
  }

  Map <String, Function(List<dynamic>, Function)> get helpers {
    return _helpers;
  }
}