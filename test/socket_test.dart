import 'package:ajustee_client/ajustee_client.dart';
import 'package:test/test.dart';

void main() {
  final String apiUrl = 'https://api.ajustee.com';
  final String appId = 'xxxxxx';

  test('must connect to socket', () {
    AjusteeClient ajusteeClient = AjusteeClient(
      apiUrl: apiUrl,
      applicationId: appId,
    );
  });
}