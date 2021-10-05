import 'package:stubble/stubble.dart';

Stubble initHelpers() {
  final s = Stubble();

  s.registerHelper('testHelper', (List attrs, Function? fn) {
    print(attrs);

    for (var attr in attrs) {
      print('Attr value: $attr; Attr type: ${attr.runtimeType}');
    }

    return 'Helper executed sucessfuly';
  });

  s.registerHelper('show', (List attrs, Function? fn) {
    return attrs.toString();
  });

  s.registerHelper('blockHelper', (List attrs, Function? fn) {
    final data = {'AA': 'it', 'BB': 'works'};
    return fn != null ? fn(data) : '';
  });

  s.registerHelper('formatPrice', (List attrs, Function? fn) {
    return '${attrs[0].toString()} \$';
  });

  s.registerHelper('item_price', (List attrs, Function? fn) {
    final item = attrs.first;

    if (item != null && item is Map) {
      var price = item['price'] * item['quantity'];
      return '$price \$';
    }

    return '';
  });

  s.registerHelper('total_sum', (List attrs, Function? fn) {
    final List items = attrs.first;
    var sum = 0.0;

    if (items.isNotEmpty) {
      for (final item in items) {
        sum += item['price'] * item['quantity'];

        if (item['options'] != null && item['options'] is List) {
          item['options'].forEach((o) {
            sum += o['price'] * o['quantity'];
          });
        }
      }
    }

    return "<ds><b><row><cell>TOTAL</cell><cell align='right'>*$sum</cell></row></b></ds><br>";
  });

  s.registerHelper('order_date', (List attrs, Function? fn) {
    final modified = attrs.first;

    if (modified != null && modified > 0) {
      return "<b><row><cell>Order datetime</cell><cell align='right'>${DateTime.fromMillisecondsSinceEpoch(modified).toIso8601String()}</cell></row></b><br>";
    }

    return '';
  });

  s.registerHelper('bill_date', (List attrs, Function? fn) {
    final modified = attrs.first;

    if (modified != null && modified > 0) {
      return "<b><row><cell>Bill datetime</cell><cell align='right'>${DateTime.fromMillisecondsSinceEpoch(modified).toIso8601String()}</cell></row></b><br>";
    }

    return '';
  });

  s.registerHelper('items_list', (List attrs, Function? fn) {
    final items = attrs.first;
    var res = '';

    if (fn != null) {
      if (items != null && items is List) {
        for (final item in items) {
          res += fn(item) + '\n';
        }
      }
    }

    return res;
  });

  s.registerHelper('options_list', (List attrs, Function? fn) {
    final options = attrs.first;
    var res = '';

    if (fn != null) {
      if (options != null && options is Map) {
        options.forEach((key, opt) {
          res += fn(opt) + ' ';
        });
      }
    }

    return res;
  });

  s.registerHelper('vat_list', (List attrs, Function? fn) {
    var vats = {};
    var res = '';
    final items = attrs.first;

    if (fn != null && items != null && items is List && items.isNotEmpty) {
      for (final item in items) {
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
      }

      if (vats.isNotEmpty) {
        vats.forEach((k, vat) {
          res += fn(vat) + '\n';
        });
      }
    }

    return res;
  });

  return s;
}
