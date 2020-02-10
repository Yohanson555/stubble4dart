import 'package:stubble/stubble.dart';
import 'package:test/test.dart';

import 'data/data.dart';
import 'data/helpers.dart';
import 'data/templates.dart';

void main() {
  group('Stubble methods tests', () {
    Function compiler;
    final stubble = Stubble();

    test('Creating a compiller with empty template', () {
      expect(
          () => stubble.compile(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Can\'t create compiller with empty template')));
    });

    test('Creating a stubble machine with empty template', () {
      var sm = new StubbleMachine(null);

      expect(sm.run(null), '');
    });

    test('Creating a compiller with non empty template', () {
      compiler = stubble.compile('Test template');

      expect(compiler is Function, true);
    });

    test('Test compilation with previous compiler function', () {
      expect(compiler({}), 'Test template');
    });

    test('Registering a new helper function with null name and null function',
        () {
      expect(
          () => stubble.registerHelper(null, null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Helper\'s name should be provided')));
    });

    test('Registering a new helper function with empty name and null function',
        () {
      expect(
          () => stubble.registerHelper('', null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Helper\'s name should be provided')));
    });

    test('Registering a new helper function with wrong name specified #1', () {
      expect(
          () => stubble.registerHelper('555SaveMe', null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Wrong helper name specified')));
    });

    test('Registering a new helper function with wrong name specified #2', () {
      expect(
          () => stubble.registerHelper('Let\'s get party started', null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Wrong helper name specified')));
    });

    test('Registering a new helper function with wrong name specified #3', () {
      expect(
          () => stubble.registerHelper(')(*&%#', null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Wrong helper name specified')));
    });

    test('Registering a new helper function null function', () {
      expect(
          () => stubble.registerHelper('testHelper', null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Helper\'s function should be provided')));
    });

    test('No helpers', () {
      stubble.dropHelpers();
      expect(stubble.helperCount, 0);
    });

    test('Registering a new correct helper function', () {
      final res =
          stubble.registerHelper('testHelper', (List attr, Function fn) {});

      expect(res, true);
      expect(stubble.helperCount, 1);
    });

    test('Registering a helper function with exist name', () {
      final res =
          stubble.registerHelper('testHelper', (List attr, Function fn) {});

      expect(res, false);
      expect(stubble.helperCount, 1);
    });

    test('Registering another helper function', () {
      final res =
          stubble.registerHelper('testHelper2', (List attr, Function fn) {});

      expect(res, true);
      expect(stubble.helperCount, 2);
    });

    test('Registering third helper', () {
      final res =
          stubble.registerHelper('testHelper3', (List attr, Function fn) {});

      expect(res, true);
      expect(stubble.helperCount, 3);
    });

    test('Removing helper function with name testHelper2', () {
      final res = stubble.removeHelper('testHelper2');

      expect(res, true);
      expect(stubble.helperCount, 2);
    });

    test('Trying to remove already removed helper', () {
      final res = stubble.removeHelper('testHelper2');

      expect(res, false);
    });

    test('Drop all helpers test', () {
      stubble.dropHelpers();
      expect(stubble.helperCount, 0);
    });
  });

  group('Stubble context tests', () {
    test('Empty context', () {
      final context = StubbleContext(null, null);

      expect(context.data, null);
      expect(context.helpers, null);
      expect(context.callable('testHelper'), false);
      expect(context.get('name'), null);
    });

    test('Context get() test', () {
      final data = {
        'name': 'John',
        'age': 32,
        'languages': ['JavaScript', 'Dart', 'Go', 'Html', 'Css', 'Php'],
        'birth': {
          'city': 'St. Petersburg',
          'year': 1987,
          'month': 1,
          'day': 19,
          'weight': 4.78,
          'mother': {'name': 'Elena'}
        }
      };
      final context = StubbleContext(data, null);

      expect(context.get('name'), 'John');
      expect(context.get('age'), 32);
      expect(context.get('languages') is List, true);
      expect(context.get('birth') is Map, true);
      expect(context.get('birth.city'), 'St. Petersburg');
      expect(context.get('birth.year'), 1987);
      expect(context.get('birth.weight'), 4.78);
      expect(context.get('birth.mother') is Map, true);
      expect(context.get('birth.mother.name'), 'Elena');
      expect(context.get('birth.mother.lname'), null);
      expect(context.get('Name'), null);
    });

    test('Calling existing helper', () {
      final Map<String, Function(List<dynamic>, Function)> helpers = {};

      helpers['simple'] = (List attrs, Function fn) {
        return 'Helper result';
      };

      final context = StubbleContext(null, helpers);

      expect(context.call('simple', null, null), 'Helper result');
    });

    test('Calling existing helper with attributes #1', () {
      final Map<String, Function(List<dynamic>, Function)> helpers = {};

      helpers['simple'] = (List attrs, Function fn) {
        return 'Number of attributes is ${attrs.length}';
      };

      final context = StubbleContext(null, helpers);

      expect(context.call('simple', [1, 'String attr', {}, false], null),
          'Number of attributes is 4');
    });

    test('Calling existing helper with attributes #2', () {
      final Map<String, Function(List<dynamic>, Function)> helpers = {};

      helpers['simple'] = (List attrs, Function fn) {
        return 'Second attribute is ${attrs[1]}';
      };

      final context = StubbleContext(null, helpers);

      expect(context.call('simple', [1, 'String attr', {}, false], null),
          'Second attribute is String attr');
    });

    test('check for callable non-existing helper', () {
      var context = StubbleContext(null, null);
      expect(context.callable('simple'), false);
    });

    test('Calling helper withh no name given', () {
      final context = StubbleContext(null, null);

      expect(
          () => context.call('', null, null),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == 'Exception: Helper name not specified')));
    });

    test('Calling non-existing helper', () {
      final Map<String, Function(List<dynamic>, Function)> helpers = {};
      final context = StubbleContext(null, helpers);

      expect(
          () => context.call('simple', null, null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() == 'Exception: Helper "simple" is not registered')));
    });

    test('Try getting non-existing option', () {
      final context = StubbleContext();
      final o = context.opt('meaning-if-life');

      expect(o, null);
    });
  });

  group('Path templates test', () {
    final stubble = Stubble();

    test('Simple single line template', () {
      final tpl = 'Sigle line template without any sequences';
      final data = null;

      final compile = stubble.compile(tpl);
      final res = compile(data);

      expect(res, tpl);
    });

    test('Simple multyline template', () {
      final tpl = '''
      First line
      Second line
      ''';
      final data = null;

      final compile = stubble.compile(tpl);
      final res = compile(data);

      expect(res, tpl);
    });

    test('Correct path insert template', () {
      final compile = stubble.compile('Everything is {{state}}');

      expect(compile({'state': 'good'}), 'Everything is good');
      expect(compile({'state': 'bad'}), 'Everything is bad');
      expect(compile({'state1': 'bad'}), 'Everything is ');
      expect(compile(null), 'Everything is ');
      expect(compile({'state': ''}), 'Everything is ');
      expect(compile({'state': null}), 'Everything is ');
      expect(compile({'state': 123}), 'Everything is 123');
      expect(compile({'state': 123.343}), 'Everything is 123.343');
      expect(compile({'state': 123.343}), 'Everything is 123.343');
    });

    test('Incorrect path insert template #1', () {
      expect(
          () => stubble.compile('Everything is {{ state }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character " " found')));
    });

    test('Incorrect path insert template #2', () {
      expect(
          () => stubble.compile('Everything is {{123state }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character "1" found')));
    });

    test('Incorrect path insert template #3', () {
      expect(
          () => stubble.compile('Everything is {{_state }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character "_" found')));
    });

    test('Incorrect path insert template #4', () {
      expect(
          () => stubble.compile('Everything is {{^(*)} }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character "^" found')));
    });

    test('Incorrect path insert template #5', () {
      expect(
          () => stubble.compile('Everything is {{ }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character " " found')));
    });

    test('Incorrect path insert template #6', () {
      expect(
          () => stubble.compile('Everything is {{}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (5) on 1:16 Wrong character "}" found')));
    });

    test('Incorrect path insert template #7', () {
      expect(
          () => stubble.compile('Everything is {{A B}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (6) on 1:18 Wrong character "B" found')));
    });

    test('Incorrect path insert template #8', () {
      expect(
          () => stubble.compile('Everything is {A}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (1) on 1:15 Wrong character is given. Expected "{"')));
    });

    test('Incorrect path insert template #9', () {
      expect(
          () => stubble.compile('Everything is {{A} asd')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (2) on 1:18 Wrong character is given. Expected "}"')));
    });

    test('Nested path test', () {
      final data = {
        'person': {'name': 'John', 'lname': 'Saigachenko', 'age': 33}
      };

      expect(stubble.compile('{{person.name}}')(data), 'John');
      expect(stubble.compile('{{person.lname}}')(data), 'Saigachenko');
      expect(stubble.compile('{{person.age}}')(data), '33');
      expect(stubble.compile('{{person.dog}}')(data), '');
    });

    test('Wrong path test #1: starts with dot', () {
      expect(
          () => stubble.compile('{{#with .someValue}}{{/#with}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (7) on 1:8 Path should not start with point character')));
    });

    test('Wrong path test #2: ends with dot', () {
      expect(
          () => stubble.compile('{{#with someValue.}}{{/#with}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (7) on 1:18 Path should not end with dot character')));
    });

    test('Wrong path test #3: starts with number', () {
      expect(
          () => stubble.compile('{{#with 123someValue}}{{/with}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (7) on 1:8 Path should not start with number character')));
    });

    test('Correct templates', () {
      expect(stubble.compile('{{A}}')({'A': 'Ok'}), 'Ok');
      expect(stubble.compile('{{A1}}')({'A1': 'Ok'}), 'Ok');
      expect(stubble.compile('{{A_B}}')({'A_B': 'Ok'}), 'Ok');
      expect(stubble.compile('{{A_}}')({'A_': 'Ok'}), 'Ok');
      expect(stubble.compile('{{A }}')({'A': 'Ok'}), 'Ok');
    });

    test('Escaping test', () {
      expect(stubble.compile('\\{ {{A}} \\}')({'A': 'Ok'}), '{ Ok }');
    });
  });

  group('Simple handlers templates test', () {
    final stubble = Stubble();

    stubble.registerHelper('simpleHelper', (List attrs, Function fn) {
      return 'Simple helper result';
    });

    stubble.registerHelper('_simpleHelper', (List attrs, Function fn) {
      return 'Simple helper with first start slash result';
    });

    stubble.registerHelper('simpleHelper_', (List attrs, Function fn) {
      return 'Simple helper with last start slash result';
    });

    stubble.registerHelper('attrCountHelper', (List attrs, Function fn) {
      return 'Attrs count: ${attrs.length}';
    });

    stubble.registerHelper('attrByNum', (List attrs, Function fn) {
      final index = attrs.first;

      if (index == null) {
        throw Exception('Index is undefined');
      }

      if (!(index is int)) {
        throw Exception('Index is not an int');
      }

      return 'Attrs is: ${attrs[index]}';
    });

    stubble.registerHelper('attrByNum2', (List attrs, Function fn) {
      final index = attrs.first;

      if (index == null) {
        throw Exception('Index is undefined');
      }

      if (!(index is int)) {
        throw Exception('Index is not an int');
      }

      return 'Attrs is: ${attrs[index]}';
    });

    test('Non-block helper call without registering it', () {
      expect(
          () => stubble.compile('{{\$helperName}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (18) on 1:14 Helper "helperName" is unregistered')));
    });

    test(
        'Non-block helper call without registering it and "ignoreUnregisteredHelperErrors" option on',
        () {
      final st = Stubble({'ignoreUnregisteredHelperErrors': true}, null);

      expect(st.compile('A {{\$helperName}} B')(null), 'A  B');
    });

    test('assert.equal non-block helper call without attributes #1', () {
      expect(stubble.compile('{{\$simpleHelper}}')({}), 'Simple helper result');
    });

    test('Correct non-block helper call without attributes #1', () {
      expect(stubble.compile('{{\$simpleHelper}}')({}), 'Simple helper result');
    });

    test('Correct non-block helper call without attributes #2', () {
      expect(stubble.compile('{{\$_simpleHelper}}')({}),
          'Simple helper with first start slash result');
    });

    test('Correct non-block helper call without attributes #3', () {
      expect(stubble.compile('{{\$simpleHelper_}}')({}),
          'Simple helper with last start slash result');
    });

    test('Correct non-block helper call with attributes #1', () {
      expect(stubble.compile('{{\$attrCountHelper "first" 23 10.01 }}')({}),
          'Attrs count: 3');
    });

    test('Correct non-block helper call with attributes #2', () {
      expect(
          stubble.compile('{{\$attrCountHelper path "first" 23 10.01 }}')({}),
          'Attrs count: 4');
    });

    test('Correct non-block helper call with attributes #3', () {
      expect(stubble.compile('{{\$attrByNum 0 "first" 23 10.01 }}')({}),
          'Attrs is: 0');
      expect(stubble.compile('{{\$attrByNum 1 "first" 23 10.01 }}')({}),
          'Attrs is: first');
      expect(stubble.compile('{{\$attrByNum 2 "first" 23 10.01 }}')({}),
          'Attrs is: 23');
      expect(stubble.compile('{{\$attrByNum 3 "first" 23 10.01 }}')({}),
          'Attrs is: 10.01');
    });

    test('Calling "attrByNum" helper with out attributes', () {
      expect(
          () => stubble.compile('{{\$attrByNum}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (9) on 1:13 Error in helper function attrByNum: Exception: Index is undefined')));
    });

    test('Calling "attrByNum" helper with wrong index specified', () {
      expect(
          () => stubble.compile('{{\$attrByNum 21.2}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (9) on 1:18 Error in helper function attrByNum: Exception: Index is not an int')));
    });

    test('Wrong helper call #1', () {
      expect(
          () => stubble.compile('{{\$ attrByNum}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (8) on 1:3 Block name is empty')));
    });

    test('Wrong helper call #2', () {
      expect(
          () => stubble.compile('{{\$123attrByNum}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (8) on 1:3 Block name should not start with number character')));
    });

    test('Wrong helper call #2.5', () {
      expect(
          () => stubble.compile('{{\$attrByNum123}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (18) on 1:16 Helper "attrByNum123" is unregistered')));
    });

    test('Wrong helper call #3', () {
      expect(
          () => stubble.compile('{{\$#attrByNum}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (3) on 1:3 Character "#" is not a valid in block name')));
    });

    test('Рelper call with wrong number param #1', () {
      expect(
          () => stubble.compile('{{\$attrByNum 0.23.1 }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (11) on 1:17 Duplicate number delimiter')));
    });

    test('Рelper call with wrong number param #2', () {
      expect(
          () => stubble.compile('{{\$attrByNum 0.23A }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (11) on 1:17 Number attribute malformed')));
    });

    test('Helper call with wrong string param with brackets', () {
      expect(
          () => stubble.compile('{{\$attrByNum "test{" }}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (19) on 1:18 Wrong attribute value character "{"')));
    });

    test('Helper call with wrong string param with brackets', () {
      final res = stubble.compile('{{\$attrByNum 1 "test\\{" }}')(null);

      expect(res, 'Attrs is: test{');
    });
  });

  group('Block handlers templates test', () {
    final stubble = Stubble();

    stubble.registerHelper('errorHelper', (List attrs, Function fn) {
      throw Exception('Helper error!');
    });

    stubble.registerHelper('simpleBlockHelper', (List attrs, Function fn) {
      final data = {'A': 'First param', 'B': 'Second param'};

      return fn(data);
    });

    stubble.registerHelper('manyStrings', (List attrs, Function fn) {
      int count = attrs.first;
      count ??= 1;

      var res = '';

      for (var i = 0; i < count; i++) {
        res += fn({'index': i + 1}) + ';';
      }

      return res;
    });

    stubble.registerHelper('multyStrings', (List attrs, Function fn) {
      int count = attrs[0];
      int multy = attrs[1];

      var res = '';

      for (var i = 0; i < count; i++) {
        res += fn({"index": i + 1, "multy": multy}) + ';';
      }

      return res;
    });

    stubble.registerHelper('multiply', (List attrs, Function fn) {
      int A = attrs[0];
      int B = attrs[1];

      return (A * B).toString();
    });

    stubble.registerHelper('ABC', (List attrs, Function fn) {
      return fn({});
    });

    stubble.registerHelper('abc', (List attrs, Function fn) {
      return fn({'name': 'John'});
    });

    test('Calling simple block helper #1', () {
      expect(
          stubble.compile(
              '{{#simpleBlockHelper}}{{A}}; {{B}}{{/simpleBlockHelper}}')({}),
          'First param; Second param');
    });

    test('Calling simple block helper #2', () {
      expect(
          stubble.compile(
              '{{#simpleBlockHelper}}{{A}}; {{B}}{{/simpleBlockHelper}}')({}),
          'First param; Second param');
    });

    test('Calling simple block helper with attrs', () {
      expect(
          stubble.compile(
              '{{#manyStrings 3}}{{index}}. String number {{index}}{{/manyStrings}}')({}),
          '1. String number 1;2. String number 2;3. String number 3;');
    });

    test('Calling simple block helper with attrs and inner helper calls', () {
      expect(
          stubble.compile(
              '{{#multyStrings 3 2}}{{index}}. String number {{\$multiply index multy}}{{/multyStrings}}')({}),
          '1. String number 2;2. String number 4;3. String number 6;');
    });

    test('Calling non registered block helper', () {
      expect(
          () => stubble.compile('{{#getPrice 3 2}}{{price}}}{{/getPrice}}')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (18) on 1:39 Helper "getPrice" is unregistered')));
    });

    test('Calling block helper that throws an error', () {
      expect(
          () => stubble
              .compile('{{#errorHelper 3 2}}{{price}}}{{/errorHelper}}')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (9) on 1:45 Helper "errorHelper" error: Exception: Helper error!')));
    });

    test('Unterminatred block helper #1', () {
      expect(
          () => stubble.compile(
              '{{#multyStrings 3 2}}{{index}}. String number {{\$multiply index multy}}{{/multyStrings')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:85 Unterminated block helper "multyStrings" at 1:15')));
    });

    test('Unterminatred block helper #2', () {
      expect(
          () => stubble
              .compile('{{#multyStrings 3 2}}{{index}}. String number')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:44 Unterminated block helper "multyStrings" at 1:15')));
    });

    test('Unterminatred block helper #3', () {
      expect(
          () => stubble.compile('{{#multyStrings 3 ')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:17 Unterminated block helper "multyStrings" at 1:15')));
    });

    test(
        'Calling simple block helper with "ignoreTagCaseSensetive" option == true',
        () {
      stubble.setOption('ignoreTagCaseSensetive', true);

      expect(
          stubble.compile(
              '{{#simpleBlockHelper}}{{A}}; {{B}}{{/SimpleBlockHelper}}')({}),
          'First param; Second param');

      stubble.setOption('ignoreTagCaseSensetive', false);
    });

    test('Calling nested block helpers', () {
      expect(
          stubble.compile(
              '{{#ABC}}My name is {{#abc}}{{name}}{{/abc}}{{/ABC}}')({}),
          'My name is John');
    });

    test('Calling block helpers with escaped characters', () {
      expect(stubble.compile('{{#ABC}}My name is \\!{{/ABC}}')({}),
          'My name is !');
    });
  });

  group('Block IF templates test', () {
    final stubble = Stubble();

    /// correct if blocks

    test('If block test #1', () {
      final tpl = '{{#if A == 10}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #2', () {
      final tpl = '{{#if A != 9}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #3', () {
      final tpl = '{{#if A == 9}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, '');
    });

    test('If block test #4', () {
      final tpl = '{{#if A >= 10}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #5', () {
      final tpl = '{{#if A <= 10}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #6', () {
      final tpl = '{{#if A > 10}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, '');
    });

    test('If block test #7', () {
      final tpl = '{{#if A > 9}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #8', () {
      final tpl = '{{#if A < 11}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #9', () {
      final tpl = '{{#if A < 10}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, '');
    });

    test('If block test #10 - no condition', () {
      final tpl = '{{#if}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, '');
    });

    test('If block test #11 - no condition', () {
      final tpl = '{{#if 1 == 1}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    test('If block test #12 - no condition', () {
      final tpl = '{{#if "yes" == "yes"}}true{{/if}}';
      final res = stubble.compile(tpl)({'A': 10});

      expect(res, 'true');
    });

    /// incorrect if blocks
    ///
    test('Wrong IF block #1', () {
      final tpl = '{{#if !}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (10) on 1:6 Wrong attribute character "!"')));
    });

    test('Wrong IF block #2', () {
      final tpl = '{{#if A}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (15) on 1:7 If block condition malformed')));
    });

    test('Wrong IF block #3', () {
      final tpl = '{{#if A=}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (4) on 1:7 Character "=" is not a valid in path')));
    });

    test('Wrong IF block #4', () {
      final tpl = '{{#if A ==}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (15) on 1:10 If block condition malformed')));
    });

    test('Wrong IF block #5', () {
      final tpl = '{{#if A === B}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (16) on 1:11 If block condition malformed: "==="')));
    });

    test('Wrong IF block #6', () {
      final tpl = '{{#if A ?? B}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (10) on 1:8 Wrong condition character "?" (63)')));
    });

    test('Wrong IF block #7', () {
      final tpl = '{{#if "A\' == "B"}}result{{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (10) on 1:14 Wrong condition character "B" (66)')));
    });

    test('Wrong IF block #8', () {
      var tpl = '{{#if "A" == "A"}} {{&apple}} {{/if}}';

      expect(
          () => stubble.compile(tpl)(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (15) on 1:36 If block error: Exception: Error (5) on 1:3 Wrong character "&" found')));
    });
  });

  group('Block WITH templates test', () {
    final stubble = Stubble();

    test('Correct simple block', () {
      final data = {
        'person': {'fname': 'John', 'sname': 'Saigachenko'}
      };

      final tpl = '{{#with person}}{{fname}} {{sname}}{{/with}}';
      final res = stubble.compile(tpl)(data);

      expect(res, 'John Saigachenko');
    });

    test('With block with empty path', () {
      expect(
          () => stubble.compile('{{#with}}{{fname}} {{sname}}{{/with}}')(null),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (13) on 1:36 With block required path to context data')));
    });

    test('With block data of wrong type', () {
      expect(
          () => stubble.compile('{{#with person}}{{fname}} {{sname}}{{/with}}')(
              {'person': 'John'}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (14) on 1:43 "With" block data should have "Map" type')));
    });

    test('With block wrong path ', () {
      expect(
          () => stubble.compile('{{#with Person}}{{fname}} {{sname}}{{/with}}')(
              {'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (7) on 1:43 Can\'t get data from context by path "Person"')));
    });

    test('Unterminated WITH block test #1', () {
      expect(
          () => stubble.compile('{{#with Person}}{{fname}} {{sname}}{{/with}')(
              {'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:42 Unterminated "WITH" block at 1:7')));
    });

    test('Unterminated WITH block test #2', () {
      expect(
          () => stubble.compile('{{#with Person}}{{fname}} {{sname}}{{/wi')(
              {'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:39 Unterminated "WITH" block at 1:7')));
    });

    test('Unterminated WITH block test #3', () {
      expect(
          () => stubble
              .compile('{{#with Person}}{{fname}} {{sname}')({'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:33 Unterminated "WITH" block at 1:7')));
    });

    test('Unterminated WITH block test #4', () {
      expect(
          () => stubble.compile('{{#with Person')({'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:13 Unterminated "WITH" block at 1:7')));
    });

    test('Unterminated WITH block test #5', () {
      expect(
          () => stubble.compile('{{#with Perso')({'person': {}}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:12 Unterminated "WITH" block at 1:7')));
    });

    test('WITH block with malformed body', () {
      expect(
          () => stubble.compile('{{#with Person}} Some info {{&?A} {{/with}}')({ 'Person': { 'A': 21 } }),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (9) on 1:42 Exception: Error (5) on 1:13 Wrong character "&" found')));
    });
  });

  group('Block EACH templates test', () {
    final stubble = Stubble();

    test('Simple EACH call', () {
      final tpl = '{{#each A}}{{num}};{{/each}}';
      final data = {
        'A': [
          {'num': 1},
          {'num': 2},
          {'num': 3},
          {'num': 4},
        ]
      };

      expect(stubble.compile(tpl)(data), '1;2;3;4;');
    });

    test('Calling EACH block without path', () {
      expect(
          () => stubble.compile('{{#each}}{{num}};{{/each}}')({
                'A': [
                  {'num': 1},
                  {'num': 2},
                  {'num': 3},
                  {'num': 4},
                ]
              }),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (13) on 1:25 "EACH" block requires path as parameter')));
    });

    test('Calling EACH block with wrong param', () {
      expect(
          () => stubble
              .compile('{{#each A}}{{num}};{{/each}}')({'A': 'some string'}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (14) on 1:27 "each" block data should have "List" or "Map" type')));
    });

    test('Calling EACH block with absent param', () {
      expect(
          () => stubble.compile('{{#each B}}{{num}};{{/each}}')({'A': []}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (7) on 1:27 Can\'t get data from context by path "B"')));
    });

    test('Calling unterminated EACH block test #1', () {
      expect(
          () => stubble.compile('{{#each B}}{{num}};{{/each}')({'A': []}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:26 Unterminated "EACH" block at 1:7')));
    });

    test('Calling unterminated EACH block test #2', () {
      expect(
          () => stubble.compile('{{#each B}}{{num}};{{/')({'A': []}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:21 Unterminated "EACH" block at 1:7')));
    });

    test('Calling unterminated EACH block test #3', () {
      expect(
          () => stubble.compile('{{#each B}}{{num}}')({'A': []}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:17 Unterminated "EACH" block at 1:7')));
    });

    test('Calling unterminated EACH block test #4', () {
      expect(
          () => stubble.compile('{{#each B')({'A': []}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:8 Unterminated "EACH" block at 1:7')));
    });

    test('Calling malformed EACH block', () {
      expect(
          () => stubble.compile('{{#each B}} {{!name} {{/each}}')({ 'B': [{ 'name': 1 }, { 'name': 2 }, { 'name': 3 }] }),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (9) on 1:29 Exception: Error (5) on 1:3 Wrong character "!" found')));
    });
  });

  group('Production tests', () {
    test('tpl1 - data1', () {
      final stubble = initHelpers();

      expect(stubble.compile(tpl1)(data1),
          "<center><ds><b>* BILL #123 *</b></ds></center><br><b><row><cell>Bill datetime</cell><cell align=\'right\'>1970-01-19T09:38:03.595</cell></row></b><br><br>[123123123]");
    });
  });

  group('GetBlockNameState tests', () {
    final stubble = Stubble();

    test('GetBlockNameState EOS', () {
      expect(
          () => stubble.compile('{{#eac')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (20) on 1:5 block name error: unexpected end of source')));
    });

    test('GetConditionState EOS', () {
      expect(
          () => stubble.compile('{{#if A =')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (20) on 1:8 IF condition error: unexpected end of source')));
    });

    test('GetDataState EOS', () {
      expect(
          () => stubble.compile('{{adf')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (20) on 1:4 unexpected end of source')));
    });

    test('GetIfBlockState EOS', () {
      expect(
          () => stubble.compile('{{#if ')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (17) on 1:5 Unterminated "IF" block at 1:5')));
    });

    test('GetIfConditionState EOS', () {
      expect(
          () => stubble.compile('{{#if A ==')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (20) on 1:9 IF condition error: unexpected end of source')));
    });

    test('GetIfConditionState EOS', () {
      expect(
          () => stubble.compile('{{#if A == ')({}),
          throwsA(predicate((e) =>
              e is Exception &&
              e.toString() ==
                  'Exception: Error (20) on 1:10 unexpected end of source')));
    });
  });
}
