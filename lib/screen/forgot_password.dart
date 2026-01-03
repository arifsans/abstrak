import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/x_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to forgot password state changes
    forgotPasswordNotifier.forgotPassword.addListener(_handleForgotPasswordStateChange);
  }

  @override
  void dispose() {
    forgotPasswordNotifier.forgotPassword.removeListener(_handleForgotPasswordStateChange);
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPasswordStateChange() {
    if (!mounted) return;
    
    final forgotPasswordState = forgotPasswordNotifier.forgotPassword.value;
    
    switch (forgotPasswordState.status) {
      case ApiStatus.success:
        if (forgotPasswordState.data != null) {
          _showSuccessAlert(forgotPasswordState.data!.message);
        }
        break;
      case ApiStatus.error:
        _showErrorAlert(forgotPasswordState.error ?? 'An unexpected error occurred. Please try again.');
        break;
      case ApiStatus.loading:
      case ApiStatus.initial:
        // Handle loading and initial states in UI
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'FORGOT PASSWORD',
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
                  // Title and Description
                  Text(
                    'RESET PASSWORD',
                    style: customTextTheme.displayMedium?.copyWith(
                      fontSize: ResponsiveBreakpoints.of(context).isDesktop ? 36 : 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email address and we\'ll send you instructions to reset your password.',
                    style: customTextTheme.bodyMedium?.copyWith(
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  Text(
                    'EMAIL ADDRESS',
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
                      hintText: 'Enter your email address',
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
                        borderSide: const BorderSide(color: Color(0xFF00bcd5), width: 2),
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
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF00bcd5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Email validation regex
                      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _handleForgotPassword();
                    },
                  ),
                  const SizedBox(height: 32),

                  // Send Reset Link Button
                  ValueListenableBuilder(
                    valueListenable: forgotPasswordNotifier.forgotPassword,
                    builder: (context, forgotPasswordState, child) {
                      final isLoading = forgotPasswordState.status == ApiStatus.loading;
                      return isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00bcd5),
                              ),
                            )
                          : XButton(
                              text: 'SEND RESET LINK',
                              textStyle: customTextTheme.titleMedium?.copyWith(
                                fontFamily: 'Kenzo',
                                letterSpacing: 1.2,
                              ),
                              borderColor: const Color(0xFF00bcd5),
                              paddingButton: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              onPressed: _handleForgotPassword,
                            );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Back to Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: customTextTheme.bodyMedium?.copyWith(
                          color: Colors.grey[300],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushReplacementNamed('sign-in');
                        },
                        child: Text(
                          'Sign In',
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
      ),
    );
  }

  void _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      // The forgot password state listener (_handleForgotPasswordStateChange) will handle the response
      await forgotPasswordNotifier.sendResetEmail(
        email: _emailController.text.trim(),
      );
    }
  }

  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF00bcd5).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00bcd5).withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00bcd5),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'EMAIL SENT!',
                  style: customTextTheme.headlineSmall?.copyWith(
                    fontFamily: 'Kenzo',
                    color: const Color(0xFF00bcd5),
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  message,
                  style: courierText.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: XButton(
                    text: 'OK',
                    textStyle: customTextTheme.titleMedium?.copyWith(
                      fontFamily: 'Kenzo',
                      letterSpacing: 1.2,
                    ),
                    borderColor: const Color(0xFF00bcd5),
                    paddingButton: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    onPressed: () {
                      context.pop();
                      context.goNamed('sign-in');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'RESET FAILED',
                  style: customTextTheme.headlineSmall?.copyWith(
                    fontFamily: 'Kenzo',
                    color: Colors.red,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  message,
                  style: courierText.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: XButton(
                        text: 'TRY AGAIN',
                        textStyle: customTextTheme.titleMedium?.copyWith(
                          fontFamily: 'Kenzo',
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                        borderColor: Colors.red,
                        paddingButton: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: XButton(
                        text: 'BACK',
                        textStyle: customTextTheme.titleMedium?.copyWith(
                          fontFamily: 'Kenzo',
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                        borderColor: Colors.grey,
                        paddingButton: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.goNamed('sign-in');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}