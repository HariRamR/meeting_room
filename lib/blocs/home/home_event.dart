part of 'home_bloc.dart';

abstract class HomeEvent {}

class InitEvent extends HomeEvent{}
class RoomUpdateEvent extends HomeEvent{
  final RoomModel room;
  RoomUpdateEvent(this.room);
}
class ConnectionEvent extends HomeEvent{
  final List<RoomModel> rooms;
  final WebSocketChannel channel;
  final Stream broadcastStream;
  ConnectionEvent(this.rooms, this.channel, this.broadcastStream);
}
