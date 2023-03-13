import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:slow/features/home/domain/tag_model.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(_Initial()) {
    on<SearchEvent>((event, emit) {
      if (event is _Started) {
        List<TagModel> tags = [
          TagModel(
            title: '# kontrasocial',
            hexColor: const Color(0xff2400FF).value,
          ),
          TagModel(
            title: '# beplalogi',
            hexColor: const Color(0xffFF0000).value,
          ),
          TagModel(
            title: '# ipsum',
            hexColor: const Color(0xff00C2FF).value,
          ),
          TagModel(
            title: '# lorem',
            hexColor: const Color(0xff00FF38).value,
          ),
          TagModel(
            title: '# ipsum',
            hexColor: const Color(0xff00C2FF).value,
          ),
          TagModel(
            title: '# lorem',
            hexColor: const Color(0xff00FF38).value,
          ),
          TagModel(
            title: '# kontrasocial',
            hexColor: const Color(0xff2400FF).value,
          ),
          TagModel(
            title: '# beplalogi',
            hexColor: const Color(0xffFF0000).value,
          ),
        ];
        List<MessageModel> message = [
          MessageModel(
            title: 'mock text',
            tags: [
              TagModel(
                title: '#aaaa',
                hexColor: const Color(0xff2400FF).value,
              ),
            ],
            filePaths: [],
          ),
        ];
        emit(
          SearchState.load(
            tags: tags,
            message: message,
          ),
        );
      }
    });
  }
}
