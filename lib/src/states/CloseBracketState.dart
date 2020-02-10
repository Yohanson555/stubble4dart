part of stubble;

class CloseBracketState extends StubbleState {
  CloseBracketState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final res = StubbleResult();

    final charCode = msg.charCode;

    switch (charCode) {
      case CLOSE_BRACKET:
        res.pop = true;
        res.message = NotifyMessage(type: NOTIFY_SECOND_CLOSE_BRACKET_FOUND);
        break;
      default:
        res.err = StubbleError(
            code: ERROR_CHAR_NOT_A_CLOSE_BRACKET,
            text: 'Wrong character is given. Expected "}"');
    }

    return res;
  }
}
