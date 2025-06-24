import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task_app/database/deb_helper.dart';
import 'package:todo_task_app/login/bloc_classes/login_event.dart';
import 'package:todo_task_app/login/bloc_classes/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DBHelper dbHelper;

  LoginBloc(this.dbHelper) : super(LoginInitialState()) {
    on<LoginRequestEvent>((event, emit) async {
      emit(LoginInitialState());
      try {
        print('Check Login Event----');
        if (event.email && event.password != null) {
          final user = await dbHelper.getUserByEmailAndPassword(event.email, event.password);
          if (user != null) {
            print('Successfully Login');
            emit(LoginLoadedState('Successfully Login'));
          }
          else {
            emit(LoginErrorState('User not found with this email or password'));
          }
        }
      } catch (e, st) {
        emit(LoginErrorState('Error : $e'));
      }
    });
  }
}
