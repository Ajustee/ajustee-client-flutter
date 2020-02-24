import 'package:ajustee_client/util/type_conversion.dart';

enum ConfigKeyType {
  Integer,
  String,
  Boolean,
  Date,
  DateTime,
}

class ConfigurationKey {
  String path;
  ConfigKeyType dataType;
  dynamic value;
  
  ConfigurationKey({this.path, this.dataType, this.value});

  ConfigurationKey.fromJSON(jsonData) {
    final ConfigKeyType dataType =
        TypeConversion.dataTypeFromJSON(jsonData['dataType']);

    this.path = jsonData['path'];
    this.dataType = dataType;
    this.value = TypeConversion.valueFromJSON(jsonData['value'], dataType);
  }
}
