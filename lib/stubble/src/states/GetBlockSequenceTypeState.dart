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
    return StubbleResult(pop: true);
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    if (msg.type == NOTIFY_NAME_RESULT) {
      String blockName = msg.value;

      if (blockName.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_BLOCK_NAME_WRONG_SPECIFIED,
                text: 'Block name not specified'));
      } else {
        var res = StubbleResult(
            pop: true, message: ProcessMessage(charCode: msg.charCode));

        switch (blockName) {
          case "if":
            res.state = GetIfBlockState();
            break;

          case "with":
            res.state = GetWithBlockState();
            break;

          case "each":
            res.state = GetEachBlockState();
            break;

          default:
            res.state = GetBlockHelperState(helper: blockName);
            break;
        }

        return res;
      }
    }

    return StubbleResult(
        err: StubbleError(
            code: ERROR_UNSUPPORTED_NOTIFY,
            text:
                'State "${this.runtimeType}" does not support notifies of type ${msg.type}'));
  }
}
