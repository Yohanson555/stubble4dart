part of stubble;

class GetNumberAttribute extends StubbleState {
  String? value;

  GetNumberAttribute({this.value}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    value ??= '';

    if (charCode == closeBracket || charCode == space) {
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              charCode: charCode,
              type: notifyAttrResult,
              value: num.parse(value!)));
    } else if (charCode == dot) {
      if (value!.indexOf(String.fromCharCode(dot)) > 0) {
        return StubbleResult(
            err: StubbleError(
                text: 'Duplicate number delimiter',
                code: errorNumberAttributeMalformed));
      }

      value = value! + String.fromCharCode(charCode);
    } else if (charCode >= 48 && charCode <= 57) {
      value = value! + String.fromCharCode(charCode);
    } else {
      return StubbleResult(
        err: StubbleError(
          text: 'Number attribute malformed',
          code: errorNumberAttributeMalformed,
        ),
      );
    }

    return null;
  }
}
