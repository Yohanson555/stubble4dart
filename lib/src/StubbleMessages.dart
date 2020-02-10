part of stubble;

/// StateMachine processes messages of different types.

abstract class StubbleMessage {
  String getName();
}

class InitMessage extends StubbleMessage {
  final dynamic value;

  InitMessage({this.value});

  @override
  String getName() => 'init';
}

class ProcessMessage extends StubbleMessage {
  final int charCode;

  @override
  String getName() => 'process';

  ProcessMessage({
    this.charCode,
  });
}

class NotifyMessage extends StubbleMessage {
  final int charCode;
  final int type;
  final dynamic value;

  @override
  String getName() => 'notify';

  NotifyMessage({
    this.charCode,
    this.type,
    this.value,
  });
}
