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
      case closeBracket:
        res.pop = true;
        res.message = NotifyMessage(type: notifySecondCloseBracketFound);
        break;
      default:
        res.err = StubbleError(
            code: errorChartNotACloseBracket,
            text: 'Wrong character is given. Expected "}"');
    }

    return res;
  }
}
