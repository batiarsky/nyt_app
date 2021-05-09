abstract class HomeState {}

class HomeStartState extends HomeState {}

class HomeStartedState extends HomeState {}

class HomeProgressIndicatorState extends HomeState {}

class HomeSuccessfulState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}
