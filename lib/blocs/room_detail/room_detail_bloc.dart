import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meeting_room/models/room_model.dart';
import 'package:meta/meta.dart';

part 'room_detail_event.dart';
part 'room_detail_state.dart';

class RoomDetailBloc extends Bloc<RoomDetailEvent, RoomDetailState> {
  RoomDetailBloc() : super(RoomDetailInitial()) {
    on<InitialEvent>((event, emit) {
      listenToStream(event.broadcastStream);
    });
    on<LoadingEvent>((event, emit) => emit.call(LoadingState()));
    on<RoomUpdateEvent>((event, emit) => emit.call(RoomUpdated(event.room, event.msg)));
  }

  void listenToStream(Stream stream){
    stream.listen((message) {
      var jsonObj = jsonDecode(message);
      var event = jsonObj['event'];

      if (event == "bookRoom") {
        var status = jsonObj['payload']['status'];
        var payload = jsonObj['payload']['roomData'];
        RoomModel room = RoomModel.fromJson(payload);
        add(RoomUpdateEvent(room, status));
      }
    });
  }
}
