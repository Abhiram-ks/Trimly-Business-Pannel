import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/widget/register_bloc/register_state_handle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/validation/validation_helper.dart';

class RegisterCredentialsScreen extends StatelessWidget {
  RegisterCredentialsScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgresserCubit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          
          return CredentialsResponsiveWrapper(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            formKey: _formKey,
          );
        },
      ),
    );
  }
}

class CredentialsResponsiveWrapper extends StatefulWidget {
  const CredentialsResponsiveWrapper({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;

  @override
  State<CredentialsResponsiveWrapper> createState() => _CredentialsResponsiveWrapperState();
}

class _CredentialsResponsiveWrapperState extends State<CredentialsResponsiveWrapper> {
  // Define responsive breakpoints
  bool get isMobile => widget.screenWidth < 600;
  bool get isWeb => widget.screenWidth >= 600;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppPalette.buttonColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isMobile ? null : const Color(0xFFF5F7FA),
          appBar: isMobile ? const CustomAppBar() : null,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: isMobile ? _buildMobileLayout() : _buildWebLayout(),
          ),
        ),
      ),
    );
  }

  // Mobile Layout - Original design preserved
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.screenWidth * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join Us Today',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            ConstantWidgets.hight10(context),
            const Text(
              'Create your account and unlock a world of possibilities.',
            ),
            ConstantWidgets.hight20(context),
            CredentialsFormField(
              screenWidth: widget.screenWidth,
              screenHight: widget.screenHeight,
              formKey: widget.formKey,
            ),
          ],
        ),
      ),
    );
  }

  // Web Layout - Centered design approach
  Widget _buildWebLayout() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          focal: Alignment.center,
          radius: 2.0,
          colors: [
            AppPalette.hintColor,
            AppPalette.whiteColor,
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 550,
              minHeight: widget.screenHeight * 0.85,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMainFormCard(),
                ConstantWidgets.hight10(context),
                _buildSecurityBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Main form card with modern design
  Widget _buildMainFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.blackColor.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppPalette.whiteColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPalette.buttonColor,
                  AppPalette.buttonColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lock_person,
              color: AppPalette.whiteColor,
              size: 24,
            ),
          ),
          
          ConstantWidgets.hight10(context),
          Text(
            'Secure Your Account',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        
          const Text(
            'Set up your login credentials to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          
          ConstantWidgets.hight30(context),
          EnhancedCredentialsForm(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            formKey: widget.formKey,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppPalette.hintColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.security,
            size: 18,
            color: AppPalette.greenColor,
          ),
          const SizedBox(width: 8),
          Text(
            'End-to-End Encrypted & Secure',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced credentials form for web with better styling
class EnhancedCredentialsForm extends StatefulWidget {
  const EnhancedCredentialsForm({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;

  @override
  State<EnhancedCredentialsForm> createState() => _EnhancedCredentialsFormState();
}

class _EnhancedCredentialsFormState extends State<EnhancedCredentialsForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: "Email Address",
            hintText: "Enter your email address",
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            validate: ValidatorHelper.validateEmailId,
          ),
          TextFormFieldWidget(
            label: 'Create Password',
            hintText: 'Enter a strong password',
            isPasswordField: true,
            prefixIcon: Icons.lock_outline,
            controller: passwordController,
            validate: ValidatorHelper.validatePassword,
          ),
          TextFormFieldWidget(
            label: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: Icons.lock_outline,
            controller: confirmPasswordController,
            validate: (val) {
              return ValidatorHelper.validatePasswordMatch(
                passwordController.text,
                val,
              );
            },
            isPasswordField: true,
          ),
          ConstantWidgets.hight20(context),
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, register) {
              handleRegisterState(context, register);
            },
            child: CustomButton(
              text: 'Complete Registration',
              onPressed: () => _handleSubmit(),
            ),
          ),
          ConstantWidgets.hight20(context),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (widget.formKey.currentState!.validate()) {
      final registerBloc = context.read<RegisterBloc>();
      registerBloc.add(
        RegisterCredential(
          email: emailController.text,
          password: passwordController.text,
          isVerified: false,
          isBloc: false,
        ),
      );
    } else {
      CustomSnackBar.show(
        context,
        message: 'Please fill in all the required fields before proceeding.',
        backgroundColor: AppPalette.redColor,
        textAlign: TextAlign.center,
      );
    }
  }
}

class CredentialsFormField extends StatefulWidget {
  const CredentialsFormField({
    super.key,
    required this.screenWidth,
    required this.formKey,
    required this.screenHight,
  });

  final double screenWidth;
  final double screenHight;
  final GlobalKey<FormState> formKey;

  @override
  State<CredentialsFormField> createState() => _CredentialsFormFieldState();
}

class _CredentialsFormFieldState extends State<CredentialsFormField> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: "Email",
            hintText: "Enter Email id",
            prefixIcon: CupertinoIcons.mail_solid,
            controller: emailController,
            validate: ValidatorHelper.validateEmailId,
          ),
          TextFormFieldWidget(
            label: 'Create Password',
            hintText: 'Enter Password',
            isPasswordField: true,
            prefixIcon: CupertinoIcons.padlock_solid,
            controller: passwordController,
            validate: ValidatorHelper.validatePassword,
          ),
          TextFormFieldWidget(
            label: 'Confirm Password',
            hintText: 'Enter Password',
            prefixIcon: CupertinoIcons.padlock_solid,
            controller: confirmPasswordController,
            validate: (val) {
              return ValidatorHelper.validatePasswordMatch(
                passwordController.text,
                val,
              );
            },
            isPasswordField: true,
          ),
          ConstantWidgets.hight30(context),
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, register) {
              handleRegisterState(context, register);
            },
            child: CustomButton(
              text: 'Register',
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  final registerBloc = context.read<RegisterBloc>();
                  registerBloc.add(
                    RegisterCredential(
                      email: emailController.text,
                      password: passwordController.text,
                      isVerified: false,
                      isBloc: false,
                    ),
                  );
                } else {
                  CustomSnackBar.show(
                    context,
                    message: 'Please fill in all the required fields before proceeding.',
                    backgroundColor: AppPalette.redColor,
                    textAlign: TextAlign.center,
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
