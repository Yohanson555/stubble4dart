import './StubbleMessages.dart';
import './StubbleState.dart';
import './StubbleError.dart';

class StubbleResult {
  StubbleState state;
  bool pop;
  StubbleError err;
  String result;
  StubbleMessage message;

  StubbleResult({
    this.state,
    this.message,
    this.pop,
    this.err,
    this.result,
  });
}