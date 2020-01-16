import 'package:meta/meta.dart';

import '../Characters.dart' as chars;
import '../Notify.dart';
import '../StubbleContext.dart';
import '../StubbleMessages.dart';
import '../StubbleResult.dart';
import '../StubbleState.dart';

class GetStringAttribute extends StubbleState {
  final int quoteSymbol;
  String _value = '';
  bool _escape = false;

  GetStringAttribute({@required this.quoteSymbol}) {
    methods = {
      'process': (msg, context) => process(msg, context),
    };
  }

  StubbleResult process(ProcessMessage msg, StubbleContext context) {
    final charCode = msg.charCode;

    if (charCode == quoteSymbol && !_escape) {
      return StubbleResult(
          pop: true,
          message: NotifyMessage(
              type: NOTIFY_ATTR_RESULT, value: _value, charCode: null));
    } else if (charCode == chars.BACK_SLASH && !_escape) {
      _escape = true;
    } else {
      _value += String.fromCharCode(charCode);
    }

    return null;
  }
}
