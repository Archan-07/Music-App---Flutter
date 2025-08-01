import 'dart:convert';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure.dart/failure.dart';
import 'package:client/core/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${ServerConstant.serverUrl}/auth/signup",
        ), // Replace XXX with your actual IP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        print(response.body);
        return Right(UserModel.fromJson(response.body));
      } else {
        return left(AppFailure(resBodyMap['detail']));
      }
    } catch (e) {
      print(e);
      return left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${ServerConstant.serverUrl}/auth/login",
        ), // Replace XXX with your actual IP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(
          UserModel.fromMap(
            resBodyMap['user'],
          ).copyWith(token: resBodyMap['token']),
        );
      } else {
        return Left(AppFailure(resBodyMap['detail']));
      }
    } catch (e) {
      print(e);
      return left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/auth/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
      } else {
        return Left(AppFailure(resBodyMap['detail']));
      }
    } catch (e) {
      print(e);
      return left(AppFailure(e.toString()));
    }
  }
}
 