import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetBlockNameState extends StubbleState {
  String name = '';

  GetBlockNameState({this.name}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    name ??= '';

    if (charCode >= 48 && charCode <= 57) {
      if (name.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_BLOCK_NAME_WRONG_SPECIFIED,
                text: 'Block name should not start with number character'));
      }

      name += String.fromCharCode(charCode);
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      name += String.fromCharCode(charCode);
    } else if (charCode == chars.SPACE || charCode == chars.CLOSE_BRACKET) {
      if (name.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_BLOCK_NAME_WRONG_SPECIFIED,
                text: 'Block name is empty'));
      }

      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              type: NOTIFY_NAME_RESULT, value: name, charCode: charCode));
    } else {
      return StubbleResult(
          err: StubbleError(
              code: ERROR_NOT_A_VALID_BLOCK_NAME_CHAR,
              text:
                  'Character "${String.fromCharCode(charCode)}" is not a valid in block name'));
    }

    return null;
  }
}
