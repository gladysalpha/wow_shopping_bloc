part of 'main_cubit.dart';

@immutable
class MainState {
  const MainState({this.navItem = NavItem.home});
  final NavItem navItem;
}
