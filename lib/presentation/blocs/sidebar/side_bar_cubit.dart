import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/domain/entities/side_bar_entity.dart';
import 'package:nexust/domain/repositories/side_bar_repository.dart';
import 'package:nexust/presentation/blocs/sidebar/side_bar_state.dart';

class SideBarCubit extends Cubit<SideBarState> {
  final SideBarRepository _sideBarRepository;
  
  SideBarCubit(this._sideBarRepository)
      : super(SideBarState(sideBar: SideBarEntity()));

  void getSideBar() {
    try {
      SideBarEntity sideBar = _sideBarRepository.getSideBar();
      emit(state.copyWith(sideBar: sideBar));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void toggleSideBarState() {
    try {
      _sideBarRepository.toggleSideBarState();
      SideBarEntity sideBar = _sideBarRepository.getSideBar();
      emit(state.copyWith(sideBar: sideBar));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
