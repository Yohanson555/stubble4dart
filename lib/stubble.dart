library stubble;

import 'package:meta/meta.dart';

part './src/Characters.dart';
part './src/Errors.dart';
part './src/Notify.dart';
part './src/States.dart';
part './src/StubbleContext.dart';
part './src/StubbleError.dart';
part './src/StubbleMachine.dart';
part './src/StubbleMessages.dart';
part './src/StubbleResult.dart';
part './src/StubbleState.dart';
part './src/states/CloseBracketState.dart';
part './src/states/GetAttributeState.dart';
part './src/states/GetBlockEndState.dart';
part './src/states/GetBlockHelperState.dart';
part './src/states/RootState.dart';
part './src/states/OpenBracketState.dart';
part './src/states/GetWithBlockState.dart';
part './src/states/GetStringAttribute.dart';
part './src/states/GetSequenceState.dart';
part './src/states/GetPathState.dart';
part './src/states/GetPathAttribute.dart';
part './src/states/GetNumberAttribute.dart';
part './src/states/GetIfConditionState.dart';
part './src/states/GetIfBlockState.dart';
part './src/states/GetHelperState.dart';
part './src/states/GetEachBlockState.dart';
part './src/states/GetDataState.dart';
part './src/states/GetConditionState.dart';
part './src/states/GetBlockSequenceTypeState.dart';
part './src/states/GetBlockNameState.dart';

class Stubble {
  Map<String, Function(List<dynamic>, Function)> _helpers = {};
  Map<String, dynamic> _options = {
    'ignoreUnregisteredHelperErrors': false,
    'ignoreTagCaseSensetive': false
  };

  Stubble([Map<String, dynamic> options, Map<String, Function(List<dynamic>, Function)> helpers]) {
    _helpers = helpers ?? {};

    if (options != null) {
      _options.addAll(options);
    }
  }

  /// returns a compiler function that starts StubbleMachine with given template on call
  Function compile(String template) {
    if (template == null || template.isEmpty) {
      throw Exception('Can\'t create compiller with empty template');
    }

    final machine = StubbleMachine(template);

    return (Map data) {
      final context = StubbleContext(data, _helpers, _options, (String tpl) => compile(tpl));

      final result = machine.run(context);

      return result;
    };
  }

  /// registers a helper function that can be used in templates. All helpers are available across the all template
  bool registerHelper(
      String name, Function(List<dynamic>, Function) helper) {
    if (name == null || name.isEmpty) {
      throw Exception('Helper\'s name should be provided');
    } else {
      var regExp = RegExp(
        r'^[a-zA-Z_]+\w+$',
        caseSensitive: false,
        multiLine: false,
      );

      if (!regExp.hasMatch(name)) {
        throw Exception('Wrong helper name specified');
      }
    }

    if (helper == null) {
      throw Exception('Helper\'s function should be provided');
    }

    if (!_helpers.containsKey(name)) {
      _helpers[name] = helper;
      return true;
    }

    return false;
  }

  /// removes a helper function with a given name
  bool removeHelper(String name) {
    if (_helpers.containsKey(name)) {
      _helpers.remove(name);
      return true;
    }

    return false;
  }

  /// removes all helpers from Stubble
  bool dropHelpers() {
    _helpers = {};

    return true;
  }

  int get helperCount {
    return _helpers != null ? _helpers.length : 0;
  }

  void setOption(String name, dynamic value) {
    _options[name] = value;
  }
}
