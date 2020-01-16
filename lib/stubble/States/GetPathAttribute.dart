import './GetPathState.dart';
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetPathAttribute extends StubbleState {
  GetPathAttribute() {
    methods = {
      'init': (msg, context) => init(msg, context),
      'notify': (msg, context) => notify(msg, context),
    };
  }

  StubbleResult init(InitMessage msg, StubbleContext context) {
    final path = msg.value;

    return StubbleResult(
      state: GetPathState(path: path),
    );
  }

  StubbleResult notify(NotifyMessage msg, StubbleContext context) {
    switch (msg.type) {
      case NOTIFY_PATH_RESULT:
        return StubbleResult(
            pop: true,
            message: NotifyMessage(
              charCode: msg.charCode,
              type: NOTIFY_ATTR_RESULT,
              value: context.get(msg.value),
            ));
    }

    return null;
  }
}
