part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeChangeBottomNav extends HomeState {
  final int index;
  const HomeChangeBottomNav({required this.index});

  @override
  List<Object> get props => [index];
}
