import 'dart:async';

import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jizt/utils/poller.dart';
import 'package:jizt_repository/jizt_repository.dart';

part 'new_text_summary_state.dart';

class NewTextSummaryCubit extends Cubit<NewTextSummaryState> {
  final JiztRepository _jiztRepository;
  StreamSubscription<Summary> pollerSubscription;

  NewTextSummaryCubit(this._jiztRepository)
      : super(const NewTextSummaryState.initial());

  Future<void> requestNewSummary({String source}) async {
    if (state.status != NewTextSummaryStatus.initial || source.isEmpty) {
      emit(NewTextSummaryState.initial());
      return;
    }
    emit(NewTextSummaryState.requestingSummary(source));
    try {
      final summaryId = await _jiztRepository.requestSummary(source);
      _checkNewSummaryStatus(source, summaryId);
    } on Exception {
      emit(NewTextSummaryState.failure());
    }
  }

  void _checkNewSummaryStatus(String source, String summaryId) {
    emit(NewTextSummaryState.waitingToCheckNewSummaryStatus(source, summaryId));
    pollerSubscription = Poller((_) => _jiztRepository.getSummary(summaryId))
        .poll()
        .listen((summary) async => await _onNewSummaryStatusReceived(summary));
  }

  Future<void> _onNewSummaryStatusReceived(Summary summary) async {
    if (state.status == NewTextSummaryStatus.checkingNewSummaryStatus) {
      return; // Already checking status
    }
    emit(NewTextSummaryState.checkingNewSummaryStatus(
        state.source, state.summaryId));
    final summary = await _jiztRepository.getSummary(state.summaryId);
    if (summary.status == Status.completed) {
      pollerSubscription.cancel();
      emit(NewTextSummaryState.success(state.source, state.summaryId));
    } else {
      emit(NewTextSummaryState.waitingToCheckNewSummaryStatus(
        state.source,
        state.summaryId,
      ));
    }
  }

  Future<void> reset() async {
    emit(NewTextSummaryState.initial());
  }
}