part of stubble;

class OpenBracketState extends StubbleState {
  OpenBracketState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;
    final res = StubbleResult();

    switch (charCode) {
      case openBracket:
        res.pop = true;
        res.message = NotifyMessage(
          charCode: charCode,
          type: notifySecondOpenBracketFound,
        );

        break;
      default:
        res.err = StubbleError(
            code: errorCharNotAOpenBracket,
            text: 'Wrong character is given. Expected "{"');
    }

    return res;
  }
}
