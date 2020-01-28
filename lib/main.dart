/// Support for doing something awesome.
///
/// More dartdocs go here.
import 'data/example_1.dart';
import 'data/helpers.dart';

void main() {

  final s = initHelpers();

  final c = s.compile(tpl8);

  final r = c(data8);

  print(r);

  //c(data2);
}
