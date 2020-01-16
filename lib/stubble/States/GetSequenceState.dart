import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetSequenceState extends StubbleState {
  GetSequenceState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    final res = StubbleResult();

    if (charCode == chars.DOLLAR) {
      res.pop = true;
      res.message = NotifyMessage(
        charCode: charCode,
        type: NOTIFY_IS_HELPER_SEQUENCE,
      );
    } else if (charCode == chars.SHARP) {
      res.pop = true;
      res.message = NotifyMessage(
        charCode: charCode,
        type: NOTIFY_IS_BLOCK_SEQUENCE,
      );
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122)) {
      res.pop = true;
      res.message = NotifyMessage(
          charCode: charCode,
          type: NOTIFY_IS_DATA_SEQUENCE,
          value: String.fromCharCode(charCode));
    } else {
      res.err = StubbleError(
          code: ERROR_WRONG_SEQUENCE_CHARACTER,
          text: 'Wrong character "${String.fromCharCode(charCode)}" found');
    }

    return res;
  }
}
