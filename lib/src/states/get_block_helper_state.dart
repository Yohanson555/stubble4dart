part of stubble;

class GetBlockHelperState extends StubbleState {
  final String helper;
  final List<dynamic> _attributes = [];
  final int symbol;
  final int line;

  String _body = '';

  GetBlockHelperState({
    required this.helper,
    required this.symbol,
    required this.line,
  }) {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == eos) {
      return StubbleResult(
          err: StubbleError(
              code: errorUnterminatedBlock,
              text: 'Unterminated block helper "$helper" at $line:$symbol'));
    } else if (charCode == closeBracket) {
      return StubbleResult(state: CloseBracketState());
    } else if (charCode == space) {
      return null;
    }

    return StubbleResult(
        state: GetAttributeState(),
        message: ProcessMessage(charCode: charCode));
  }

  StubbleResult? notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case notifySecondCloseBracketFound:
        return StubbleResult(
          state: GetBlockEndState(
            blockName: helper,
          ),
        );

      case notifyAttrResult:
        _attributes.add(msg.value);

        if (msg.charCode != null) {
          return StubbleResult(
            message: ProcessMessage(
              charCode: msg.charCode!,
            ),
          );
        }

        break;

      case notifyBlockEndResult:
        _body = msg.value;

        return result(context);

      default:
        break;
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    if (!context.callable(helper)) {
      return StubbleResult(
        err: StubbleError(
          code: errorHelperUnregistered,
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
        text: 'Helper "$helper" error: ${e.toString()}',
        code: errorCallingHelper,
      );
    }

    return result;
  }
}
