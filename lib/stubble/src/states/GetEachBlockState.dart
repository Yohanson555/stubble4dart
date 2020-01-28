part of stubble;

class GetEachBlockState extends StubbleState {
  String _path = '';
  String _body = '';

  GetEachBlockState() {
    methods = {
      'process': (msg, context) => process(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == CLOSE_BRACKET) {
      return StubbleResult(state: CloseBracketState());
    } else if (charCode == SPACE) {
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
        return StubbleResult(state: GetBlockEndState(blockName: 'each'));

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
          text: '"EACH" block requires path as parameter', code: ERROR_PATH_NOT_SPECIFIED);
    } else {
      try {
        final data = context.get(_path);

        if (data != null) {
          if (data is List || data is Map) {
            final fn = context.compile(_body);

            var res = '';

            if (data is List) {
              data.forEach((item) {
                res += fn(item);
              });
            } else {
              data.forEach((key, item) {
                res += fn(item);
              });
            }

            return StubbleResult(
              result: res,
              pop: true,
            );
          } else {
            result.err = StubbleError(
                text: '"each" block data should have "List" or "Map" type',
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
