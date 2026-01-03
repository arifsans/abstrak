import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/x_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    authNotifier.auth.addListener(_handleAuthStateChange);
  }

  @override
  void dispose() {
    authNotifier.auth.removeListener(_handleAuthStateChange);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthStateChange() {
    if (!mounted) return;
    
    final authState = authNotifier.auth.value;
    
    switch (authState.status) {
      case ApiStatus.success:
        if (authState.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome back! Your highness 👑'),
              backgroundColor: Color(0xFF00bcd5),
            ),
          );
          context.goNamed('profile');
        }
        break;
      case ApiStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error ?? 'Sign in failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
        break;
      case ApiStatus.loading:
      case ApiStatus.initial:
        // Handle loading and initial states in UI
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(16)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
              vertical: 32,
            ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  'SIGN IN',
                  style: customTextTheme.displayMedium?.copyWith(
                    fontSize:
                        ResponsiveBreakpoints.of(context).isDesktop ? 48 : 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your credentials to access your account',
                  style: customTextTheme.bodyMedium?.copyWith(
                    color: Colors.grey[300],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Email Field
                Text(
                  'EMAIL',
                  style: customTextTheme.titleMedium?.copyWith(
                    fontFamily: 'Kenzo',
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: courierText.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: courierText.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFF00bcd5), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Password Field
                Text(
                  'PASSWORD',
                  style: customTextTheme.titleMedium?.copyWith(
                    fontFamily: 'Kenzo',
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: courierText.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: courierText.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFF00bcd5), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    _handleSignIn();
                  },
                ),
                const SizedBox(height: 32),

                // Sign In Button
                ValueListenableBuilder(
                  valueListenable: authNotifier.auth,
                  builder: (context, authState, child) {
                    final isLoading = authState.status == ApiStatus.loading;
                    return isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00bcd5),
                            ),
                          )
                        : XButton(
                            text: 'SIGN IN',
                            textStyle: customTextTheme.titleMedium?.copyWith(
                              fontFamily: 'Kenzo',
                              letterSpacing: 1.2,
                            ),
                            borderColor: const Color(0xFF00bcd5),
                            paddingButton: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            onPressed: _handleSignIn,
                          );
                  },
                ),
                const SizedBox(height: 24),

                // Forgot Password Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.goNamed('forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: customTextTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF00bcd5),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF00bcd5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: customTextTheme.bodyMedium?.copyWith(
                        color: Colors.grey[300],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed('sign-up');
                      },
                      child: Text(
                        'Sign Up',
                        style: customTextTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF00bcd5),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF00bcd5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      // The auth state listener (_handleAuthStateChange) will handle the response
      await authNotifier.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
