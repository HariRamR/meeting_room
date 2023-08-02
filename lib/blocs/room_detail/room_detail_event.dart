part of 'room_detail_bloc.dart';

@immutable
abstract class RoomDetailEvent {}
class InitialEvent extends RoomDetailEvent{
  final Stream broadcastStream;
  InitialEvent(this.broadcastStream);
}
class RoomUpdateEvent extends RoomDetailEvent{
  final RoomModel room;
  final String msg;
  RoomUpdateEvent(this.room, this.msg);
}
class LoadingEvent extends RoomDetailEvent{}
