import 'dart:convert';

import 'package:ajustee_client/models/configuration_key.dart';
import 'package:intl/intl.dart';

class TypeConversion {
  static String jsonEncodeForSocket(dynamic data) {
    final String jsonData =
        json.encode(data).replaceAll(RegExp(r'\\'), '').replaceFirst('"', '');
    return jsonData.isNotEmpty
        ? jsonData.substring(0, jsonData.length - 1)
        : jsonData;
  }

  static ConfigKeyType dataTypeFromJSON(dynamic data) {
    switch (data) {
      case 'Integer':
        return ConfigKeyType.Integer;
      case 'String':
        return ConfigKeyType.String;
      case 'Boolean':
        return ConfigKeyType.Boolean;
      case 'Date':
        return ConfigKeyType.Date;
      case 'DateTime':
        return ConfigKeyType.DateTime;
    }
    return null;
  }

  static dynamic valueFromJSON(dynamic value, ConfigKeyType dataType) {
    String runtimeType = value.runtimeType.toString();
    switch (dataType) {
      case ConfigKeyType.Integer:
        return int.parse(value);
      case ConfigKeyType.Boolean:
        return runtimeType == 'bool' ? value : value == 'false' ? false : true;
      case ConfigKeyType.Date:
        return DateFormat('yyyy-MM-dd').parse(value);
      case ConfigKeyType.DateTime:
        return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(value);
      case ConfigKeyType.String:
        return value.toString();
    }
  }
}
