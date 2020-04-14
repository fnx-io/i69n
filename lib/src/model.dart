part of i69n;

class ClassMeta {
  ClassMeta parent;
  bool isDefault;
  String defaultObjectName;
  String defaultFileName;
  String objectName;
  String localeName;
  String languageCode;

  ClassMeta nest(String namePrefix) {
    var result = ClassMeta();
    result.parent = this;
    result.isDefault = isDefault;
    result.defaultObjectName = '${namePrefix}${defaultObjectName}';
    result.objectName = '${namePrefix}${objectName}';
    result.localeName = localeName;
    result.languageCode = languageCode;
    return result;
  }
}

class TodoItem {
  ClassMeta meta;
  Set<String> flags;
  YamlMap content;
  TodoItem parent;
  String prefix;

  String get path => parent == null ? meta.languageCode : "${parent.path}.$prefix";

  bool hasFlag(String flag) {
    return flags.contains(flag);
  }

  TodoItem(this.prefix, this.parent, this.meta, this.content) {
    if (content != null && content['_i69n'] != null && content['_i69n'] is String) {
      flags = (content['_i69n'] as String).split(",").map((f) => f.trim()).toSet();
    } else {
      flags = {};
    }
  }
}
