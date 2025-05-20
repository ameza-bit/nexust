import 'package:nexust/core/services/preferences.dart';
import 'package:nexust/domain/entities/side_bar_entity.dart';
import 'package:nexust/domain/repositories/side_bar_repository.dart';

class SideBarRepositoryImpl extends SideBarRepository {
  @override
  void setSideBar(SideBarEntity sideBar) => Preferences.sideBar = sideBar;

  @override
  SideBarEntity getSideBar() => Preferences.sideBar;

  @override
  bool getSideBarState() => getSideBar().isExpanded;

  @override
  void toggleSideBarState() {
    SideBarEntity sideBar = getSideBar();
    sideBar.isExpanded = !sideBar.isExpanded;
    setSideBar(sideBar);
  }
}
