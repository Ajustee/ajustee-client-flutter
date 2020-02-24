import 'dart:io';
import 'dart:convert';

import 'package:ajustee_client/util/errors.dart';
import 'package:ajustee_client/util/type_conversion.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketClient {
  final String applicationId;
  final String socketUrl;
  final int reconnectTimeout;
  Function onReconnected;
  WebSocket _webSocket;
  bool reconnect = true;
  bool _isListened = false;
  bool _isConnected = false;
  bool _isReconnecting = false;
  IOWebSocketChannel _channel;
  void Function(dynamic) _onData;

  SocketClient({
    @required this.applicationId,
    @required this.reconnect,
    @required this.socketUrl,
    @required this.reconnectTimeout,
    this.onReconnected,
  });

  connect() async {
    try {
      _webSocket = await WebSocket.connect(this.socketUrl,
          headers: {"x-api-key": applicationId});
      _channel = IOWebSocketChannel(_webSocket);
      _isConnected = true;
    } catch (e) {
      throw SocketConnectionError();
    }
  }

  sendMessage(dynamic message) async {
    if (!_isConnected && !this._isReconnecting) {
      await this.connect();
    }
    if (!_isConnected) {
      return;
    }

    _webSocket.add(TypeConversion.jsonEncodeForSocket(message));
  }

  listen(void Function(dynamic) onData) async {
    if (!_isConnected && !this._isReconnecting) {
      await this.connect();
    }
    if (!_isConnected) {
      return;
    }
    if (_isListened) {
      return;
    }
    this._onData = onData;

    _channel.stream.listen((message) {
      print(message);
      final data = json.decode(message);
      this._onData(data);
    }, onDone: () async {
      _isListened = false;
      _isConnected = false;
      if (this.reconnect == true) {
        tryReconnect();
      }
    });
    _isListened = true;
  }

  tryReconnect() async {
    try {
      this._isReconnecting = true;
      await connect();
      if (this.onReconnected != null) {
        this.onReconnected();
      }
      this.listen(this._onData);
      this._isReconnecting = false;
    } on SocketConnectionError {
      _isConnected = false;
      Future.delayed(Duration(milliseconds: this.reconnectTimeout), () {
        this.tryReconnect();
      });
    }
  }

  close() {
    _channel.sink.close(status.goingAway);
  }
}
