part of stubble;

class GetSequenceState extends StubbleState {
  GetSequenceState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    final res = StubbleResult();

    if (charCode == dollar) {
      res.pop = true;
      res.message = NotifyMessage(
        charCode: charCode,
        type: notifyIsHelperSequence,
      );
    } else if (charCode == sharp) {
      res.pop = true;
      res.message = NotifyMessage(
        charCode: charCode,
        type: notifyIsBlockSequence,
      );
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122)) {
      res.pop = true;
      res.message = NotifyMessage(
          charCode: charCode,
          type: notifyIsDataSequence,
          value: String.fromCharCode(charCode));
    } else {
      res.err = StubbleError(
          code: errorWrongSequenceCharacter,
          text: 'Wrong character "${String.fromCharCode(charCode)}" found');
    }

    return res;
  }
}
