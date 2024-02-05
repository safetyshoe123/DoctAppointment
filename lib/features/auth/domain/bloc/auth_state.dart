part of 'auth_bloc.dart';

@immutable
class AuthState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final AuthUserModel? authUserModel;
  final List<DoctorsModel> docModel;
  final List<DateModel> dateModel;
  final bool obscure;
  final bool isEmpty;
  final bool isAdded;

  const AuthState({
    required this.stateStatus,
    required this.docModel,
    required this.dateModel,
    this.errorMessage,
    this.authUserModel,
    required this.obscure,
    required this.isEmpty,
    required this.isAdded,
  });

  factory AuthState.initial() => const AuthState(
        stateStatus: StateStatus.initial,
        obscure: true,
        docModel: [],
        isEmpty: true,
        dateModel: [],
        isAdded: false,
      );

  AuthState copyWith({
    StateStatus? stateStatus,
    String? errorMessage,
    AuthUserModel? authUserModel,
    bool? obscure,
    bool? isEmpty,
    List<DoctorsModel>? docModel,
    List<DateModel>? dateModel,
    bool? isAdded,
  }) {
    return AuthState(
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      authUserModel: authUserModel ?? this.authUserModel,
      obscure: obscure ?? this.obscure,
      docModel: docModel ?? this.docModel,
      isEmpty: isEmpty ?? this.isEmpty,
      dateModel: dateModel ?? this.dateModel,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}
