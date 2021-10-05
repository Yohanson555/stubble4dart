part of stubble;

class GetConditionState extends StubbleState {
  String _condition = '';

  GetConditionState() {
    methods = {'process': (msg, context) => process(msg, context)};
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == eos) {
      return StubbleResult(
          err: StubbleError(
              code: errorUnexpectedEndOfSource,
              text: 'IF condition error: unexpected end of source')
      );
    } else if (charCode == more ||
        charCode == less ||
        charCode == equal ||
        charCode == exclMark) {
      _condition += String.fromCharCode(charCode);
      return null;
    } else if (charCode == closeBracket || charCode == space) {
      if (_condition.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: errorIfBlockConditionMalformed,
                text: 'If block condition should not be empty'));
      } else if (_condition.length > 2 || !(['==', '!=', '<', '>', '<=', '>='].contains(_condition))) {
        return StubbleResult(
            err: StubbleError(
                code: errorIfBlockConditionMalformed,
                text: 'If block condition malformed: "$_condition"'));

      } else {
        return StubbleResult(
            pop: true,
            message: NotifyMessage(
                type: notifyConditionResult,
                value: _condition,
                charCode: charCode));
      }
    }

    return StubbleResult(
        err: StubbleError(
            code: errorGettingAttribute,
            text:
                'Wrong condition character "${String.fromCharCode(charCode)}" ($charCode)'));
  }
}
