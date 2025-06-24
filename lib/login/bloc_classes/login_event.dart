class LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  final email;
  final password;

  LoginRequestEvent({this.email, this.password});
}
