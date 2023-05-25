import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/repositories/ws_repository.dart';

class WsRepositoryImpl implements WsRepository {
  WsRepositoryImpl(this.builder);
  StreamController<Map<String, double>>? _controller;
  StreamSubscription? _subscription;
  final WebSocketChannel Function(List<String>) builder;

  WebSocketChannel? channel;

  @override
  Future<bool> connect(List<String> ids) async {
    try {
      channel = builder(ids);
      await channel!.ready;
      _subscription = channel!.stream.listen((event) {
        final map = Map<String, String>.from(jsonDecode(event));
        final data = <String, double>{}..addEntries(
            map.entries.map((e) => MapEntry(e.key, double.parse(e.value))));
        if (_controller?.hasListener ?? false) {
          _controller!.add(data);
        }
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    _subscription!.cancel();
    await _controller!.close();
    await channel!.sink.close();
    channel = null;
  }
  
  @override
  Stream<Map<String, double>> get onPriceChange{
    _controller ??= StreamController.broadcast();
  return _controller!.stream;
  }
}
