part of stubble;

class GetConditionState extends StubbleState {
  String _condition = '';

  GetConditionState() {
    methods = {'process': (msg, context) => process(msg, context)};
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == EOS) {
      return StubbleResult(
          err: StubbleError(
              code: ERROR_UNEXPECTED_END_OF_SOURCE,
              text: 'IF condition error: unexpected end of source')
      );
    } else if (charCode == MORE ||
        charCode == LESS ||
        charCode == EQUAL ||
        charCode == EXCL_MARK) {
      _condition += String.fromCharCode(charCode);
      return null;
    } else if (charCode == CLOSE_BRACKET || charCode == SPACE) {
      if (_condition.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_IF_BLOCK_CONDITION_MALFORMED,
                text: 'If block condition should not be empty'));
      } else if (_condition.length > 2 || !(['==', '!=', '<', '>', '<=', '>='].contains(_condition))) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_IF_BLOCK_CONDITION_MALFORMED,
                text: 'If block condition malformed: "$_condition"'));

      } else {
        return StubbleResult(
            pop: true,
            message: NotifyMessage(
                type: NOTIFY_CONDITION_RESULT,
                value: _condition,
                charCode: charCode));
      }
    }

    return StubbleResult(
        err: StubbleError(
            code: ERROR_GETTING_ATTRIBUTE,
            text:
                'Wrong condition character "${String.fromCharCode(charCode)}" ($charCode)'));
  }
}
