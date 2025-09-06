import 'package:stubble/stubble.dart';

void main() {
  final stubble = Stubble();
  
  // 示例1: 单个 '{' 和 '}' 被当作普通字符处理
  print('示例1: 单个大括号处理');
  var template = 'This is a { single opening brace and } single closing brace';
  var data = {};
  var result = stubble.compile(template)(data);
  print('模板: $template');
  print('结果: $result');
  print('');
  
  // 示例2: 混合使用单个和双大括号
  print('示例2: 混合使用单个和双大括号');
  template = 'Price is {100} dollars but {{item}} is cheaper';
  data = {'item': 'pizza'};
  result = stubble.compile(template)(data);
  print('模板: $template');
  print('结果: $result');
  print('');
  
  // 示例3: 单个 '}' 在模板中与数据替换一起使用
  print('示例3: 单个 \'}\' 与数据替换');
  template = 'Hello {{name}} } world';
  data = {'name': 'Stubble'};
  result = stubble.compile(template)(data);
  print('模板: $template');
  print('结果: $result');
  print('');
  
  // 示例4: 正常的模板替换仍然工作
  print('示例4: 正常模板替换');
  template = 'Hello {{name}}! You are {{age}} years old.';
  data = {'name': 'John', 'age': 30};
  result = stubble.compile(template)(data);
  print('模板: $template');
  print('结果: $result');
  print('');
  
  // 示例5: 块级结构仍然工作
  print('示例5: 块级结构');
  template = '{{#if show == true}}This is visible{{/if}}';
  data = {'show': true};
  result = stubble.compile(template)(data);
  print('模板: $template');
  print('结果: $result');
}