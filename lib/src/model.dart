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
    ClassMeta result = ClassMeta();
    result.parent = this;
    result.isDefault = isDefault;
    result.defaultObjectName = "${namePrefix}${defaultObjectName}";
    result.objectName = "${namePrefix}${objectName}";
    result.localeName = localeName;
    result.languageCode = languageCode;
    return result;
  }
}

class TodoItem {
  ClassMeta meta;
  YamlMap content;

  TodoItem(this.meta, this.content);
}
