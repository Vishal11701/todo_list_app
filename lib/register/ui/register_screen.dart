import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task_app/database/deb_helper.dart';
import 'package:todo_task_app/login/model/user_data_model.dart';
import 'package:todo_task_app/register/bloc/register_bloc.dart';
import 'package:todo_task_app/register/bloc/register_state.dart';

import '../bloc/register_event.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(DBHelper.instance),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register Screen'),
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(builder: (context, state) {
          File? imageFile;
          if (state is PickImageState) {
            imageFile = state.imagePath;
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageFile != null ? FileImage(imageFile) : null,
                      child: imageFile == null ? Icon(Icons.camera_alt, size: 50) : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (v) => v!.isEmpty ? "Enter Name" : null,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (v) => v!.isEmpty ? "Enter Email" : null,
                  ),
                  TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (v) => v!.isEmpty ? "Enter Phone" : null,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? "Enter Password" : null,
                  ),
                  SizedBox(height: 16),
                  state is RegisterLoadingState
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate() || imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill all fields and pick image")));
                        return;
                      }
                      final user = UserDataModel(
                        name: _name.text,
                        email: _email.text,
                        phone: _phone.text,
                        password: _password.text,
                        image: imageFile.path,
                      );
                      context.read<RegisterBloc>().add(RegisterRequestedData(user: user));
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          );
        }, listener: (context, state) {
          if (state is RegisterLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) =>
          SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    context.read<RegisterBloc>().add(PickImageFromCamera());
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    context.read<RegisterBloc
                    >().add(PickImageFromGallery());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }
}
