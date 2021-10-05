part of stubble;

class RootState extends StubbleState {
  bool escape = false;

  RootState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult? process(ProcessMessage msg, StubbleContext context) {
    final res = StubbleResult();
    final charCode = msg.charCode;

    if (charCode == eos) return null;

    if (escape) {
      escape = false;

      res.result = String.fromCharCode(charCode);
    } else {
      switch (charCode) {
        case backSlash:
          escape = true;
          break;
        case openBracket:
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
      case notifySecondOpenBracketFound: // done
        res.state = GetSequenceState();
        break;
      case notifyIsHelperSequence: // done
        res.message = InitMessage();
        res.state = GetHelperState();
        break;
      case notifyIsBlockSequence: // done
        res.message = InitMessage();
        res.state = GetBlockSequenceTypeState();
        break;
      case notifyIsDataSequence: // done
        res.state = GetDataState();
        res.message = InitMessage(value: msg.value);
        break;
    }

    return res;
  }
}
