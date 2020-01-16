import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetPathState extends StubbleState {
  String path = '';
  int lastChar;

  GetPathState({this.path}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    path ??= '';

    if (charCode == chars.DOT) {
      if (path.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not start with point character',
                code: ERROR_PATH_WRONG_SPECIFIED));
      }

      path += String.fromCharCode(charCode);
    } else if ((charCode >= 48 && charCode <= 57)) {
      if (path.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not start with number character',
                code: ERROR_PATH_WRONG_SPECIFIED));
      }

      path += String.fromCharCode(charCode);
    } else if ((charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122) ||
        charCode == 95) {
      path += String.fromCharCode(charCode);
    } else if (charCode == chars.SPACE || charCode == chars.CLOSE_BRACKET) {
      if (lastChar == chars.DOT) {
        return StubbleResult(
            err: StubbleError(
                text: 'Path should not end with dot character',
                code: ERROR_PATH_WRONG_SPECIFIED));
      }
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              type: NOTIFY_PATH_RESULT, value: path, charCode: charCode));
    } else {
      return StubbleResult(
          err: StubbleError(
              code: ERROR_NOT_A_VALID_PATH_CHAR,
              text:
                  'Character "${String.fromCharCode(charCode)}" is not a valid in path'));
    }

    lastChar = charCode;

    return null;
  }
}
