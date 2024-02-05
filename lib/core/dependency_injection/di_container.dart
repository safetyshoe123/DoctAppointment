import 'package:appwrite/appwrite.dart';
import 'package:bookme_up/config.dart';
import 'package:bookme_up/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:bookme_up/features/auth/data/datasource/auth_remote_datesource.dart';
import 'package:bookme_up/features/auth/data/repository/auth_repository.dart';
import 'package:bookme_up/features/auth/domain/bloc/auth_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DIContainer {
  Client get _client => Client()
      .setEndpoint(Config.endpoint)
      .setProject(Config.projectId)
      .setSelfSigned(status: true);

  Account get _account => Account(_client);
  Databases get _databases => Databases(_client);
  Storage get _storage => Storage(_client);

  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();

  AuthLocalDataSource get _localDatasource =>
      AuthLocalDataSource(_secureStorage);

  AuthRemoteDatasource get _remoteDatasource =>
      AuthRemoteDatasource(_account, _databases, /*_storage*/);

  AuthRepository get _authRepository =>
      AuthRepository(_localDatasource, _remoteDatasource);

  AuthBloc get authBloc => AuthBloc(_authRepository);
}
