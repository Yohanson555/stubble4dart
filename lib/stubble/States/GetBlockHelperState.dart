import 'package:meta/meta.dart';

import './CloseBracketState.dart';
import './GetAttributeState.dart';
import './GetBlockEndState.dart';
import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../Stubble.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetBlockHelperState extends StubbleState {
  final String helper;
  final List<dynamic> _attributes = [];

  String _body = '';

  GetBlockHelperState({@required this.helper}) {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == chars.CLOSE_BRACKET) {
      return StubbleResult(state: CloseBracketState());
    } else if (charCode == chars.SPACE) {
      return null;
    }

    return StubbleResult(
        state: GetAttributeState(),
        message: ProcessMessage(charCode: charCode));
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return StubbleResult(state: GetBlockEndState(blockName: helper));
      case NOTIFY_ATTR_RESULT:
        _attributes.add(msg.value);

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
        }

        break;
      case NOTIFY_BLOCK_END_RESULT:
        _body = msg.value;
        return result(context);
        break;
      default:
        break;
    }

    return null;
  }

  StubbleResult result(StubbleContext context) {
    final result = StubbleResult();

    try {
      if (_attributes.isEmpty) {
        _attributes.add(context.data);
      }

      result.result = context.call(helper, _attributes, Stubble.compile(_body));
      result.pop = true;
    } catch (e) {
      result.err = StubbleError(text: e.toString(), code: ERROR_CALLING_HELPER);
    }

    return result;
  }
}
