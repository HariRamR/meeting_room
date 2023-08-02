part of 'room_detail_bloc.dart';

@immutable
abstract class RoomDetailState {}

class RoomDetailInitial extends RoomDetailState {}
class RoomUpdated extends RoomDetailState {
  final RoomModel room;
  final String msg;
  RoomUpdated(this.room, this.msg);
}
class LoadingState extends RoomDetailState{}
