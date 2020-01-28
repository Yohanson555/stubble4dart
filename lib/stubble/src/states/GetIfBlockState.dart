part of stubble;

class GetIfBlockState extends StubbleState {
  bool _res = false;
  String _body;

  GetIfBlockState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == SPACE) {
      return null;
    } else if (charCode == CLOSE_BRACKET) {
      return StubbleResult(state: CloseBracketState());
    }

    return StubbleResult(
      state: GetIfConditionState(),
      message: ProcessMessage(charCode: charCode),
    );
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_CONDITION_RESULT:
        _res = msg.value ?? false;

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
        }

        break;
      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return StubbleResult(state: GetBlockEndState(blockName: 'if'));

      case NOTIFY_BLOCK_END_RESULT:
        _body = msg.value;
        return result(context);

      default:
        return StubbleResult(
            err: StubbleError(
                code: ERROR_UNSUPPORTED_NOTIFY,
                text:
                    'State "$runtimeType" does not support notifies of type ${msg.type}'));
    }
  }

  StubbleResult result(StubbleContext context) {
    var res = '';

    if (_res == true) {
      try {
        final fn = context.compile(_body);
        res = fn(context.data);
      } catch (e) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_IF_BLOCK_MALFORMED, text: 'If block error: $e'));
      }
    }

    return StubbleResult(pop: true, result: res);
  }
}
