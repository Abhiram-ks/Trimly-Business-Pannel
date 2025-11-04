import 'package:barber_pannel/features/auth/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/widget/login_widget/login_state_handle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/di/injection_contains.dart';
import '../../../../core/images/app_image.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/validation/validation_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<LoginBloc>()),
      ],
      child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;
            
            return ColoredBox(
              color:  AppPalette.buttonColor,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: AppPalette.whiteColor,
                  resizeToAvoidBottomInset: false,
                  body: LoginBodyWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}

class LoginBodyWidget extends StatelessWidget {
  const LoginBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LoginScreenBody(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ),
    );
  }
}

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  bool get isMobile => screenWidth < 600;
  bool get isWeb => screenWidth >= 600;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileLayout(context);
    } else {
      return _buildWebLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Container(
        width: screenWidth * 0.87,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor.withAlpha((0.8 * 255).round()),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppPalette.blackColor.withAlpha((0.1 * 255).round()),
              blurRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginDetailsWidget(screenWidth: screenWidth),
              LoginPolicyWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onRegisterTap: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                suffixText: "Don't have an account? ",
                prefixText: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Web Layout - Two-section design with branding and credentials
  Widget _buildWebLayout(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.center,
          colors: [
            AppPalette.buttonColor,
            Color.fromARGB(255, 176, 153, 216),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildBrandingSection(context),
          ),
        
          Expanded(
            flex: 1,
            child: _buildCredentialsSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPalette.buttonColor.withAlpha((0.1 * 255).round()),
            AppPalette.buttonColor.withAlpha((0.05 * 255).round()),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.buttonColor.withAlpha((0.2 * 255).round()),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.appLogo,
                width: 80,
                height: 80,
              ),
            ),
            ConstantWidgets.hight20(context),
          
            Text(
              'Fresh Fade',
              style: GoogleFonts.bellefair(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppPalette.whiteColor,
                height: 1.2,
              ),
            ),
            Text(
              'Professional Barber Management System',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppPalette.whiteColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
           ConstantWidgets.hight10(context),
            Text(
              'Streamline your barber shop operations with our comprehensive management panel. From appointments to analytics, everything you need in one place.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppPalette.whiteColor,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Right side credentials section
  Widget _buildCredentialsSection(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildWebCredentialsHeader(),
                
                const SizedBox(height: 40),
                
                // Login Form
                WebLoginForm(),
                
                const SizedBox(height: 32),
                
                // Footer with Sign up link
                _buildWebCredentialsFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Web credentials header
  Widget _buildWebCredentialsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Welcome message
        Text(
          'Welcome Back',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Sign in to your account',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Web credentials footer
  Widget _buildWebCredentialsFooter(BuildContext context) {
    return Column(
      children: [
        // Divider
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[200],
          margin: const EdgeInsets.symmetric(vertical: 24),
        ),
        
        // Sign up link
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Don't have an account? ",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            children: [
              TextSpan(
                text: "Sign up",
                style: GoogleFonts.poppins(
                  color: AppPalette.buttonColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginPolicyWidget extends StatelessWidget {
  final Function() onRegisterTap;
  final double screenWidth;
  final double screenHeight;
  final String suffixText;
  final String prefixText;

  const LoginPolicyWidget({
    super.key,
    required this.onRegisterTap,
    required this.screenWidth,
    required this.screenHeight,
    required this.suffixText,
    required this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Or"),
            ),
            Expanded(child: Divider()),
          ],
        ),

        ConstantWidgets.hight10(context),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: suffixText,
              style: const TextStyle(fontSize: 12, color: Colors.black54),

              children: [
                TextSpan(
                  text: "Register",
                  style: TextStyle(color: AppPalette.buttonColor),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          onRegisterTap();
                        },
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "By creating or logging into an account you are agreeing with our ",
              style: const TextStyle(fontSize: 12, color: Colors.black54),

              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(color: Colors.blue[700]),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
      ],
    );
  }
}

class LoginDetailsWidget extends StatelessWidget {
  final double screenWidth;

  const LoginDetailsWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.appLogo, width: 60, height: 60),
        Text(
          'Fresh Fade',
          textAlign: TextAlign.center,
          style: GoogleFonts.bellefair(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppPalette.blackColor,
          ),
        ),
        Text(
          'Innovate, Execute, Succeed',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 11, color: AppPalette.greyColor),
        ),
        ConstantWidgets.hight10(context),
        Text(
          "Welcome Back!",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ConstantWidgets.hight10(context),
        LoginCredential(),
        ConstantWidgets.hight10(context),
      ],
    );
  }
}

// Web-specific login form component
class WebLoginForm extends StatefulWidget {
  const WebLoginForm({super.key});

  @override
  State<WebLoginForm> createState() => _WebLoginFormState();
}

class _WebLoginFormState extends State<WebLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormFieldWidget(
            hintText: 'Enter your email address',
            label: 'Email Address',
            validate: ValidatorHelper.validateEmailId,
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
          ),
          
          // Password field
          TextFormFieldWidget(
            hintText: 'Enter your password',
            label: 'Password',
            validate: ValidatorHelper.validatePassword,
            controller: _passwordController,
            isPasswordField: true,
            prefixIcon: Icons.lock_outline,
          ),
          
          // Forgot password link
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.password, arguments: true);
              },
              child: Text(
                "Forgot your password?",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppPalette.buttonColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sign in button
          BlocListener<LoginBloc, LoginState>(
            listener: (context, login) {
              handleLoginState(context, login);
            },
            child: SizedBox(
              height: 52,
              child: CustomButton(
                text: 'Sign In',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                borderRadius: 8,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(
                      LoginActionEvent(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ),
                    );
                  } else {
                    CustomSnackBar.show(
                      context,
                      message: "All fields are required.",
                      textAlign: TextAlign.center,
                      backgroundColor: AppPalette.redColor,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginCredential extends StatefulWidget {
  const LoginCredential({super.key});

  @override
  State<LoginCredential> createState() => _LoginCredentialState();
}

class _LoginCredentialState extends State<LoginCredential> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            hintText: 'Your answer',
            label: 'Email address *',
            validate: ValidatorHelper.validateEmailId,
            controller: _emailController,
          ),
          TextFormFieldWidget(
            hintText: '********',
            label: 'Password',
            validate: ValidatorHelper.validatePassword,
            controller: _passwordController,
            isPasswordField: true,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.lock_clock_outlined,
                size: 18,
                color: AppPalette.buttonColor,
              ),
              ConstantWidgets.width20(context),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.password, arguments: true);
                },
                child: Text(
                  "Forgot password?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.buttonColor,
                  ),
                ),
              ),
            ],
          ),
          ConstantWidgets.hight20(context),
            BlocListener<LoginBloc, LoginState>(
          listener: (context, login) {
           handleLoginState(context, login);
          },
          child:
          CustomButton(
            text: 'Login',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(
                  LoginActionEvent(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              } else {
                CustomSnackBar.show(
                  context,
                  message: "All fields are required.",
                  textAlign: TextAlign.center,
                  backgroundColor: AppPalette.redColor,
                );
              }
            },
          ),
          ),
        ],
      ),
    );
  }
}
