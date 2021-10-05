import 'package:freezed_annotation/freezed_annotation.dart';

part 'emo_file.freezed.dart';
part 'emo_file.g.dart';

enum EmoFileStorage {
  localFile
}

@freezed
class EmoFile with _$EmoFile {
  const factory EmoFile({
    required String path,
    required EmoFileStorage storage,
  }) = _EmoFile;

  const EmoFile._();

  factory EmoFile.fromJson(Map<String, dynamic> json) => _$EmoFileFromJson(json);
}
