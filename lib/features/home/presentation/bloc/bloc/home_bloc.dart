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
        );

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) =>
      event.when(started: _started, addMessage: _addMessage);

  Stream<HomeState> _started() async* {
    yield const HomeState.loaded(
      messages: [],
    );
  }

  Stream<HomeState> _addMessage(MessageModel message) async* {
    yield* state.maybeMap(
      loaded: (loadedState) async* {
        List<MessageModel> newMessages = [];
        newMessages.addAll(loadedState.messages);
        newMessages.add(message);
        print(newMessages);
        yield HomeState.loaded(
          messages: newMessages,
        );
      },
      orElse: () => Stream.value(state),
    );
  }
}
