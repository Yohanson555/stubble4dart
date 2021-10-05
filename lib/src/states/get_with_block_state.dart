part of stubble;

class GetWithBlockState extends StubbleState {
  final int symbol;
  final int line;

  String _path = '';
  String _body = '';

  GetWithBlockState({required this.symbol, required this.line}) {
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
          text: 'Unterminated "WITH" block at $line:$symbol',
        ),
      );
    } else if (charCode == closeBracket) {
      return StubbleResult(
        state: CloseBracketState(),
      );
    } else if (charCode == space) {
      return null;
    }

    return StubbleResult(
      state: GetPathState(),
      message: ProcessMessage(
        charCode: charCode,
      ),
    );
  }

  StubbleResult? notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case notifyPathResult:
        _path = msg.value;
        return StubbleResult(
          message: ProcessMessage(
            charCode: msg.charCode!,
          ),
        );

      case notifySecondCloseBracketFound:
        return StubbleResult(
          state: GetBlockEndState(
            blockName: 'with',
          ),
        );

      case notifyBlockEndResult:
        _body = msg.value;
        return result(context);
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    final result = StubbleResult();

    if (_path.isEmpty) {
      result.err = StubbleError(
        text: 'With block required path to context data',
        code: errorPathNotSpecified,
      );
    } else {
      try {
        final data = context.get(_path);

        if (data != null) {
          if (data is Map) {
            final fn = context.compile(_body);

            return StubbleResult(
              result: fn != null ? fn(data) : '',
              pop: true,
            );
          } else {
            result.err = StubbleError(
              text: '"With" block data should have "Map" type',
              code: errorWithDataMalformed,
            );
          }
        } else {
          result.err = StubbleError(
            text: 'Can\'t get data from context by path "$_path"',
            code: errorPathWrongSpecified,
          );
        }
      } catch (e) {
        result.err = StubbleError(
          text: e.toString(),
          code: errorCallingHelper,
        );
      }
    }

    return result;
  }
}
