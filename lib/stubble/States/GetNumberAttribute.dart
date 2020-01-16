import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetNumberAttribute extends StubbleState {
  var value = '';

  GetNumberAttribute({this.value}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    value ??= '';

    if (charCode == chars.CLOSE_BRACKET || charCode == chars.SPACE) {
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              charCode: charCode,
              type: NOTIFY_ATTR_RESULT,
              value: num.parse(value)));
    } else if (charCode == chars.DOT) {
      if (value.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                text: 'Number should not start with delimiter',
                code: ERROR_NUMBER_ATTRIBUTE_MALFORMED));
      } else if (value.indexOf(String.fromCharCode(chars.DOT)) > 0) {
        return StubbleResult(
            err: StubbleError(
                text: 'Duplicate number delimiter',
                code: ERROR_NUMBER_ATTRIBUTE_MALFORMED));
      }

      value += String.fromCharCode(charCode);
    } else if (charCode >= 48 && charCode <= 57) {
      value += String.fromCharCode(charCode);
    } else {
      return StubbleResult(
          err: StubbleError(
              text: 'Number attribute malformed',
              code: ERROR_NUMBER_ATTRIBUTE_MALFORMED));
    }

    return null;
  }
}
