import 'package:meta/meta.dart';

import '../Characters.dart' as chars;
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetBlockEndState extends StubbleState {
  final String blockName;
  bool _search = false;
  bool _esc = false;
  String _look = '';
  String _tmp = '';
  String _body = '';
  int _count = 0;

  GetBlockEndState({@required this.blockName}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (_search) {
      if (_tmp.length < _look.length) {
        _tmp += String.fromCharCode(charCode);

        if (_tmp[_count] != _look[_count]) {
          _search = false;
          _body += _tmp;
        } else {
          _count++;
        }
      }

      if (_tmp.length == _look.length) {
        if (_tmp == _look) {
          return StubbleResult(
              pop: true,
              message: NotifyMessage(
                charCode: null,
                type: NOTIFY_BLOCK_END_RESULT,
                value: _body,
              ));
        } else {
          _search = false;
          _body += _tmp;
        }
      }
    } else {
      if (charCode == chars.OPEN_BRACKET && !_esc) {
        _search = true;
        _tmp = '' + String.fromCharCode(chars.OPEN_BRACKET);
        _count = 0;

        var _o = String.fromCharCode(chars.OPEN_BRACKET);
        var _c = String.fromCharCode(chars.CLOSE_BRACKET);
        var _s = String.fromCharCode(chars.SLASH);

        _look = '$_o$_o$_s$blockName$_c$_c'; // {{/<name>}}
      } else if (charCode == chars.BACK_SLASH && !_esc) {
        _esc = true;
      } else {
        _esc = false;
        _body += String.fromCharCode(charCode);
      }
    }

    return null;
  }
}
