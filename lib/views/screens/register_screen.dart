import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/auth_controller.dart';
import 'package:meyor_lite/views/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final AuthController authViewmodel;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authViewmodel = context.read<AuthController>();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // ro'yxatdan o'tkazish
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        await authViewmodel.register(email: email, password: password);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) {
                return HomeScreen();
              },
            ),
          );
        }
      } catch (e) {
        final error = e.toString();
        String message = error;
        if (error.contains("EMAIL_EXISTS")) {
          message = "Bunaqa email oldin ro'yxatdan o'tgan";
        } else if (error.contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
          message = "Juda ko'p urindingiz, keyinroq urinib ko'ring";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: Text("Ro'yxatdan o'tish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextFormField(
                controller: _emailController,
                labelText: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos, email kiriting";
                  }

                  if (!value.contains("@")) {
                    return "Iltimos, to'g'ri email kiriting";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              MyTextFormField(
                controller: _passwordController,
                labelText: "Parol",
                hideText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos, parol kiriting";
                  }

                  if (value.length < 6) {
                    return "Parol kamida 6 ta element bo'lsin)";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              MyTextFormField(
                controller: _passwordConfirmationController,
                labelText: "Parolni tasdiqlang",
                hideText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Parollar mos kelmadi";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              ListenableBuilder(
                listenable: authViewmodel,
                builder: (context, child) {
                  final isLoading = authViewmodel.isLoading;
                  return FilledButton(
                    onPressed: isLoading ? () {} : _submit,
                    child:
                        isLoading
                            ? Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Text("Ro'yxatdan o'tish"),
                  );
                },
              ),
              SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Tizimga kirish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
