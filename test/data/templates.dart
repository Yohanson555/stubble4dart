const tpl1 = '<center><ds><b>* BILL #{{billNum}} *</b></ds></center><br>{{\$bill_date bill_date}}<br>{{\$show kpp }}';

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
