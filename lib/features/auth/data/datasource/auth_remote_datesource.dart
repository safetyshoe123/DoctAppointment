import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bookme_up/config.dart';
import 'package:bookme_up/features/auth/domain/models/add_date_model.dart';
import 'package:bookme_up/features/auth/domain/models/auth_user.model.dart';
import 'package:bookme_up/features/auth/domain/models/doctors.model.dart';
// import 'package:bookme_up/features/auth/domain/models/doc_pics.model.dart';
import 'package:bookme_up/features/auth/domain/models/login.model.dart';
import 'package:bookme_up/features/auth/domain/models/register.model.dart';
import 'package:dartz/dartz.dart';

class AuthRemoteDatasource {
  late Account _account;
  late Databases _databases;
  // late Storage _storage;

  AuthRemoteDatasource(
    Account account,
    Databases databases,
    /*Storage storage*/
  ) {
    _account = account;
    _databases = databases;
    // _storage = storage;
  }

  //FOR PICTURES
  // Future<FileList> getPics() async {
  //   final docPics = await _storage.listFiles(
  //     bucketId: Config.bucketId,
  //   );
  //    print(docPics);
  //   final picsToMap = docPics as List;
  //   final picsToList = picsToMap.map((e) => DocPicsModel.fromJson(e)).toList();

  //   print(picsToMap);
  //   print(picsToList);
  //   return docPics;
  // }
  //FOR PICTURES

  Future<Unit> createAccount(RegisterModel registerModel) async {
    await _account.create(
      userId: ID.unique(),
      email: registerModel.email,
      password: registerModel.password,
    );

    return unit;
  }

  Future<Unit> saveAccount(String userId, RegisterModel registerModel) async {
    await _databases.createDocument(
      databaseId: Config.dbID,
      collectionId: Config.coluserDbID,
      documentId: userId,
      data: {
        'userId': userId,
        'name': registerModel.name,
        'email': registerModel.email,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String()
      },
    );

    return unit;
  }

  Future<Session> login(LoginModel loginModel) async {
    final session = await _account.createEmailSession(
      email: loginModel.email,
      password: loginModel.password,
    );

    return session;
  }

  Future<AuthUserModel> getAuthUser(String userId) async {
    final documents = await _databases.getDocument(
      databaseId: Config.dbID,
      collectionId: Config.coluserDbID,
      documentId: userId,
    );

    return AuthUserModel.fromJson(documents.data);
  }

  Future<Session> getSessionId(String sessionId) async {
    final Session session = await _account.getSession(sessionId: sessionId);

    return session;
  }

  Future<Unit> deleteSession(String sessionId) async {
    await _account.deleteSession(sessionId: sessionId);

    return unit;
  }

  Future<List<DoctorsModel>> getDoctors() async {
    final docs = await _databases.listDocuments(
      databaseId: Config.dbID,
      collectionId: Config.doctorsCollID,
    );

    return docs.documents
        .map((e) => DoctorsModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<List<DoctorsModel>> searchDoctors(String name) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.dbID,
        collectionId: Config.doctorsCollID,
        queries: [Query.equal('docName', name)]);

    return Future.delayed(
        const Duration(milliseconds: 300),
        () => docs.documents
            .map((e) => DoctorsModel.fromJson({...e.data, 'id': e.$id}))
            .toList());
  }

  Future<List<DoctorsModel>> specificDoctors(String docType) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.dbID,
        collectionId: Config.doctorsCollID,
        queries: [Query.equal('docType', docType)]);

    return Future.delayed(
        const Duration(milliseconds: 300),
        () => docs.documents
            .map((e) => DoctorsModel.fromJson({...e.data, 'id': e.$id}))
            .toList());
  }

  Future<String> createDateTime(AddDateModel addDateModel) async {
    try {
      final String id = ID.unique();
      final result = await _databases.listDocuments(
          databaseId: Config.dbID,
          collectionId: Config.schedulesId,
          queries: [
            Query.equal('schedule', addDateModel.schedule),
            Query.equal('docName', addDateModel.docName),
          ]);

      if (result.total == 0) {
        final docs = await _databases.createDocument(
          databaseId: Config.dbID,
          collectionId: Config.schedulesId,
          documentId: id,
          data: {
            'id': id,
            'docName': addDateModel.docName,
            'patientName': addDateModel.patientName,
            'schedule': addDateModel.schedule.toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
        return docs.$id;
      }
      throw ('Date is occupied. Please select other dates.');
    } catch (e) {
      throw e.toString();
    }
  }
}
