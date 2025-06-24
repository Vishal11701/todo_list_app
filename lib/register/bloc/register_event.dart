import 'package:todo_task_app/login/model/user_data_model.dart';

class RegisterEvent {}

class RegisterRequestedData extends RegisterEvent {
  final UserDataModel? user;

  RegisterRequestedData({this.user});}

class PickImageFromCamera extends RegisterEvent {}

class PickImageFromGallery extends RegisterEvent {}
