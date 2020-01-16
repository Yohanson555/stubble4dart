import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class OpenBracketState extends StubbleState {
  OpenBracketState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;
    final res = StubbleResult();

    switch (charCode) {
      case chars.OPEN_BRACKET:
        res.pop = true;
        res.message = NotifyMessage(
          charCode: charCode,
          type: NOTIFY_SECOND_OPEN_BRACKET_FOUND,
        );

        break;
      default:
        res.err = StubbleError(
            code: ERROR_CHAR_NOT_A_OPEN_BRACKET,
            text: 'Wrong character is given. Expected "{"');
    }

    return res;
  }
}
