part of stubble;

class GetDataState extends StubbleState {
  String _path;

  GetDataState() {
    methods = {
      'init': (msg, context) => init(msg, context),
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult init(InitMessage msg, StubbleContext context) {
    final path = msg.value;

    return StubbleResult(state: GetPathState(path: path));
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    switch (charCode) {
      case SPACE:
        return null;
      case CLOSE_BRACKET:
        return StubbleResult(state: CloseBracketState());

      default:
        return StubbleResult(
            err: StubbleError(
          code: ERROR_WRONG_DATA_SEQUENCE_CHARACTER,
          text: 'Wrong character "${String.fromCharCode(charCode)}" found',
        ));
    }
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_PATH_RESULT:
        _path = msg.value;

        return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return StubbleResult(pop: true, result: getResult(context));
      default:
        break;
    }

    return null;
  }

  String getResult(StubbleContext context) {
    var result = '';

    if (context != null) {
      var value = context.get(_path);

      if (value != null) {
        result = value.toString();
      }
    }

    return result;
  }
}
