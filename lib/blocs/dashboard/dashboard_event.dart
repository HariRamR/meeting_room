part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {

}

class BottomNavEvent extends DashboardEvent{
  BottomNavEvent(int pageIndex);
}
