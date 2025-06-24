import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task_app/login/bloc_classes/login_bloc.dart';
import 'package:todo_task_app/login/bloc_classes/login_event.dart';
import 'package:todo_task_app/login/bloc_classes/login_state.dart';
import 'package:todo_task_app/register/ui/register_screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, state) {
        if (state is LoginInitialState) {}
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login Screen'),
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Spacer(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print('check Login-----');
                          try{
                            context.read<LoginBloc>().add(LoginRequestEvent(email: emailTextController.text, password: passwordTextController.text));
                          }catch(e,st){
                            print('Error in Login: $e');
                          }
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                      },
                      child: Text(
                        'Not Member? Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
