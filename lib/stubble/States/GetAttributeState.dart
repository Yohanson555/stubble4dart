import './GetNumberAttribute.dart';
import './GetPathAttribute.dart';
import './GetStringAttribute.dart';
import '../Characters.dart' as chars;
import '../Errors.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetAttributeState extends StubbleState {
  GetAttributeState() {
    methods = {'process': (msg, context) => process(msg, context)};
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == chars.QUOTE || charCode == chars.SINGLE_QUOTE) {
      return StubbleResult(
        pop: true,
        state: GetStringAttribute(quoteSymbol: charCode),
      );
    } else if (charCode >= 48 && charCode <= 57) {
      return StubbleResult(
          pop: true,
          state: GetNumberAttribute(),
          message: ProcessMessage(charCode: charCode));
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      return StubbleResult(
        pop: true,
        message: InitMessage(value: String.fromCharCode(charCode)),
        state: GetPathAttribute(),
      );
    }
    return StubbleResult(
        err: StubbleError(
            code: ERROR_GETTING_ATTRIBUTE,
            text:
                'Wrong attribute character "${String.fromCharCode(charCode)}"'));
  }
}
