part of stubble;

class GetIfConditionState extends StubbleState {
  dynamic leftPart;
  dynamic rightPart;
  String condition;

  int _state = 0;

  GetIfConditionState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == CLOSE_BRACKET) {
      return StubbleResult(
          err: StubbleError(
              text: 'If block condition malformed',
              code: ERROR_IF_BLOCK_MALFORMED));
    } else if (charCode == SPACE) {
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
          break;

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

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_ATTR_RESULT:
        if (_state == 0) {
          leftPart = msg.value;
          _state++;
        } else if (_state == 2) {
          rightPart = msg.value;

          return StubbleResult(
            pop: true,
            message: NotifyMessage(
              value: checkCondition(),
              type: NOTIFY_CONDITION_RESULT,
              charCode: msg.charCode,
            ),
          );
        } else {
          return StubbleResult(
              err: StubbleError(
                  text: 'If block condition malformed',
                  code: ERROR_IF_BLOCK_MALFORMED));
        }

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
        }

        break;
        
      case NOTIFY_CONDITION_RESULT:
        condition = msg.value;
        _state++;

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
        }

        break;

      default:
        return StubbleResult(
            err: StubbleError(
                code: ERROR_UNSUPPORTED_NOTIFY,
                text:
                    'State "$runtimeType" does not support notifies of type ${msg.type}'));
    }
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
