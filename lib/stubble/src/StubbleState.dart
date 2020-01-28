part of stubble;

class StubbleState {
  Map<String, Function> methods = {};

  bool canAcceptMessage(StubbleMessage msg) {
    if (msg != null) {
      final messageName = msg.getName();

      if (methods[messageName] != null) {
        return true;
      }
    }

    return false;
  }

  StubbleResult processMessage(StubbleMessage msg, StubbleContext context) {
    if (msg != null) {
      final messageName = msg.getName();

      if (methods[messageName] != null) {
        return methods[messageName](msg, context);
      }
    }

    return null;
  }
}