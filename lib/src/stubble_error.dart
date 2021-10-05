part of stubble;

/// error object, that can be returned by message in StubbleResult
class StubbleError {
  final int code;
  final String text;

  StubbleError({required this.code, required this.text});
}
