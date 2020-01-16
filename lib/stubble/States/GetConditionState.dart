import 'package:stubble/stubble/Notify.dart';

import '../Characters.dart' as chars;
import '../Errors.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetConditionState extends StubbleState {
  String _condition = '';

  GetConditionState() {
    methods = {'process': (msg, context) => process(msg, context)};
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == chars.MORE ||
        charCode == chars.LESS ||
        charCode == chars.EQUAL ||
        charCode == chars.EXCL_MARK) {
      _condition += String.fromCharCode(charCode);
      return null;
    } else if (charCode == chars.CLOSE_BRACKET || charCode == chars.SPACE) {
      if (_condition.isEmpty) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_IF_BLOCK_CONDITION_MALFORMED,
                text: 'If block condition should not be empty'));
      } else if (_condition.length > 2) {
        return StubbleResult(
            err: StubbleError(
                code: ERROR_IF_BLOCK_CONDITION_MALFORMED,
                text: 'If block condition malformed: "$_condition"'));
      } else {
        return StubbleResult(
            pop: true,
            message: NotifyMessage(
                type: NOTIFY_CONDITION_RESULT,
                value: _condition,
                charCode: charCode));
      }
    }

    return StubbleResult(
        err: StubbleError(
            code: ERROR_GETTING_ATTRIBUTE,
            text:
                'Wrong condition character "${String.fromCharCode(charCode)}" ($charCode)'));
  }
}
