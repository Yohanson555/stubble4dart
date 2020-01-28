part of stubble;

class RootState extends StubbleState {
  bool escape = false;

  RootState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final res = StubbleResult();
    final charCode = msg.charCode;

    if (escape) {
      escape = false;

      res.result = String.fromCharCode(charCode);
    } else {
      switch (charCode) {
        case BACK_SLASH:
          escape = true;
          break;
        case OPEN_BRACKET:
          res.state = OpenBracketState();
          break;
        default:
          res.result = String.fromCharCode(charCode);
      }
    }


    return res;
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    final res = StubbleResult();

    switch (msg.type) {
      case NOTIFY_SECOND_OPEN_BRACKET_FOUND: // done
        res.state = GetSequenceState();
        break;
      case NOTIFY_IS_HELPER_SEQUENCE: // done
        res.message = InitMessage();
        res.state = GetHelperState();
        break;
      case NOTIFY_IS_BLOCK_SEQUENCE: // done
        res.message = InitMessage();
        res.state = GetBlockSequenceTypeState();
        break;
      case NOTIFY_IS_DATA_SEQUENCE: // done
        res.state = GetDataState();
        res.message = InitMessage(value: msg.value);
        break;

      default:
        break;
    }

    return res;
  }
}
