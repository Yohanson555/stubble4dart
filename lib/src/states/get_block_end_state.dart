part of stubble;

class GetBlockEndState extends StubbleState {
  final String blockName;
  bool _search = false;
  bool _esc = false;
  String _look = '';
  String _openTag = '';
  String _tmp = '';
  String _body = '';
  int _count = 0;
  int _innerOpened = 0;

  GetBlockEndState({required this.blockName}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };

    var _o = String.fromCharCode(openBracket);
    var _c = String.fromCharCode(closeBracket);
    var _s = String.fromCharCode(slash);
    var _h = String.fromCharCode(sharp);

    _look = '$_o$_o$_s$blockName$_c$_c'; // {{/<name>}}
    _openTag = '$_o$_o$_h$blockName';
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == eos) {
      return StubbleResult(
          pop: true, message: ProcessMessage(charCode: charCode));
    }

    if (_search) {
      _tmp += String.fromCharCode(charCode);

      var l = _look;
      var t = _tmp;
      var o = _openTag;

      final op = context.opt('ignoreTagCaseSensetive');

      if (op == true) {
        l = l.toLowerCase();
        t = t.toLowerCase();
        o = o.toLowerCase();
      }

      if ((t[_count] != l[_count] && t[_count] != o[_count]) ||
          _count >= l.length) {
        _search = false;
        _body += _tmp;
      } else {
        _count++;
      }
      
      if (t == o) {
        _search = false;
        _body += _tmp;
        _innerOpened++;
      } else if (t.length == l.length) {
        if (_innerOpened > 0) {
          _search = false;
          _body += _tmp;
          _innerOpened--;
        } else {
          return StubbleResult(
              pop: true,
              message: NotifyMessage(
                charCode: null,
                type: notifyBlockEndResult,
                value: _body,
              ));
        }
      }
    } else {
      if (charCode == openBracket && !_esc) {
        _search = true;
        _tmp = '' + String.fromCharCode(openBracket);
        _count = 0;
      } else if (charCode == backSlash && !_esc) {
        _esc = true;
      } else {
        _esc = false;
        _body += String.fromCharCode(charCode);
      }
    }

    return null;
  }
}
