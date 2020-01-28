`template` - строковое представление шаблона в формате `Stubble`

`Stubble.compile(string template)` - статический метод. Инициализируется строкой с шаблоном. результатом возвращает функцию для компиляции указанного шаблона `function`.

`Stubble.registerHelper("<helper name>", ([params]) { <function body> })` - регистрация новой helper-функции для использования ее в теле шаблона Stubble

`function(Map data)` - генерация шаблона с учетом data. результатом работы `function` будет сгенерированная строка по шаблону `template`

