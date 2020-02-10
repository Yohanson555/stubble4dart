part of stubble;

class GetNumberAttribute extends StubbleState {
  var value = '';

  GetNumberAttribute({this.value}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    value ??= '';

    if (charCode == CLOSE_BRACKET || charCode == SPACE) {
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              charCode: charCode,
              type: NOTIFY_ATTR_RESULT,
              value: num.parse(value)));
    } else if (charCode == DOT) {
      if (value.indexOf(String.fromCharCode(DOT)) > 0) {
        return StubbleResult(
            err: StubbleError(
                text: 'Duplicate number delimiter',
                code: ERROR_NUMBER_ATTRIBUTE_MALFORMED));
      }

      value += String.fromCharCode(charCode);
    } else if (charCode >= 48 && charCode <= 57) {
      value += String.fromCharCode(charCode);
    } else {
      return StubbleResult(
          err: StubbleError(
              text: 'Number attribute malformed',
              code: ERROR_NUMBER_ATTRIBUTE_MALFORMED));
    }

    return null;
  }
}
