import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable(createToJson: false)
class TagModel {
  final String title;
  final int hexColor;

  TagModel({
    required this.title,
    required this.hexColor,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}
