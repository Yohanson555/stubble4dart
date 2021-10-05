part of stubble;

class GetBlockNameState extends StubbleState {
  String? name;

  GetBlockNameState({this.name}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    name ??= '';

    if (charCode == eos) {
      return StubbleResult(
          err: StubbleError(
              code: errorUnexpectedEndOfSource,
              text: 'block name error: unexpected end of source'));
    } else if (charCode >= 48 && charCode <= 57) {
      if (name!.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: errorBlockNameWrongSpecified,
                text: 'Block name should not start with number character'));
      }

      name = name! + String.fromCharCode(charCode);
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      name = name! + String.fromCharCode(charCode);
    } else if (charCode == space || charCode == closeBracket) {
      if (name!.isEmpty) {
        return StubbleResult(
          err: StubbleError(
            code: errorBlockNameWrongSpecified,
            text: 'Block name is empty',
          ),
        );
      }

      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              type: notifyNameResult, value: name, charCode: charCode));
    } else {
      return StubbleResult(
        err: StubbleError(
          code: errorNotAValidBlockNameChar,
          text:
              'Character "${String.fromCharCode(charCode)}" is not a valid in block name',
        ),
      );
    }

    return null;
  }
}
