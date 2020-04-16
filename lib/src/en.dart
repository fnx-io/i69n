import 'package:i69n/i69n.dart';

///
/// Quantity category resolver for english.
///
/// See:
///
/// https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html#en
///
///
QuantityCategory quantityResolver(int count, QuantityType type) {
  if (type == QuantityType.ordinal) return _resolveOrdinal(count);
  return _resolveCardinal(count);
}

QuantityCategory _resolveCardinal(int count) {
  switch (count) {
    case 0:
      return QuantityCategory.zero;
    case 1:
      return QuantityCategory.one;
  }
  return QuantityCategory.other;
}

QuantityCategory _resolveOrdinal(int count) {
  if (count == 0) return QuantityCategory.zero;
  var mod10 = count % 10;
  var mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) return QuantityCategory.one;
  if (mod10 == 2 && mod100 != 12) return QuantityCategory.two;
  if (mod10 == 3 && mod100 != 13) return QuantityCategory.few;
  return QuantityCategory.other;
}
