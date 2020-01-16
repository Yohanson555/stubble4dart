import './StubbleContext.dart';
import './StubbleMachine.dart';

class Stubble {
  static Map<String, Function(List<dynamic>, Function)> _helpers = {};

  static Function compile(String template) {
    final machine = StubbleMachine(template);

    return (Map data) {
      // создает объект компилятора
      // инициализирует его шаблоном (??)

      //думаю что компиляция шаблона должна представлять из себя последовательный вызов и замену всех сущностей всех типов.

      //первым делом идут блочные вызовы
      final context = StubbleContext(data, _helpers);

      final result = machine.run(context);

      return result;
    };
  }

  static bool registerHelper(String name, Function(List<dynamic>, Function) helper) {
    if (!_helpers.containsKey(name)) {
      _helpers[name] = helper;
      return true;
    }

    return false;
  }

  static bool removeHelper(String name) {
    if (!_helpers.containsKey(name)) {
      _helpers.remove(name);
      return true;
    }

    return false;
  }

  static void dropHelpers() {
    _helpers = {};
  }
}
