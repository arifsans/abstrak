import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/x_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'SIGN UP',
                    style: customTextTheme.displayMedium?.copyWith(
                      fontSize: ResponsiveBreakpoints.of(context).isDesktop 
                          ? 48 
                          : 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account to join CAPTIVE',
                    style: customTextTheme.bodyMedium?.copyWith(
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Name Field
                  Text(
                    'FULL NAME',
                    style: customTextTheme.titleMedium?.copyWith(
                      fontFamily: 'Kenzo',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: courierText.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
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
                  
                  // Phone Number Field
                  Text(
                    'PHONE NUMBER',
                    style: customTextTheme.titleMedium?.copyWith(
                      fontFamily: 'Kenzo',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: courierText.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number (e.g., 081234567890)',
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '+62',
                          style: courierText.bodyMedium?.copyWith(
                            color: const Color(0xFF00bcd5),
                          ),
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!value.startsWith('08')) {
                        return 'Phone number must start with 08';
                      }
                      if (value.length < 10 || value.length > 13) {
                        return 'Phone number must be between 10-13 digits';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Phone number must contain only digits';
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Confirm Password Field
                  Text(
                    'CONFIRM PASSWORD',
                    style: customTextTheme.titleMedium?.copyWith(
                      fontFamily: 'Kenzo',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: courierText.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Terms and Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF00bcd5),
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: customTextTheme.bodySmall?.copyWith(
                                    color: Colors.grey[300],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: customTextTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF00bcd5),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF00bcd5),
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: customTextTheme.bodySmall?.copyWith(
                                    color: Colors.grey[300],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: customTextTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF00bcd5),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF00bcd5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // SignUp Button
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00bcd5),
                          ),
                        )
                      : XButton(
                          text: 'CREATE ACCOUNT',
                          textStyle: customTextTheme.titleMedium?.copyWith(
                            fontFamily: 'Kenzo',
                            letterSpacing: 1.2,
                          ),
                          borderColor: const Color(0xFF00bcd5),
                          paddingButton: const EdgeInsets.symmetric(
                            vertical: 16, 
                            horizontal: 24,
                          ),
                          onPressed: _handleSignUp,
                        ),
                  const SizedBox(height: 24),
                  
                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: customTextTheme.bodyMedium?.copyWith(
                          color: Colors.grey[300],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed('sign-in');
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

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please accept the Terms and Conditions to continue',
              style: courierText.bodyMedium,
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate registration API call
        await Future.delayed(const Duration(seconds: 2));

        // TODO: Implement actual registration logic here
        // For now, we'll just show a success message and navigate

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Account created successfully! Welcome to CAPTIVE, ${_nameController.text}!',
                style: courierText.bodyMedium,
              ),
              backgroundColor: const Color(0xFF00bcd5),
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigate to profile page
          context.goNamed('profile');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Registration failed: ${e.toString()}',
                style: courierText.bodyMedium,
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
}
