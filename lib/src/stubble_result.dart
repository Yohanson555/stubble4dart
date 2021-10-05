part of stubble;

/// Describes results of message processing
class StubbleResult {
  StubbleState? state;
  bool? pop;
  StubbleError? err;
  String? result;
  StubbleMessage? message;

  StubbleResult({
    this.state,
    this.message,
    this.pop,
    this.err,
    this.result,
  });
}
