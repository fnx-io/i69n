import 'package:i69n/i69n.dart';

///
/// Quantity category resolver for ukrainian.
///
/// See:
///
/// https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html#uk
///
///
QuantityCategory quantityResolver(int count, QuantityType type) {
  if (type == QuantityType.ordinal) return _resolveOrdinal(count);
  return _resolveCardinal(count);
}

QuantityCategory _resolveCardinal(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;

  final fewIncludeSet = {2, 3, 4};
  final fewExcludeSet = {12, 13, 14};
  final manyIncludeSet = {5, 6, 7, 8, 9};
  final manyIncludeSet2 = {11, 12, 13, 14};

  if (mod10 == 1 && mod100 != 11) return QuantityCategory.one;
  if (fewIncludeSet.contains(mod10) && !fewExcludeSet.contains(mod100)) return QuantityCategory.few;
  if (mod10 == 0 || manyIncludeSet.contains(count) || manyIncludeSet2.contains(mod100)) return QuantityCategory.many;

  return QuantityCategory.other;
}

QuantityCategory _resolveOrdinal(int count) {
  var mod10 = count % 10;
  var mod100 = count % 100;
  if (mod10 == 3 && mod100 != 13) return QuantityCategory.few;
  return QuantityCategory.other;
}
