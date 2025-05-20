import 'package:nexust/domain/entities/side_bar_entity.dart';

abstract class SideBarRepository {
  void setSideBar(SideBarEntity sideBar);
  SideBarEntity getSideBar();
  void toggleSideBarState();
  bool getSideBarState();
}
