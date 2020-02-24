import 'package:ajustee_client/util/http_headers.dart';
import 'package:ajustee_client/util/errors.dart';
import 'package:http/http.dart' show Client;
import 'package:meta/meta.dart';
import 'dart:convert' as convert;

import '../util/errors.dart';

class ApiProvider {
  final String apiUrl;
  final String applicationId;
  final String trackerId;
  Client client = Client();

  ApiProvider({
    @required this.apiUrl,
    @required this.applicationId,
    @required this.trackerId,
  });

  fetchData([String path, Map<String, String> properties]) async {
    final pathParam = path == null ? '' : 'path=$path';
    var res;

    properties[HttpHeader.applicationId] = applicationId;
    properties[HttpHeader.trackerId] = trackerId;

    try {
      res = await client.get(
        '$apiUrl/configurationKeys?$pathParam',
        headers: properties,
      );
    } catch (err) {
      throw HttpConnectionError();
    }

    if (res.statusCode != 200) {
      switch (res.statusCode) {
        case 403:
          throw AccessForbidden();
        case 500:
        case 502:
        case 504:
          throw ServerError();
      }

      throw BadRequest();
    }

    return convert.jsonDecode(res.body);
  }

  updateData(String path, String value) async {
    Map<String, String> properties = {};
    properties[HttpHeader.applicationId] = applicationId;
    properties[HttpHeader.trackerId] = trackerId;
    Map<String, String> body = {'value': value};

    final res = await client.put('$apiUrl/configurationKeys/$path',
        headers: properties, body: convert.jsonEncode(body));

    if (res.statusCode != 204) {
      switch (res.statusCode) {
        case 402:
          throw PaymentRequired();
        case 403:
          throw AccessForbidden();
        case 404:
          throw NotFound('The configuration key doesn’t exists');
        case 500:
        case 502:
        case 504:
          throw ServerError();
      }
      throw BadRequest();
    }
  }
}
