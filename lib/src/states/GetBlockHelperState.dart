part of stubble;

class GetBlockHelperState extends StubbleState {
  final String helper;
  final List<dynamic> _attributes = [];
  final symbol;
  final line;

  String _body = '';

  GetBlockHelperState({@required this.helper, this.symbol, this.line}) {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == EOS) {
      return StubbleResult(
          err: StubbleError(
              code: ERROR_UNTERMINATED_BLOCK,
              text: 'Unterminated block helper "$helper" at $line:$symbol'));
    } else if (charCode == CLOSE_BRACKET) {
      return StubbleResult(state: CloseBracketState());
    } else if (charCode == SPACE) {
      return null;
    }

    return StubbleResult(
        state: GetAttributeState(),
        message: ProcessMessage(charCode: charCode));
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return StubbleResult(
          state: GetBlockEndState(
            blockName: helper,
          ),
        );

      case NOTIFY_ATTR_RESULT:
        _attributes.add(msg.value);

        if (msg.charCode != null) {
          return StubbleResult(
            message: ProcessMessage(
              charCode: msg.charCode,
            ),
          );
        }

        break;

      case NOTIFY_BLOCK_END_RESULT:
        _body = msg.value;

        return result(context);
        break;

      default:
        break;
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    if (!context.callable(helper)) {
      return StubbleResult(
        err: StubbleError(
          code: ERROR_HELPER_UNREGISTERED,
          text: 'Helper "$helper" is unregistered',
        ),
      );
    }

    final result = StubbleResult();

    try {
      if (_attributes.isEmpty) {
        _attributes.add(context.data);
      }

      result.result = context.call(helper, _attributes, context.compile(_body));
      result.pop = true;
    } catch (e) {
      result.err = StubbleError(
        text: 'Helper "${helper}" error: ${e.toString()}',
        code: ERROR_CALLING_HELPER,
      );
    }

    return result;
  }
}
