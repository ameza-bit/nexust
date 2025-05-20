import 'package:nexust/domain/entities/side_bar_entity.dart';

class SideBarState {
  final SideBarEntity sideBar;
  final String? error;

  const SideBarState({required this.sideBar, this.error});

  factory SideBarState.initial() => SideBarState(sideBar: SideBarEntity());

  SideBarState copyWith({SideBarEntity? sideBar, String? error}) =>
      SideBarState(
        sideBar: sideBar ?? this.sideBar,
        error: error ?? this.error,
      );
}
