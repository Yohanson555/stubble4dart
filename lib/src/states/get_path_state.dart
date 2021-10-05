part of stubble;

class GetPathState extends StubbleState {
  String? path;
  int? lastChar;

  GetPathState({this.path}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    path ??= '';

    if (charCode == eos) {
      return StubbleResult(
          pop: true, message: ProcessMessage(charCode: charCode));
    } else if (charCode == dot) {
      if (path!.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not start with point character',
                code: errorPathWrongSpecified));
      }

      path = path! + String.fromCharCode(charCode);
    } else if ((charCode >= 48 && charCode <= 57)) {
      if (path!.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not start with number character',
                code: errorPathWrongSpecified));
      }

      path = path! + String.fromCharCode(charCode);
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      path = path! + String.fromCharCode(charCode);
    } else if (charCode == space || charCode == closeBracket) {
      if (lastChar == dot) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not end with dot character',
                code: errorPathWrongSpecified));
      }
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              type: notifyPathResult, value: path, charCode: charCode));
    } else {
      return StubbleResult(
          err: StubbleError(
              code: errorNotAValidPathChar,
              text:
                  'Character "${String.fromCharCode(charCode)}" is not a valid in path'));
    }

    lastChar = charCode;

    return null;
  }
}
