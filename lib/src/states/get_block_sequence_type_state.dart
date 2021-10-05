part of stubble;

class GetBlockSequenceTypeState extends StubbleState {
  GetBlockSequenceTypeState() {
    methods = {
      'init': (msg, context) => init(msg, context),
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult init(InitMessage msg, StubbleContext context) {
    return StubbleResult(state: GetBlockNameState());
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    return StubbleResult(
      pop: true,
      message: ProcessMessage(charCode: msg.charCode),
    );
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    if (msg.type == notifyNameResult) {
      String blockName = msg.value;

      if (blockName.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: errorBlockNameWrongSpecified,
                text: 'Block name not specified'));
      } else {
        var res = StubbleResult(
          pop: true,
          message: ProcessMessage(charCode: msg.charCode!),
        );

        switch (blockName) {
          case 'if':
            res.state =
                GetIfBlockState(line: context.line, symbol: context.symbol);
            break;

          case 'with':
            res.state =
                GetWithBlockState(line: context.line, symbol: context.symbol);
            break;

          case 'each':
            res.state =
                GetEachBlockState(line: context.line, symbol: context.symbol);
            break;

          default:
            res.state = GetBlockHelperState(
                helper: blockName, line: context.line, symbol: context.symbol);
            break;
        }

        return res;
      }
    }

    return StubbleResult(
      err: StubbleError(
          code: errorUnsupportedNotify,
          text:
              'State "$runtimeType" does not support notifies of type ${msg.type}'),
    );
  }
}
