part of stubble;

class StubbleState {
  /// available method for processing.
  /// Each method function should have two params: <StubbleMessage msg, StubbleContext context>
  /// For a state to process a message of concrete type, it must implement a method with key of Message.getName() value.
  Map<String, Function> methods = {};

  /// Checks if state can accept messages of this type.
  bool canAcceptMessage(StubbleMessage msg) {
    final messageName = msg.getName();

    if (methods[messageName] != null) {
      return true;
    }

    return false;
  }

  /// Processing message
  StubbleResult? processMessage(StubbleMessage msg, StubbleContext context) {
    final messageName = msg.getName();

    if (methods[messageName] != null) {
      return methods[messageName]!(msg, context);
    }

    return null;
  }
}
