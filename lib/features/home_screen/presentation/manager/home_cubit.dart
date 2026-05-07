import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void changeBottomNavIndex(int index) {
    emit(HomeChangeBottomNav(index: index));
  }
}
