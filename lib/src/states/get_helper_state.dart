part of stubble;

class GetHelperState extends StubbleState {
  final List<dynamic> _attributes = [];
  String _helper = '';
  

  GetHelperState() {
    methods = {
      'init': (msg, context) => init(msg, context),
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult init(InitMessage msg, StubbleContext context) {
    return StubbleResult(
      state: GetBlockNameState(),
    );
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == closeBracket) {
      return StubbleResult(
        state: CloseBracketState(),
      );
    } else if (charCode == space) {
      return null;
    }

    return StubbleResult(
      state: GetAttributeState(),
      message: ProcessMessage(
        charCode: charCode,
      ),
    );
  }

  StubbleResult? notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case notifyNameResult:
        _helper = msg.value;

        if (msg.charCode != null) {
          return StubbleResult(
            message: ProcessMessage(
              charCode: msg.charCode!,
            ),
          );
        }
        break;

      case notifySecondCloseBracketFound:
        return result(context);

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

      default:
        break;
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    if (!context.callable(_helper)) {
      return StubbleResult(
        pop: true,
        err: StubbleError(
          code: errorHelperUnregistered,
          text: 'Helper "$_helper" is unregistered',
        ),
      );
    }

    final result = StubbleResult();

    try {
      if (_attributes.isEmpty) {
        _attributes.add(context.data);
      }

      result.result = context.call(_helper, _attributes, null);
      result.pop = true;
    } catch (e) {
      result.pop = true;
      result.err = StubbleError(
        text: 'Error in helper function $_helper: ${e.toString()}',
        code: errorCallingHelper,
      );
    }

    return result;
  }
}
