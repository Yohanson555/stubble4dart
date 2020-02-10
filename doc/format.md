### Stubble constructions

`{{<path>}}` - getter for property from `data` by it's `path`. If property by this `path` is exists then `{{<path>}}` will be replaced by a string representation of its value 

`{{$<name> [<attributes>]}}` - simple helper-function call. Will be replaced by a helper's result

`{{#<name> [<attributes>]}}<body>{{/<name>}}` - block helper-function call. Also will be replaced with result of helper call. The second parameter of helper function in this case is compile function with block's  'body' as template

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


### Helper name requirements

Helper `name` is a string, starts with an alphabet character and can consist of:
- lowercase or uppercase `latin characters`
- `numbers`
- `underscore`

### Attributes requirements


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


