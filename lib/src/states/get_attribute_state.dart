part of stubble;

class GetAttributeState extends StubbleState {
  GetAttributeState() {
    methods = {'process': (msg, context) => process(msg, context)};
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == quote || charCode == singleQuote) {
      return StubbleResult(
        pop: true,
        state: GetStringAttribute(quoteSymbol: charCode),
      );
    } else if (charCode >= 48 && charCode <= 57) {
      return StubbleResult(
          pop: true,
          state: GetNumberAttribute(),
          message: ProcessMessage(charCode: charCode));
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      return StubbleResult(
        pop: true,
        message: InitMessage(value: String.fromCharCode(charCode)),
        state: GetPathAttribute(),
      );
    }
    return StubbleResult(
        err: StubbleError(
            code: errorGettingAttribute,
            text:
                'Wrong attribute character "${String.fromCharCode(charCode)}"'));
  }
}
