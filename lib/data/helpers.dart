import 'package:stubble/stubble/Stubble.dart';

void initHelpers() {
  Stubble.registerHelper('testHelper', (List attrs, Function fn) {
    print(attrs);

    attrs.forEach((attr) {
      print('Attr value: ${attr}; Attr type: ${attr.runtimeType}');
    });

    return 'Helper executed sucessfuly';
  });

  Stubble.registerHelper('blockHelper', (List attrs, Function fn) {
    return fn({'AA': 'it', 'BB': 'works'});
  });

  Stubble.registerHelper('formatPrice', (List attrs, Function fn) {
    return '${attrs[0].toString()} \$';
  });

  Stubble.registerHelper('item_price', (List attrs, Function fn) {
    final item = attrs.first;

    if (item != null && item is Map) {
      var price = item['price'] * item['quantity'];
      return '$price \$';
    }

    return '';
  });

  Stubble.registerHelper('total_sum', (List attrs, Function fn) {
    final List items = attrs.first;
    double sum = 0;

    if (items != null && items.isNotEmpty) {
      items.forEach((item) {
        sum += item['price'] * item['quantity'];

        if (item['options'] != null && item['options'] is List) {
          item['options'].forEach((o) {
            sum += o['price'] * o['quantity'];
          });
        }
      });

    }

    return "<ds><b><row><cell>TOTAL</cell><cell align='right'>*${sum}</cell></row></b></ds><br>";
  });

  Stubble.registerHelper('order_date', (List attrs, Function fn) {
    final modified = attrs.first;

    if (modified != null && modified > 0) {
      return "<b><row><cell>Order datetime</cell><cell align='right'>${DateTime.fromMillisecondsSinceEpoch(modified).toIso8601String()}</cell></row></b><br>";
    }

    return '';
  });

  Stubble.registerHelper('bill_date', (List attrs, Function fn) {
    final modified = attrs.first;

    if (modified != null && modified > 0) {
      return "<b><row><cell>Bill datetime</cell><cell align='right'>${DateTime.fromMillisecondsSinceEpoch(modified).toIso8601String()}</cell></row></b><br>";
    }

    return '';
  });

  Stubble.registerHelper('items_list', (List attrs, Function fn) {
    final items = attrs.first;
    var res = '';

    if (items != null && items is List) {
      items.forEach((item) {
        res += fn(item) + '\n';
      });
    }

    return res;
  });

  Stubble.registerHelper('options_list', (List attrs, Function fn) {
    final options = attrs.first;
    var res = '';

    if (options != null && options is Map) {
      options.forEach((key, opt) {
        res += fn(opt) + ' ';
      });
    }

    return res;
  });

  Stubble.registerHelper('vat_list', (List attrs, Function fn) {
    var vats = {};
    var res = '';
    final items = attrs.first;

    if (items != null && items is List && items.isNotEmpty) {
      items.forEach((item) {
        if (item.vat_value > 0) {
          var vat = item['vat_value'] / 100;

          if (vats.containsKey(item['vat_value'])) {
            vats[item['vat_value']]['value'] +=
                item['price'] * item['quantity'] * vat;
          } else {
            vats[item['vat_value']] = {
              'name': item['vat_name'],
              'value': item['price'] * item['quantity'] * vat
            };
          }
        }
      });

      if (vats.isNotEmpty) {
        vats.forEach((k, vat) {
          res += fn(vat) + '\n';
        });
      }
    }

    return res;
  });
}
