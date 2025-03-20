import 'package:babyshopub_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey to manage the form state and validation.
  final formKey = GlobalKey<FormState>();
  // Controllers for the email and password input fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // This helper is called synchronously after the async login call.
  // It handles the result of the login attempt and displays appropriate feedback.
  void _handleLoginResult(String result) {
    if (result == "Login Successful") {
      // Show a success SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );
      // Navigate to the home screen and remove all previous routes.
      Navigator.restorablePushNamedAndRemoveUntil(
          context, "/home", (route) => false);
    } else {
      // Show an error SnackBar with the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  // This helper is called synchronously after the async reset-password call.
  // It handles the result of the password reset attempt and displays appropriate feedback.
  void _handleResetPasswordResult(String value) {
    if (value == "Mail Sent") {
      // Show a success SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset link sent to your email")),
      );
      // Close the dialog.
      Navigator.pop(context);
    } else {
      // Show an error SnackBar with the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(value, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the content in a SingleChildScrollView to prevent overflow.
        child: Form(
          // Wrap the content in a Form widget to manage form state.
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 120),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    const Text("Get started with your account"),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        // Validate if the email field is empty.
                        validator: (value) => value!.isEmpty
                            ? "Email cannot be empty."
                            : null,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  // Validate if the password has at least 8 characters.
                  validator: (value) => value!.length < 8
                      ? "Password should have at least 8 characters."
                      : null,
                  controller: _passwordController,
                  obscureText: true, // Hide the password.
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Show a dialog for password reset.
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          // Use the dialog's context for any operations inside the dialog.
                          return AlertDialog(
                            title: const Text("Forget Password"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Enter your email"),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    label: Text("Email"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog.
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Check if the email field is empty.
                                  if (_emailController.text.isEmpty) {
                                    // Using the dialog's context to show a SnackBar.
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Email cannot be empty")),
                                    );
                                    return;
                                  }
                                  // Call the resetPassword method from AuthService.
                                  final value = await AuthService()
                                      .resetPassword(_emailController.text);
                                  if (!mounted) return;
                                  // Handle the result of the password reset.
                                  _handleResetPasswordResult(value);
                                },
                                child: const Text("Submit"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Forget Password"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate the form before attempting login.
                    if (formKey.currentState!.validate()) {
                      // Call the loginWithEmail method from AuthService.
                      final value = await AuthService().loginWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (!mounted) return;
                      // Handle the result of the login attempt.
                      _handleLoginResult(value);
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to the signup screen.
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text("Sign Up"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
