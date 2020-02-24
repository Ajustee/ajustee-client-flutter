import 'package:ajustee_client/models/configuration_key.dart';
import 'package:ajustee_client/util/errors.dart';
import 'package:test/test.dart';

import 'package:ajustee_client/ajustee_client.dart';

void main() {
  final String apiUrl = 'https://api.ajustee.com';
  final String appId = 'YOUR_KEY';

  final AjusteeClient ajusteeClient = AjusteeClient(
    apiUrl: apiUrl,
    applicationId: appId,
  );

  test('must have default settings', () {
    expect(ajusteeClient.apiUrl, apiUrl);
    expect(ajusteeClient.applicationId, appId);
  });

  test('must return all configuration keys', () async {
    List<ConfigurationKey> configKeys = await ajusteeClient.getConfigurations();

    expect(configKeys != null, true);
    expect(configKeys.runtimeType.toString(), 'List<ConfigurationKey>');
  });

  test('must return empty list', () async {
    List<ConfigurationKey> configKeys = await ajusteeClient.getConfigurations(path: 'blablabla');

    expect(configKeys.length, 0);
  });

  test('must return key by path', () async {
    List<ConfigurationKey> configKeys = await ajusteeClient.getConfigurations(path: 'demoKey');
    expect(configKeys.length, 1);
  });

  test('must return key by path and props', () async {
    Map<String, String> props = {'parameter1': 'value1'};
    List<ConfigurationKey> configKeys = await ajusteeClient.getConfigurations(path: 'demoKey', properties: props);
    expect(configKeys.length, 1);
  });

  test('must return validation error', () async {
    Map<String, String> props = {'x-api-key': '123'};
    try{
      await ajusteeClient.getConfigurations(path: 'demoKey', properties: props);
    } catch(err) {
      expect(err is ReservedPropertyName, true);
    }
  });
}
