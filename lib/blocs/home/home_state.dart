part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class DashboardInitial extends HomeState {}
class LoadRoomsState extends HomeState {}
class RoomsLoadedState extends HomeState {
  List<RoomModel> rooms = [];
  RoomsLoadedState(this.rooms);
}
class ConnectionState extends HomeState{
  late WebSocketChannel channel;
  late List<RoomModel> rooms;
  late Stream broadcastStream;
  ConnectionState(this.rooms, this.channel, this.broadcastStream);
}

class RoomUpdated extends HomeState{
  late RoomModel room;
  RoomUpdated(this.room);
}
