import './Characters.dart';
import './States/RootState.dart';
import './StubbleContext.dart';
import './StubbleMessages.dart';
import './StubbleResult.dart';
import './StubbleState.dart';

class StubbleMachine {
  String _template;
  List<StubbleState> _stack;
  String _res;
  int _line = 0; // template lining support
  int _symbol = 0;

  StubbleMachine(String tpl) {
    _template = tpl;
  }

  String run(StubbleContext context) {
    _stack = [];
    _stack.add(RootState());
    _res = '';

    if (_template != null && _template.isNotEmpty) {
      final lines = _template.split('\n');

      for (var l = 0; l < lines.length; l++) {
        _line = l;
        final line = lines[l];

        for (var i = 0; i < line.length; i++) {
          print('Current state is: ${_stack.last}');
          _symbol = i;
          final charCode = line.codeUnitAt(i);

          print("char: ${line[i]}");

          process(ProcessMessage(charCode: charCode), context);
        }

        if (l < lines.length - 1) {
          process(ProcessMessage(charCode: ENTER), context);
        }
      }

      if (!(_stack.last is RootState)) {
        throw Exception(
            'Something go wrong: please check your template for issues.');
      }
    }

    return _res;
  }

  void process(StubbleMessage msg, StubbleContext context) {
    final state = _stack.last;

    if (state != null && state.canAcceptMessage(msg)) {
      final res = state.processMessage(msg, context);

      if (res != null) {
        processResult(res, context);
      }
    }
  }

  void processResult(StubbleResult r, StubbleContext context) {
    if (r.result != null) {
      _res += r.result;
    }

    if (r.pop == true) {
      pop();
    }

    if (r.state != null) {
      _stack.add(r.state);
    }

    if (r.message != null) {
      process(r.message, context);
    }

    if (r.err != null) {
      final e = 'Error (${r.err.code}) on $currentLine:$_symbol ${r.err.text}';

      print(e);

      throw Exception(e);
      //pop();
    }
  }

  void pop() {
    _stack.removeLast();
  }

  int get currentLine {
    return _line + 1;
  }
}
