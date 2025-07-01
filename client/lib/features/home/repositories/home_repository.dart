import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure.dart/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artistName,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverUrl}/song/upload'),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedThumbnail.path,
          ),
        ])
        ..fields.addAll({
          'artist': artistName,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final response = await request.send();
      if (response.statusCode != 201) {
        return Left(AppFailure(await response.stream.bytesToString()));
      }
      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/song/list"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;
      List<SongModel> songList = [];
      for (final map in resBodyMap) {
        songList.add(SongModel.fromMap(map));
      }

      return Right(songList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favoriteSongs({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ServerConstant.serverUrl}/song/favorite"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({"song_id": songId}),
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(resBodyMap['message'] );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
  Future<Either<AppFailure, List<SongModel>>> getFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/song/list/favorite"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;
      List<SongModel> songList = [];
      for (final map in resBodyMap) {
        songList.add(SongModel.fromMap(map['song']));
      }

      return Right(songList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
