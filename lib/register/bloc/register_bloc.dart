import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_task_app/database/deb_helper.dart';
import 'package:todo_task_app/register/bloc/register_event.dart';
import 'package:todo_task_app/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final DBHelper dbHelper;
  final ImagePicker imagePicker = ImagePicker();

  RegisterBloc(this.dbHelper) : super(RegisterInitialState()) {
    on<RegisterRequestedData>((event, emit) async {
      emit(RegisterInitialState());
      try {
        // final exists = await dbHelper.getUserByEmail(event.user?.email);
        // if (exists != null) {
        //   emit(RegisterErrorState(error: 'User already exists with this email'));
        //   return;
        // }
        await dbHelper.insertUserData(user: event.user);
        emit(RegisterLoadedState(message: 'User registered successfully'));
      } catch (e, st) {
        emit(RegisterErrorState(error: 'Error :: $e'));
      }
    });
    on<PickImageFromCamera>((event, emit) async {
      final picked = await imagePicker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        emit(PickImageState(imagePath: File(picked.path)));
      } else {
        emit(RegisterInitialState());
      }
    });
    on<PickImageFromGallery>((event, emit) async {
      final picked = await imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(PickImageState(imagePath: File(picked.path)));
      } else {
        emit(RegisterInitialState());
      }
    });
  }
}
