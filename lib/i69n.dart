import 'src/cs.dart' as cs;
import 'src/en.dart' as en;

///
/// Language specific function, which is provided with a number and should return one of possible categories.
/// count is never null.
///
typedef QuantityCategory CategoryResolver(int count, QuantityType type);

enum QuantityCategory { zero, one, two, few, many, other }

enum QuantityType { cardinal, ordinal }

abstract class I69nMessageBundle {
  Object operator [](String messageKey);
}

void registerResolver(String languageCode, CategoryResolver resolver) {
  _resolverRegistry[languageCode] = resolver;
}

///
/// Same as ordinal.
///
String plural(int count, String languageCode, {String zero, String one, String two, String few, String many, String other}) {
  return _resolvePlural(count, languageCode, QuantityType.cardinal, zero: zero, one: one, two: two, few: few, many: many, other: other);
}

///
/// See: http://cldr.unicode.org/index/cldr-spec/plural-rules
///
String cardinal(int count, String languageCode, {String zero, String one, String two, String few, String many, String other}) {
  return _resolvePlural(count, languageCode, QuantityType.cardinal, zero: zero, one: one, two: two, few: few, many: many, other: other);
}

///
/// See: http://cldr.unicode.org/index/cldr-spec/plural-rules
///
String ordinal(int count, String languageCode, {String zero, String one, String two, String few, String many, String other}) {
  return _resolvePlural(count, languageCode, QuantityType.ordinal, zero: zero, one: one, two: two, few: few, many: many, other: other);
}

Map<String, CategoryResolver> _resolverRegistry = {
  "en": en.quantityResolver,
  "cs": cs.quantityResolver,
};

String _resolvePlural(int count, String languageCode, QuantityType type, {String zero, String one, String two, String few, String many, String other}) {
  QuantityCategory c = _resolveCategory(languageCode, count, type);
  if (c == null) c = QuantityCategory.other;
  if (many == null) many = other;
  switch (c) {
    case QuantityCategory.zero:
      return _firstNotNull(zero, many);
    case QuantityCategory.one:
      return _firstNotNull(one, many);
    case QuantityCategory.two:
      return _firstNotNull(two, many);
    case QuantityCategory.few:
      return _firstNotNull(few, many);
    case QuantityCategory.many:
      return _firstNotNull(many, other);
    case QuantityCategory.other:
      return _firstNotNull(other, many);
  }
  return "???";
}

QuantityCategory _defaultResolver(int count, QuantityType type) {
  switch (count) {
    case 0:
      return QuantityCategory.zero;
    case 1:
      return QuantityCategory.one;
    case 2:
      return QuantityCategory.two;
    case 3:
      return QuantityCategory.few;
    case 4:
      return QuantityCategory.few;
  }
  return QuantityCategory.other;
}

QuantityCategory _resolveCategory(String languageCode, int count, QuantityType type) {
  if (count == null) return QuantityCategory.other;
  CategoryResolver resolver;
  if (languageCode != null) {
    resolver = _resolverRegistry[languageCode];
    if (resolver == null) {
      resolver = _defaultResolver;
    }
  } else {
    resolver = _defaultResolver;
  }
  return resolver(count, type);
}

String _firstNotNull(String a, String b) {
  if (a != null) return a;
  if (b != null) return b;
  return "???";
}
