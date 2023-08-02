import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/room_model.dart';

part 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(LoadRoomsState()) {
    on<InitEvent>((event, emit) {
      // Uri wsUrl = Uri.parse('ws://192.168.201.53:1337');
      // Uri wsUrl = Uri.parse('ws://10.0.2.2:1337'); // for running from emulator
      Uri wsUrl = Uri.parse('ws://localhost:8080');
      WebSocketChannel channel = WebSocketChannel.connect(wsUrl);
      listenToStream(channel);
    });

    on<ConnectionEvent>((event, emit) =>
        emit.call(ConnectionState(event.rooms, event.channel, event.broadcastStream)));

    on<RoomUpdateEvent>((event, emit) =>
        emit.call(RoomUpdated(event.room)));
  }

  void listenToStream(WebSocketChannel channel){
    Stream broadcastStream = channel.stream.asBroadcastStream(
      onCancel: (subscription) {
        subscription.pause();
      },
      onListen: (subscription) {
        subscription.resume();
      },
    );
    broadcastStream.listen((message) {
      var jsonObj = jsonDecode(message);
      var event = jsonObj['event'];

      if (event == "connection") {
        var payload = jsonObj['payload']['roomData'];
        payload as List<dynamic>;
        List<RoomModel> rooms = [];
        for (int i = 0; i < payload.length; i++) {
          rooms.add(RoomModel.fromJson(payload[i]));
        }
        add(ConnectionEvent(rooms, channel, broadcastStream));
      } else if (event == "bookRoom") {
        var payload = jsonObj['payload']['roomData'];
        RoomModel room = RoomModel.fromJson(payload);
        add(RoomUpdateEvent(room));
      }
    });
  }
}
