part of stubble;

class GetIfConditionState extends StubbleState {
  dynamic leftPart;
  dynamic rightPart;
  String? condition;

  int _state = 0;

  GetIfConditionState() {
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
              code: errorUnexpectedEndOfSource,
              text: 'unexpected end of source'));
    } else if (charCode == closeBracket) {
      return StubbleResult(
          err: StubbleError(
              text: 'If block condition malformed',
              code: errorIfBlockMalformed));
    } else if (charCode == space) {
      return null;
    } else {
      switch (_state) {
        case 0:
          return StubbleResult(
            state: GetAttributeState(),
            message: ProcessMessage(charCode: charCode),
          );

        case 1:
          return StubbleResult(
            state: GetConditionState(),
            message: ProcessMessage(charCode: charCode),
          );

        case 2:
          return StubbleResult(
            state: GetAttributeState(),
            message: ProcessMessage(charCode: charCode),
          );

        default:
          return null;
      }
    }
  }

  StubbleResult? notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case notifyAttrResult:
        if (_state == 0) {
          leftPart = msg.value;
          _state++;
        } else if (_state == 2) {
          rightPart = msg.value;

          return StubbleResult(
            pop: true,
            message: NotifyMessage(
              value: checkCondition(),
              type: notifyConditionResult,
              charCode: msg.charCode,
            ),
          );
        } else {
          return StubbleResult(
              err: StubbleError(
                  text: 'If block condition malformed',
                  code: errorIfBlockMalformed));
        }

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode!));
        }

        break;

      case notifyConditionResult:
        condition = msg.value;
        _state++;

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode!));
        }

        break;

      default:
        return StubbleResult(
            err: StubbleError(
                code: errorUnsupportedNotify,
                text:
                    'State "$runtimeType" does not support notifies of type ${msg.type}'));
    }

    return null;
  }

  bool checkCondition() {
    switch (condition) {
      case '<':
        return leftPart < rightPart;
      case '<=':
        return leftPart <= rightPart;
      case '>':
        return leftPart > rightPart;
      case '>=':
        return leftPart >= rightPart;
      case '==':
        return leftPart == rightPart;
      case '!=':
        return leftPart != rightPart;
      default:
        return false;
    }
  }
}
