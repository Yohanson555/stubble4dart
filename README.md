# Stubble ![Coverage](https://raw.githubusercontent.com/Yohanson555/stubble4dart/master/coverage_badge.svg?sanitize=true)

### Overview

`Stubble` is a simplified version of the `Handlebars` template engine for Dart.

### Example

```dart
void main() {
  final s = Stubble();
  final template = 'Hello! I\'m {{name}}! Nice to meet you!' ;
  final data = {'name': 'Stubble'};

  final fn = s.compile(template);

  print(fn(data)); // prints "Hello! I'm Stubble! Nice to meet you!"
}
```

### Stubble constructions

`{{<path>}}` - getter for property from `data` by it's `path`. If property by this `path` is exists then `{{<path>}}` will be replaced by a string representation of its value 

`{{$<helper_name> [<attributes>]}}` - simple helper-function call. Will be replaced by a helper's result

`{{#<helper_name> [<attributes>]}}<body>{{/<name>}}` - block helper-function call. Also will be replaced with result of helper call. The second parameter of helper function in this case is compile function with block's  'body' as template

`{{#if <condition>}}<body>{{/if}}` - is statement block. If `<condition>` is true, will be replaced with body. Body will be compiled too.

`{{#with <path>}}<body>{{/with}}` - allows to pass a part of context data and work with it directly

`{{#each <path>}}<body>{{/each}}` - loop for a context data by path. data should has a type of `array` or `map`

### Path requirements

`path` is a string, starts with an alphabet character and can consist of:
- lowercase or uppercase `latin characters`
- `numbers`
- `underscore`
- `dot` as path divider. It's mean that `A.B.C` will return `data["A"]["B"]["C"]`, not a `data["A.B.C"]`

Other character are prohibited

Restrictions:
- Path can't begin with `dot`
- Path can't end with `dot`


### Helper functions

`Stubble` object has an registerHelper method, that allows to register special named functions that can be used in templates by names. Example:

```dart
void main() {
  final s = Stubble();
  s.registerHelper('testHelper', (List attr, Function fn) {
    return attr[0] * 10;
  });
}
  
```

Each registered function should have two parameters:
1. List of attributes. All helper functions attributes from it's call in template will be placed here in order left to right like they passed in helper call
2. Compiler function - available only in block-helper calls. The body of helper-function is a template of this compiler function. Example:

```dart
void main() {
  final s = Stubble();
  
  stubble.registerHelper('simpleBlockHelper', (List attrs, Function fn) { // fn - is a result of Stubble.compile(<template>); the <template> in this example is "{{A}}; {{B}}"
    final data = {'A': 'First', 'B': 'Second'};
    return fn(data);
  });
  
  final fn = stubble.compile('{{#simpleBlockHelper}}{{A}}; {{B}}{{/simpleBlockHelper}}');
  final res = fn({});
  
  print(res);  //will print 'First param; Second param'
}
  
```

You see? `stubble.compile()` in the last example didn't receive any context data but `{{A}}; {{B}}` was transformed to `First; Second`. Where dit he got the data? 

Helper function got this data while processing and pass it to the `fn` function.  

Also you can remove helper function with `removeHelper(String name)` by name or drop them all with `dropHelpers()` from a concrete stubble object.

### Helper name requirements

Helper `name` is a string, starts with an alphabet character and can consist of:
- lowercase or uppercase `latin characters`
- `numbers`
- `underscore`

### Attributes requirements

Each helper function call in template can have numerous of attributes declarations. 
All passed attributes will be stored in helper's `attrs` parameter. 
There is no limits in how many attributes you can pass in helper call.

There is three available types of attributes.
- `path` - is a path to data in context. if `path` is incorrect will return 'null'. Example:
```
{{$prinName data.person}}
```

- `string` - string value. should be placed in a double or single quotes. Example:
```
{{$fullName 'John' "Doe"}}
```

- `number` - number value. Can be `int` or `float`. For float use `.` symbol as a divider. Example:
```
{{$formatDate 1580193175}}
```

### IF block condition requirements

`condition` for `#if` must satisfy the following pattern - `<path><operator>(<path>|<value>)`, where:
- `<path>` - path to data in context
- `<operator>` - conditional operator. May be `==`, `!=`, `<=`, `>=`, `<`, `>`, 
- `<value>` - test value - number, string or bool: 
 - The number is specified without quotes.
 - If the number is float, then the `dot` must be used as a separator
 - String values are indicated in double or single quotes
 - For bool values, `true` or `false` values are used.

### Blocks body requirements

There are no special requirements for the body at the moment, but I think the use of special characters, as well as unprintable characters, may not affect the performance of the template engine in the best way.


