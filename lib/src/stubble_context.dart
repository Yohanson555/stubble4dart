part of stubble;

class StubbleContext {
  Map? _data;
  Map<String, Function(List<dynamic>, Function?)>? _helpers;
  Map<String, dynamic>? _options;
  Function(String)? _fn;
  int symbol = 0;
  int line = 0;

  StubbleContext([
    Map? data,
    Map<String, Function(List<dynamic>, Function?)>? helpers,
    Map<String, dynamic>? options,
    Function(String)? fn,
  ]) {
    _data = data;
    _helpers = helpers;
    _options = options;
    _fn = fn;
  }

  /// checks if helper with given name can be called
  bool callable(String helper) {
    if (_helpers == null) return false;

    return _helpers!.containsKey(helper);
  }

  /// calling helper with given name? attributes and parsing function
  String call(String? helper, List<dynamic> attributes, Function? fn) {
    if (helper == null || helper.isEmpty) {
      throw Exception('Helper name not specified');
    }

    if (_helpers == null || !_helpers!.containsKey(helper)) {
      throw Exception('Helper "$helper" is not registered');
    }

    return _helpers![helper]!(attributes, fn);
  }

  /// returns new compile function based on given template
  Function? compile(String template) {
    if (_fn != null) {
      return _fn!(template);
    }

    return null;
  }

  /// returns a value from context.data by given path
  dynamic get(String path) {
    final query = path.split('.');
    dynamic res;
    var depth = 0;

    if (_data == null) return null;

    if (query.length == 1 && _data!.containsKey(path)) {
      res = _data![path];
    } else {
      for (var q in query) {
        if (depth == 0) {
          res = _data![q];
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

  /// returns an value of given option or null, if not set
  dynamic opt(name) {
    if (_options != null && _options!.containsKey(name)) {
      return _options![name];
    }

    return null;
  }

  /// data getter
  Map? get data {
    return _data;
  }

  /// helpers getter
  Map<String, Function(List<dynamic>, Function)>? get helpers {
    return _helpers;
  }
}
