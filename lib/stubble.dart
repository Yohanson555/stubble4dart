library stubble;

part 'src/characters_consts.dart';
part 'src/errors_types.dart';
part 'src/notify_types.dart';
part 'src/stubble_context.dart';
part 'src/stubble_error.dart';
part 'src/stubble_machine.dart';
part 'src/stubble_messages.dart';
part 'src/stubble_result.dart';
part 'src/stubble_state.dart';
part 'src/states/close_bracket_state.dart';
part 'src/states/get_attribute_state.dart';
part 'src/states/get_block_end_state.dart';
part 'src/states/get_block_helper_state.dart';
part 'src/states/get_block_name_state.dart';
part 'src/states/get_block_sequence_type_state.dart';
part 'src/states/get_condition_state.dart';
part 'src/states/get_data_state.dart';
part 'src/states/get_each_block_state.dart';
part 'src/states/get_helper_state.dart';
part 'src/states/get_if_block_state.dart';
part 'src/states/get_if_condition_state.dart';
part 'src/states/get_number_attribute.dart';
part 'src/states/get_path_attribute.dart';
part 'src/states/get_path_state.dart';
part 'src/states/get_sequence_state.dart';
part 'src/states/get_string_attribute.dart';
part 'src/states/get_with_block_state.dart';
part 'src/states/open_bracket_state.dart';
part 'src/states/root_state.dart';

class Stubble {
  final Map<String, Function(List<dynamic>, Function?)> _helpers = {};
  final Map<String, dynamic> _options = {'ignoreUnregisteredHelperErrors': false, 'ignoreTagCaseSensetive': false};

  Stubble([
    Map<String, dynamic>? options,
    Map<String, Function(List<dynamic>, Function?)>? helpers,
  ]) {
    if (helpers != null) {
      _helpers.addAll(helpers);
    }

    if (options != null) {
      _options.addAll(options);
    }
  }

  /// returns a compiler function that starts StubbleMachine with given template on call
  Function compile(String? template) {
    final machine = StubbleMachine(template);

    return (Map? data) {
      final context = StubbleContext(
        data,
        _helpers,
        _options,
        (String tpl) => compile(tpl),
      );

      final result = machine.run(context);

      return result;
    };
  }

  /// registers a helper function that can be used in templates. All helpers are available across the all template
  bool registerHelper(String name, Function(List<dynamic>, Function?) helper) {
    if (name.isEmpty) {
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
    _helpers.clear();

    return true;
  }

  int get helperCount {
    return _helpers.length;
  }

  void setOption(String name, dynamic value) {
    _options[name] = value;
  }
}
