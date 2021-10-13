part of i69n;

class ClassMeta {
  ClassMeta? parent;
  bool? isDefault;
  String? defaultObjectName;
  String? defaultFileName;
  String? objectName;
  String? localeName;
  String? languageCode;

  ClassMeta nest(String namePrefix) {
    var result = ClassMeta();
    result.parent = this;
    result.isDefault = isDefault;
    result.defaultObjectName = '$namePrefix$defaultObjectName';
    result.objectName = '$namePrefix$objectName';
    result.localeName = localeName;
    result.languageCode = languageCode;
    return result;
  }
}

class TodoItem {
  ClassMeta meta;
  Set<String>? flags;
  YamlMap content;
  TodoItem? parent;
  String? prefix;

  String? get path => parent == null ? meta.languageCode : '${parent!.path}.$prefix';

  bool hasFlag(String flag) {
    return (flags?.contains(flag) ?? false);
  }

  TodoItem(this.prefix, this.parent, this.meta, this.content) {
    if (content['_i69n'] != null) {
      if (content['_i69n'] is! String) {
        throw Exception('Multiple flags in _i69n configuration message key must be comma separated');
      }
      flags = (content['_i69n'] as String).split(',').map((f) => f.trim()).toSet();
    } else {
      // ignore: prefer_collection_literals
      flags = Set();
    }
  }

  bool hasInheritedFlag(String flag) {
    if (hasFlag(flag)) return true;
    if (parent == null) return false;
    return parent!.hasInheritedFlag(flag);
  }
}
