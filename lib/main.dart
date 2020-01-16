/// Support for doing something awesome.
///
/// More dartdocs go here.
library stubble;

import 'data/example_1.dart';
import 'data/helpers.dart';
import 'stubble/Stubble.dart';

void main() {
  initHelpers();

  final c = Stubble.compile(tpl8);

  final r = c(data8);

  print(r);


  //c(data2);
}
