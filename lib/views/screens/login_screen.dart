import 'package:flutter/material.dart';
import 'package:meyor_lite/controllers/auth_controller.dart';
import 'package:meyor_lite/views/screens/home_screen.dart';
import 'package:meyor_lite/views/screens/register_screen.dart';
import 'package:meyor_lite/views/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController authViewmodel;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authViewmodel = context.read<AuthController>();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // tizimga kirish
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        await authViewmodel.login(email: email, password: password);

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
        if (error.contains("INVALID_LOGIN_CREDENTIALS")) {
          message = "Email yoki parol xato";
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text("Kirish")),
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
                            : Text("Kirish"),
                  );
                },
              ),

              SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return RegisterScreen();
                      },
                    ),
                  );
                },
                child: Text("Ro'yxatdan o'tish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
