part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.load({
    required List<TagModel> tags,
    required List<MessageModel> message,
  }) = _Load;
}
