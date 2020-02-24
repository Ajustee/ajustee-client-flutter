library ajustee_client;

import 'package:ajustee_client/models/configuration_key.dart';
import 'package:ajustee_client/services/socket_provider.dart';
import 'package:ajustee_client/util/errors.dart';
import 'package:ajustee_client/services/api_provider.dart';
import 'package:ajustee_client/util/properties.dart';
import 'package:meta/meta.dart';

class AjusteeClient {
  final String apiUrl;
  final String applicationId;
  final String trackerId;
  final String defaultPath;
  Map<String, String> _defaultProperties;
  ApiProvider _api;
  SocketProvider _socket;

  AjusteeClient(
      {@required this.apiUrl,
      @required this.applicationId,
      socketUrl,
      this.trackerId,
      defaultProperties,
      this.defaultPath,
      bool reconnect = true,
      int reconnectTimeout = 5000}) {
    _api = ApiProvider(
        apiUrl: apiUrl, applicationId: applicationId, trackerId: trackerId);
    _defaultProperties = Properties.validate(defaultProperties);
    _socket = SocketProvider(
        applicationId: applicationId,
        socketUrl: socketUrl,
        reconnect: reconnect,
        reconnectTimeout: reconnectTimeout);
  }

  Future<List<ConfigurationKey>> getConfigurations(
      {String path, Map<String, String> properties = const {}}) async {
    final correctPath = path == null ? defaultPath : path;
    final correctProps =
        Properties.merge(_defaultProperties, Properties.validate(properties));
    final resData = await _api.fetchData(correctPath, correctProps);

    if (resData == null) {
      throw AjusteeError('Data not received');
    }

    List<ConfigurationKey> keys = [];

    resData.forEach((item) {
      keys.add(ConfigurationKey.fromJSON(item));
    });

    return keys;
  }

  void subscribe(String path,
      {Map<String, String> properties = const {}}) async {
    await _socket.subscribe(path, properties);
  }

  void unSubscribe(String path) async {
    await _socket.subscribe(path);
  }

  Stream<List<ConfigurationKey>> onChanged() {
    return this._socket.onChanged();
  }

  Stream<ConfigurationKey> onKeyChanged() {
    return this._socket.onKeyChanged();
  }

  Stream<String> onDeleted() {
    return this._socket.onDeleted();
  }

  void saveConfigurations({String path, String value}) async {
    await _api.updateData(path, value);
  }
}
