import 'package:i69n/i69n.dart';

///
/// Quantity category resolver for czech.
///
/// See:
///
/// https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html#cs
///
///
QuantityCategory quantityResolver(int count, QuantityType type) {
  if (type == QuantityType.ordinal) return _resolveOrdinal(count);
  return _resolveCardinal(count);
}

QuantityCategory _resolveCardinal(int count) {
  switch (count) {
    case 1:
      return QuantityCategory.one;
    case 2:
      return QuantityCategory.few;
    case 3:
      return QuantityCategory.few;
    case 4:
      return QuantityCategory.few;
  }
  return QuantityCategory.other;
}

QuantityCategory _resolveOrdinal(int count) {
  return QuantityCategory.other;
}
