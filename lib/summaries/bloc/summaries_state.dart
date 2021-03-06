part of 'summaries_cubit.dart';

abstract class SummariesState extends Equatable {
  const SummariesState();

  @override
  List<Object> get props => [];
}

class SummariesLoadInProgressState extends SummariesState {}

class SummariesLoadSuccessState extends SummariesState {
  final List<Summary> summaries;

  const SummariesLoadSuccessState([this.summaries = const []]);

  @override
  List<Object> get props => [summaries];
}

class SummariesLoadFailureState extends SummariesState {}
