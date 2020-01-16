import '../Characters.dart' as chars;
import '../StubbleContext.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class EscapeCharacterState extends StubbleState {
  EscapeCharacterState() {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    String char;
    final charCode = msg.charCode;

    if (charCode != chars.ENTER) {
      char = String.fromCharCode(charCode);
    } else {
      char = String.fromCharCode(chars.BACK_SLASH);
    }

    return StubbleResult(result: char);
  }
}
