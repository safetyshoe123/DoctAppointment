import 'package:appwrite/models.dart';
import 'package:bookme_up/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:bookme_up/features/auth/data/datasource/auth_remote_datesource.dart';
import 'package:bookme_up/features/auth/domain/models/add_date_model.dart';
import 'package:bookme_up/features/auth/domain/models/auth_user.model.dart';
// import 'package:bookme_up/features/auth/domain/models/doc_pics.model.dart';
import 'package:bookme_up/features/auth/domain/models/doctors.model.dart';
// import 'package:bookme_up/features/auth/domain/models/doc_pics.model.dart';
import 'package:bookme_up/features/auth/domain/models/login.model.dart';
import 'package:bookme_up/features/auth/domain/models/register.model.dart';
import 'package:dartz/dartz.dart';

class AuthRepository {
  late AuthLocalDataSource _localDatasource;
  late AuthRemoteDatasource _remoteDatasource;

  AuthRepository(
    AuthLocalDataSource localDataSource,
    AuthRemoteDatasource remoteDatasource,
  ) {
    _localDatasource = localDataSource;
    _remoteDatasource = remoteDatasource;
  }
  //FOR GETTING PICS
  // Future<Either<String, FileList>> getPics() async {
  //   try {
  //     final result = await _remoteDatasource.getPics();
  //     print(result);
  //     return Right(result);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }
  //FOR GETTING PICS

  Future<Either<String, AuthUserModel>> login(LoginModel loginModel) async {
    try {
      //Login using the model
      final Session session = await _remoteDatasource.login(loginModel);

      //todo: should pass user id
      //Save session id
      _localDatasource.saveSessionId(session.$id);

      //Get Auth user
      final AuthUserModel authUserModel =
          await _remoteDatasource.getAuthUser(session.userId);

      //return Auth user
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel>> register(
      RegisterModel registerModel) async {
    try {
      //First Create account for Login
      await _remoteDatasource.createAccount(registerModel);

      //Todo: Get session from appwrite
      //Login to get userId
      final Session session = await _remoteDatasource.login(LoginModel(
          email: registerModel.email, password: registerModel.password));

      // should pass user id
      //Save session id
      _localDatasource.saveSessionId(session.$id);

      //Todo: Pass the user ID from session
      //Save User Data to database
      await _remoteDatasource.saveAccount(session.userId, registerModel);

      //get User Data

      final AuthUserModel authUserModel =
          await _remoteDatasource.getAuthUser(session.userId);

      //return AuthUserModel
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel?>> autoLogin() async {
    try {
      //Get session id from Local datasource
      final String? sessionId = await _localDatasource.getSessionId();

      //if null return Right(null)
      if (sessionId == null) return const Right(null);

      //else getSession
      final Session session = await _remoteDatasource.getSessionId(sessionId);

      // should pass user id
      //get User Data
      final AuthUserModel authUserModel =
          await _remoteDatasource.getAuthUser(session.userId);

      //return Auth User Model
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> logout() async {
    try {
      final String? sessionId = await _localDatasource.getSessionId();

      if (sessionId != null) {
        await _remoteDatasource.deleteSession(sessionId);
        await _localDatasource.deleteSession();
      }

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<DoctorsModel>>> docRepo() async {
    try {
      final result = await _remoteDatasource.getDoctors();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<DoctorsModel>>> searchDocRepo(String name) async {
    try {
      final result = await _remoteDatasource.searchDoctors(name);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<DoctorsModel>>> specificDocRepo(
      String docType) async {
    try {
      final result = await _remoteDatasource.specificDoctors(docType);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> addDateTime(AddDateModel addDateModel) async {
    try {
      final result = await _remoteDatasource.createDateTime(addDateModel);
      return Right(result);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }
}
