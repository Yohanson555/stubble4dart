part of stubble;

class GetStringAttribute extends StubbleState {
  final int quoteSymbol;
  String _value = '';
  bool _escape = false;

  GetStringAttribute({required this.quoteSymbol}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (_escape) {
      _escape = false;
      _value += String.fromCharCode(charCode);
    } else {
      if (charCode == openBracket || charCode == closeBracket) {
        return StubbleResult(
          err: StubbleError(
            code: errorStringAttributeMalformed,
            text:
                'Wrong attribute value character "${String.fromCharCode(charCode)}"',
          ),
        );
      } else if (charCode == backSlash) {
        _escape = true;
      } else if (charCode == quoteSymbol) {
        return StubbleResult(
          pop: true,
          message: NotifyMessage(
            type: notifyAttrResult,
            value: _value,
            charCode: null,
          ),
        );
      } else {
        _value += String.fromCharCode(charCode);
      }
    }

    return null;
  }
}
