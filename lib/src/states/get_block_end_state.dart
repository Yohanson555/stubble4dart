part of stubble;

class GetBlockEndState extends StubbleState {
  final String blockName;
  bool _search = false;
  bool _esc = false;
  String _look = '';
  String _tmp = '';
  String _body = '';
  int _count = 0;

  GetBlockEndState({required this.blockName}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
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

      final op = context.opt('ignoreTagCaseSensetive');

      if (op == true) {
        l = l.toLowerCase();
        t = t.toLowerCase();
      }

      if (t[_count] != l[_count]) {
        _search = false;
        _body += _tmp;
      } else {
        _count++;
      }

      if (t.length == l.length) {
        return StubbleResult(
            pop: true,
            message: NotifyMessage(
              charCode: null,
              type: notifyBlockEndResult,
              value: _body,
            ));
      }
    } else {
      if (charCode == openBracket && !_esc) {
        _search = true;
        _tmp = '' + String.fromCharCode(openBracket);
        _count = 0;

        var _o = String.fromCharCode(openBracket);
        var _c = String.fromCharCode(closeBracket);
        var _s = String.fromCharCode(slash);

        _look = '$_o$_o$_s$blockName$_c$_c'; // {{/<name>}}
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
