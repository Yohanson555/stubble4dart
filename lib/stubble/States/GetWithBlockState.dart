import './CloseBracketState.dart';
import './GetBlockEndState.dart';
import './GetPathState.dart';
import '../Characters.dart' as chars;
import '../Errors.dart';
import '../Notify.dart';
import '../Stubble.dart';
import '../StubbleContext.dart';
import '../StubbleError.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetWithBlockState extends StubbleState {
  String _path;
  String _body;

  GetWithBlockState() {
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
        state: GetPathState(), message: ProcessMessage(charCode: charCode));
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_PATH_RESULT:
        _path = msg.value;
        return StubbleResult(message: ProcessMessage(charCode: msg.charCode));

      case NOTIFY_SECOND_CLOSE_BRACKET_FOUND:
        return StubbleResult(state: GetBlockEndState(blockName: 'with'));

      case NOTIFY_BLOCK_END_RESULT:
        _body = msg.value;
        return result(context);

      default:
        return StubbleResult(
            err: StubbleError(
                code: ERROR_UNSUPPORTED_NOTIFY,
                text:
                    'State "$runtimeType" does not support notifies of type ${msg.type}'));
    }
  }

  StubbleResult result(StubbleContext context) {
    final result = StubbleResult();

    if (_path.isEmpty) {
      result.err = StubbleError(
          text: 'Path required"${_path}"', code: ERROR_PATH_NOT_SPECIFIED);
    } else {
      try {
        final data = context.get(_path);

        if (data != null) {
          if (data is Map) {
            final fn = Stubble.compile(_body);

            return StubbleResult(
              result: fn(data),
              pop: true,
            );
          } else {
            result.err = StubbleError(
                text: '"With" block data should have "Map" type',
                code: ERROR_WITH_DATA_MALFORMED);
          }
        } else {
          result.err = StubbleError(
              text: 'Can\'t get data from context by path "${_path}"',
              code: ERROR_PATH_WRONG_SPECIFIED);
        }
      } catch (e) {
        result.err =
            StubbleError(text: e.toString(), code: ERROR_CALLING_HELPER);
      }
    }

    return result;
  }
}
