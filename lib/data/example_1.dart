const tpl1 = '''
    <center>
        <ds><b>* BILL #{{billNum}} *</b></ds>
    </center>

    <br>

    {{bill_date}}

    <br>
    
    {{{showA A }}}
''';

const tpl2 = 'Hi my name is {{person.name}}! I am {{person.age}} years old!';

const tpl3 = 'Helper result - {{\$testHelper A "tes" 12.2 person   }}';

const tpl4 =
    'Block Helper result - {{#blockHelper}} {{AA}} {{BB}}! {{/blockHelper}}';

const tpl5 =
    'With Block result - {{#with person}} {{name}} is {{age}} years old! {{/with}}';

const tpl6 =
    'Each Block test:{{#each items}}Item: {{name}} - {{\$formatPrice price}}{{/each}}';

const tpl7 = 'If Block test: {{#if 2 == 1}}true{{/if}}';

const tpl8 = '''
<br />
<center>
    <ds><b>* BILL #{{billNum}} *</b></ds>
</center>
<br>
{{\$bill_date modified}}
<br>
{{#items_list items}}
    <u>
        <row>
            <cell>{{name}}</cell>
            <cell width="3">{{quantity}}</cell>
            <cell width="8" align="right">{{\$item_price}}</cell>
        </row>
    </u>
    {{#options_list options}}
        <u>
            <row>
                <cell width="2"></cell>
                <cell>+ {{name}} {{text}}</cell>
                <cell width="8" align="right">{{\$item_price}}</cell>
            </row>
        </u>
    {{/options_list}}
{{/items_list}}

<br>
{{\$total_sum items}}
<br>
<center>
    <qr data="12347890123" size="4">
</center>
<br><br>
<center>
<bar type="1" data="12345678901" width="4" height="70" hri="1">
</center>
<br><br><br><br><br><cut>
''';

final data1 = {
  'billNum': 'a',
  'bill_date': 'b',
  'order_item': [
    {'name': 'Cola', 'price': 1.05, 'vat': 10},
    {'name': 'Burger', 'price': 2.55, 'vat': 12},
    {'name': 'French fries', 'price': 1.37, 'vat': 20}
  ]
};

final data2 = {
  'A': 'abc',
  'B': 'def',
  'C': 10010101,
  'person': {'name': 'John', 'age': 32}
};

final data3 = {
  'items': [
    {"name": "Coca Cola", "price": 1.5},
    {"name": "Chips", "price": 2.5},
    {"name": "Ice", "price": 0.5}
  ],
};

final data4 = {
  'items': {
    "10101": {"name": "Coca Cola", "price": 1.6},
    "10102": {"name": "Chips", "price": 2.6},
    "10103": {"name": "Ice", "price": 0.6}
  }
};

final data5 = {'show': '1'};

final data8 = {
  "billNum": 1234,
  "company": "ЗАО \"МОСКВА МАК-ДОНАЛДС\"",
  "address": "Москва, Волгоградский пр-кт, 24/2",
  "site": "www.MCDONALDS.ru",
  "contacts": "КОНТАКТЫ ЦЕНТР 8(495)7442999 С 9Д021",
  "orderNum": "046",
  "waiter": "Марданов К.",
  "date": "26.04.2017",
  "time": "10:03",
  "doc": "004377",
  "prihod": "0047",
  "drawer": "27",
  "fn": "8710000100388285",
  "reg": "0000338862018416",
  "smena": "0008",
  "items": [
    {
      "name": "ЛАТТЕ",
      "vat_name": "VAT 18%",
      "vat_value": 18.00,
      "price": 99.00,
      "department": 1,
      "quantity": 1
    },
    {
      "name": "КОЛА 0.5",
      "vat_name": "VAT 22%",
      "vat_value": 22.00,
      "price": 70.00,
      "department": 2,
      "quantity": 2
    },
    {
      "name": "АЙС КОФЕ",
      "vat_name": "VAT 18%",
      "vat_value": 18.00,
      "price": 100.00,
      "department": 2,
      "quantity": 1
    },
    {
      "name": "ПИР. ВИШНЯ",
      "vat_name": "VAT 10%",
      "vat_value": 10.00,
      "price": 50.00,
      "department": 4,
      "quantity": 2
    },
    {
      "name": "ЦЕЗАРЬ",
      "vat_name": "VAT 10%",
      "vat_value": 10.00,
      "price": 265.00,
      "department": 5,
      "quantity": 1
    },
    {
      "name": "БИГМАК",
      "vat_name": "VAT 18%",
      "vat_value": 18.00,
      "price": 130.00,
      "department": 3,
      "quantity": 1
    },
    {
      "name": "ФИШРОЛЛ",
      "vat_name": "VAT 18%",
      "vat_value": 18.00,
      "price": 160.00,
      "department": 3,
      "quantity": 1
    },
    {
      "name": "ЧИЗКЕЙК",
      "vat_name": "VAT 18%",
      "vat_value": 18.00,
      "price": 125.00,
      "department": 4,
      "quantity": 1
    },
    {
      "name": "КАРТ.СТД.",
      "vat_name": "VAT 22%",
      "vat_value": 22.00,
      "price": 75.00,
      "department": 6,
      "quantity": 3
    }
  ],
  "departments": {
    "1": {"id": 1, "name": "Кофе, чай"},
    "2": {"id": 2, "name": "Холодные напитки"},
    "3": {"id": 3, "name": "Сандвичи"},
    "4": {"id": 4, "name": "Десерты"},
    "5": {"id": 5, "name": "Салаты"},
    "6": {"id": 6, "name": "Картошка"}
  }
};
