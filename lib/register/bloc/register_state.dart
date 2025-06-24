import 'dart:io';

class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterLoadedState extends RegisterState {
  final message;

  RegisterLoadedState({this.message});
}

class RegisterErrorState extends RegisterState {
  final error;

  RegisterErrorState({this.error});
}

class PickImageState extends RegisterState {
  final File? imagePath;

  PickImageState({this.imagePath});
}

