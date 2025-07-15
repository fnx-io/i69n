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
  BuilderOptions? options;

  String? get path => parent == null ? meta.languageCode : '${parent!.path}.$prefix';

  bool hasFlag(String flag) {
    return (flags?.contains(flag) ?? false);
  }

  bool hasGlobalFlag(String flag) {
    return options?.config[flag] == true;
  }

  TodoItem(this.prefix, this.parent, this.meta, this.content, {this.options}) {
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

  String? flagValue(String flagName) {
    var v = content['_i69n_$flagName'];
    if (v == null) return null;
    if (v is! String) {
      throw Exception('Flag _i69n_$flagName must be a string, see $path');
    }
    if (v.trim().isEmpty) return null;
    return v.trim();
  }

  bool hasInheritedFlag(String flag) {
    if (hasFlag(flag)) return true;
    if (parent == null) return false;
    return parent!.hasInheritedFlag(flag);
  }
}
