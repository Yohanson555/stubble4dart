import './CloseBracketState.dart';
import './GetAttributeState.dart';
import './GetBlockNameState.dart';
import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetHelperState extends StubbleState {
  String _helper;
  List<dynamic> _attributes;

  GetHelperState() {
    methods = {
      'init': (msg, context) => init(msg, context),
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult init(InitMessage msg, StubbleContext context) {
    _helper = '';
    _attributes = [];

    return StubbleResult(state: GetBlockNameState());
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
      case NOTIFY_NAME_RESULT:
        _helper = msg.value;

        if (!context.callable(_helper)) {}

        return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return result(context);
      case NOTIFY_ATTR_RESULT:
        _attributes.add(msg.value);

        if (msg.charCode != null) {
          return StubbleResult(message: ProcessMessage(charCode: msg.charCode));
        }

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

      result.result = context.call(_helper, _attributes, null);
      result.pop = true;
    } catch (e) {
      result.err = StubbleError(
          text: 'Error in helper function ${_helper}: ${e.toString()}',
          code: ERROR_CALLING_HELPER);
    }

    return result;
  }
}
