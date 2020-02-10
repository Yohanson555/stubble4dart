import 'package:stubble/stubble.dart';

void main() {
  final s = Stubble();
  final template = 'Hello! I\'m {{name}}! Nice to meet you!' ;
  final data = {'name': 'Stubble'};

  final fn = s.compile(template);

  print(fn(data)); // prints "Hello! I'm Stubble! Nice to meet you!"
}