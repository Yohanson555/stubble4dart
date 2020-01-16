import './EscapeCharacterState.dart';
import './GetBlockHelperState.dart';
import './GetBlockSequenceTypeState.dart';
import './GetDataState.dart';
import './GetEachBlockState.dart';
import './GetHelperState.dart';
import './GetIfBlockState.dart';
import './GetSequenceState.dart';
import './GetWithBlockState.dart';
import './OpenBracketState.dart';
import '../Characters.dart' as chars;
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class RootState extends StubbleState {
  RootState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final res = StubbleResult();
    final charCode = msg.charCode;

    switch (charCode) {
      case chars.BACK_SLASH:
        res.state = EscapeCharacterState();
        break;
      case chars.OPEN_BRACKET:
        res.state = OpenBracketState();
        break;
      default:
        res.result = String.fromCharCode(charCode);
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
      case NOTIFY_IS_BLOCK_HELPER_SEQUENCE: // done
        res.state = GetBlockHelperState();
        break;
      case NOTIFY_IS_IF_BLOCK_SEQUENCE: // done
        res.state = GetIfBlockState();
        break;
      case NOTIFY_IS_EACH_BLOCK_SEQUENCE: // done
        res.state = GetEachBlockState();
        break;
      case NOTIFY_IS_WITH_SEQUENCE: // done
        res.state = GetWithBlockState();
        break;

      default:
        break;
    }

    return res;
  }
}
