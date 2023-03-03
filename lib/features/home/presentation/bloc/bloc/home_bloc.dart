import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slow/features/home/domain/message_model.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
          const _Initial(),
        ) {
    on<_Started>(_started);
    on<_AddMessage>(_addMessage);
  }

  _started(
    _Started event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      const HomeState.loaded(
        messages: [],
      ),
    );
  }

  _addMessage(
    _AddMessage event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is _Loaded) {
      List<MessageModel> newMessages = [];
      newMessages.addAll(state.messages);
      newMessages.add(event.message);
      emit(
        HomeState.loaded(
          messages: newMessages,
        ),
      );
    }
  }
}
