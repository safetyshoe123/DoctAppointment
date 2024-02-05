part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthAutoLoginEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final LoginModel logInModel;

  AuthLoginEvent({
    required this.logInModel,
  });
}

class AuthRegisterEvent extends AuthEvent {
  final RegisterModel registerModel;

  AuthRegisterEvent({
    required this.registerModel,
  });
}

class AuthLogoutEvent extends AuthEvent {}

class GetDoctorEvent extends AuthEvent {}

class SearchDoctorEvent extends AuthEvent {
  final String name;

  SearchDoctorEvent({required this.name});
}

class SpecificDoctorEvent extends AuthEvent {
  final String docType;

  SpecificDoctorEvent({required this.docType});
}

class AddDateTimeEvent extends AuthEvent {
  final AddDateModel addDateModel;

  AddDateTimeEvent({required this.addDateModel});
}

// class GetPicsEvent extends AuthEvent {
//   final DocPicsModel docPicsModel;

//   GetPicsEvent({required this.docPicsModel});
// }
