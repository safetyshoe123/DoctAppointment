// import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:bookme_up/core/enums/state_status.enum.dart';
import 'package:bookme_up/features/auth/data/repository/auth_repository.dart';
import 'package:bookme_up/features/auth/domain/models/add_date_model.dart';
import 'package:bookme_up/features/auth/domain/models/auth_user.model.dart';
import 'package:bookme_up/features/auth/domain/models/date_model.dart';
// import 'package:bookme_up/features/auth/domain/models/doc_pics.model.dart';
import 'package:bookme_up/features/auth/domain/models/doctors.model.dart';
import 'package:bookme_up/features/auth/domain/models/login.model.dart';
import 'package:bookme_up/features/auth/domain/models/register.model.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthRepository authRepository) : super(AuthState.initial()) {
    on<AuthAutoLoginEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel?> result =
          await authRepository.autoLogin();

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
      }, (userModel) {
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          authUserModel: userModel,
        ));
      });
    });
    on<AuthLoginEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel> result =
          await authRepository.login(event.logInModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (userModel) {
        emit(state.copyWith(
          authUserModel: userModel,
          stateStatus: StateStatus.loaded,
        ));
      });
    });
    on<AuthRegisterEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel> result =
          await authRepository.register(event.registerModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (userModel) {
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          authUserModel: userModel,
        ));
      });
    });
    on<AuthLogoutEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result = await authRepository.logout();

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        emit(AuthState.initial());
      });
    });
    on<GetDoctorEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<DoctorsModel>> result =
          await authRepository.docRepo();

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (docList) {
        emit(state.copyWith(
          docModel: docList,
          stateStatus: StateStatus.loaded,
        ));
      });
      emit(state.copyWith(isEmpty: false));
    });
    on<SearchDoctorEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<DoctorsModel>> result =
          await authRepository.searchDocRepo(event.name);

      result.fold((error) {
        emit(state.copyWith(
          stateStatus: StateStatus.error,
          isEmpty: true,
          errorMessage: error,
        ));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (docList) {
        if (docList.isEmpty) {
          emit(state.copyWith(
            isEmpty: true,
            stateStatus: StateStatus.loaded,
          ));
        } else {
          emit(state.copyWith(
            docModel: docList,
            isEmpty: false,
            stateStatus: StateStatus.loaded,
          ));
        }
      });
    });
    on<SpecificDoctorEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<DoctorsModel>> result =
          await authRepository.specificDocRepo(event.docType);

      result.fold((error) {
        emit(state.copyWith(
          stateStatus: StateStatus.error,
          isEmpty: true,
          errorMessage: error,
        ));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (docList) {
        if (docList.isEmpty) {
          emit(state.copyWith(
            isEmpty: true,
            stateStatus: StateStatus.loaded,
          ));
        } else {
          emit(state.copyWith(
            docModel: docList,
            isEmpty: false,
            stateStatus: StateStatus.loaded,
          ));
        }
      });
    });
    on<AddDateTimeEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await authRepository.addDateTime(event.addDateModel);

      result.fold((error) {
        emit(state.copyWith(
          stateStatus: StateStatus.error,
          isEmpty: true,
          errorMessage: error,
        ));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (addDateModel) {
        final currentDateList = state.dateModel;
        emit(state.copyWith(
          dateModel: [
            ...currentDateList,
            DateModel(
              id: addDateModel,
              docName: event.addDateModel.docName,
              patientName: event.addDateModel.patientName,
              schedule: event.addDateModel.schedule,
            )
          ],
          stateStatus: StateStatus.loaded,
          isAdded: true,
        ));
      });
      emit(state.copyWith(isAdded: false));
    });
  }
}
