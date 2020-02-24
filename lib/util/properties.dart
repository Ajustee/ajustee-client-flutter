import 'package:ajustee_client/util/errors.dart';
import 'package:ajustee_client/util/http_headers.dart';

class Properties {
  static Map<String, String> validate(Map<String, String> properties) {
    if (properties == null) {
      return Map();
    }

    properties.forEach((key, value) {
      if (key.toLowerCase() == HttpHeader.applicationId) {
        throw ReservedPropertyName(HttpHeader.applicationId);
      }
      if (key.toLowerCase() == HttpHeader.trackerId) {
        throw ReservedPropertyName(HttpHeader.trackerId);
      }
    });

    return properties;
  }

  static Map<String, String> merge(
    Map<String, String> properties1,
    Map<String, String> properties2,
  ) {
    Map<String, String> result = Map();
    result.addAll(properties1);
    result.addAll(properties2);
    return result;
  }
}
