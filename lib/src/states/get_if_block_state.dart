part of stubble;

class GetIfBlockState extends StubbleState {
  final int symbol;
  final int line;

  bool _res = false;
  String _body = '';

  GetIfBlockState({required this.symbol, required this.line}) {
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
              text: 'Unterminated "IF" block at $line:$symbol'));
    } else if (charCode == space) {
      return null;
    } else if (charCode == closeBracket) {
      return StubbleResult(
        state: CloseBracketState(),
      );
    }

    return StubbleResult(
      state: GetIfConditionState(),
      message: ProcessMessage(charCode: charCode),
    );
  }

  StubbleResult? notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case notifyConditionResult:
        _res = msg.value ?? false;

        if (msg.charCode != null) {
          return StubbleResult(
            message: ProcessMessage(
              charCode: msg.charCode!,
            ),
          );
        }

        break;
      case notifySecondCloseBracketFound:
        return StubbleResult(
          state: GetBlockEndState(
            blockName: 'if',
          ),
        );

      case notifyBlockEndResult:
        _body = msg.value;
        return result(context);

      default:
        return StubbleResult(
          err: StubbleError(
            code: errorUnsupportedNotify,
            text:
                'State "$runtimeType" does not support notifies of type ${msg.type}',
          ),
        );
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    var res = '';

    if (_res == true) {
      try {
        final fn = context.compile(_body);

        if (fn != null) {
          res = fn(context.data);
        }
      } catch (e) {
        return StubbleResult(
          err: StubbleError(
            code: errorIfBlockMalformed,
            text: 'If block error: $e',
          ),
        );
      }
    }

    return StubbleResult(pop: true, result: res);
  }
}
