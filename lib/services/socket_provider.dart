import 'dart:async';
import 'dart:convert';

import 'package:ajustee_client/models/configuration_key.dart';
import 'package:ajustee_client/models/subscribed_item.dart';
import 'package:ajustee_client/services/socket_client.dart';
import 'package:ajustee_client/util/errors.dart';
import 'package:meta/meta.dart';

class SocketProvider {
  final String applicationId;
  SocketClient _socketClient;
  Map<String, SubscribedItem> _subscribedItems = {};
  StreamController<List<ConfigurationKey>> streamChangedController =
      StreamController<List<ConfigurationKey>>.broadcast();
  StreamController<ConfigurationKey> streamKeyChangedController =
      StreamController<ConfigurationKey>.broadcast();
  StreamController<String> streamDeletedController =
      StreamController<String>.broadcast();

  SocketProvider(
      {@required this.applicationId,
      @required String socketUrl,
      @required bool reconnect,
      @required int reconnectTimeout}) {
    this._socketClient = SocketClient(
        applicationId: this.applicationId,
        socketUrl: socketUrl,
        reconnect: reconnect,
        reconnectTimeout: reconnectTimeout,
        onReconnected: () {
          this._onReconnected();
        });
  }

  _onReconnected() {
    this._subscribedItems.forEach((String key, SubscribedItem value) {
      if (!value.confirmed) {
        return;
      }
      this.subscribe(value.path, value.properties);
    });
  }

  connect() async {
    await this._socketClient.connect();
  }

  _confirmSubscribed(String path) {
    _subscribedItems[path].confirmed = true;
  }

  _removeSubscribed(String path) {
    _subscribedItems.remove(path);
  }

  _onChangedMessage(dynamic data) {
    List<ConfigurationKey> keys = [];
    data.forEach((item) {
      ConfigurationKey keyItem = ConfigurationKey.fromJSON(item);
      keys.add(keyItem);
      this.streamKeyChangedController.add(keyItem);
    });

    if (keys.isNotEmpty) {
      this.streamChangedController.add(keys);
    }
  }

  _onData(var message) {
    var data = message['data'];
    switch (message['type']) {
      case 'subscribe':
        _confirmSubscribed(data['path']);
        break;
      case 'unsubscribe':
        _removeSubscribed(data['path']);
        break;
      case 'changed':
        this._onChangedMessage(data);
        break;
      case 'deleted':
        _removeSubscribed(data);
        this.streamDeletedController.add(data);
        break;
      default:
        if (message['message'] != null) {
          throw AjusteeError(message['message']);
        }
    }
  }

  subscribe(String path, [Map<String, String> properties = const {}]) async {
    if (_subscribedItems[path] == null) {
      _subscribedItems[path] =
          SubscribedItem(path: path, properties: properties);
      _subscribedItems[path].confirmed = false;
    }

    await this._socketClient.listen((message) {
      this._onData(message);
    });

    var data = {
      'action': 'subscribe',
      'data': {'path': path, 'props': properties}
    };

    this.sendMessage(data);
  }

  unSubscribe(String path) async {
    var data = {
      'action': 'unsubscribe',
      'data': {'path': path}
    };

    this.sendMessage(data);
  }

  sendMessage(var message) {
    this._socketClient.sendMessage(json.encode(message));
  }

  Stream<List<ConfigurationKey>> onChanged() {
    return this.streamChangedController.stream;
  }

  Stream<ConfigurationKey> onKeyChanged() {
    return this.streamKeyChangedController.stream;
  }

  Stream<String> onDeleted() {
    return this.streamDeletedController.stream;
  }

  close() {
    this._socketClient.close();
  }
}
