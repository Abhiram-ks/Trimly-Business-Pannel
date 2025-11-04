import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/common/custom_testfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart' show AppPalette;
import 'package:barber_pannel/core/validation/validation_helper.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection_contains.dart' show sl;
import '../../../../core/images/app_image.dart';
import '../state/bloc/password_bloc.dart/password_bloc.dart';

class PasswordScreen extends StatelessWidget {
  final bool isWhat;
  PasswordScreen({super.key, required this.isWhat});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<PasswordBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          
          return ColoredBox(
            color: AppPalette.buttonColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: AppPalette.whiteColor,
                appBar: screenWidth < 600 ? CustomAppBar() : null,
                resizeToAvoidBottomInset: false,
                body: PasswordBodyWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  formKey: _formKey,
                  isWhat: isWhat,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PasswordBodyWidget extends StatefulWidget {
  const PasswordBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
    required this.isWhat,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isWhat;
  final GlobalKey<FormState> formKey;

  @override
  State<PasswordBodyWidget> createState() => _PasswordBodyWidgetState();
}

class _PasswordBodyWidgetState extends State<PasswordBodyWidget> {
  final emailController = TextEditingController();

  // Define responsive breakpoints
  bool get isMobile => widget.screenWidth < 600;
  bool get isWeb => widget.screenWidth >= 600;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: isMobile ? _buildMobileLayout() : _buildWebLayout(),
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
              widget.isWhat ? 'Forgot password?' : 'Change password?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            ConstantWidgets.hight10(context),
            Text(
              widget.isWhat
                  ? "Enter your registered email address to receive a password reset link. Make sure to check your email for further instructions."
                  : "Enter your registered email address to receive a password-changing link. Make sure to check your email for further instructions. After the process, your password will be updated.",
            ),
            ConstantWidgets.hight50(context),
            Form(
              key: widget.formKey,
              child: TextFormFieldWidget(
                label: 'Email',
                hintText: "Enter Email id",
                prefixIcon: CupertinoIcons.mail_solid,
                controller: emailController,
                validate: ValidatorHelper.validateEmailId,
              ),
            ),
            ConstantWidgets.hight30(context),
            BlocListener<PasswordBloc, PasswordState>(
              listener: (context, state) {
                handPasswordState(context, state);
              },
              child: Builder(
                builder: (context) {
                  final passwordBloc = context.read<PasswordBloc>();
                  return CustomButton(
                    text: "Verify",
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        passwordBloc.add(PasswordRequestedEvent(email: emailController.text.trim()));
                      } else {
                        CustomSnackBar.show(
                          context,
                          message: 'Fill in necessary data before proceeding.',
                          textAlign: TextAlign.center,
                          backgroundColor: AppPalette.redColor,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Web Layout - Two-section design with branding and form
  Widget _buildWebLayout() {
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
          // Left Side - Branding Section
          Expanded(
            flex: 1,
            child: _buildPasswordBrandingSection(),
          ),
          
          // Right Side - Form Section
          Expanded(
            flex: 1,
            child: _buildPasswordFormSection(),
          ),
        ],
      ),
    );
  }

  // Left side branding section for password reset
  Widget _buildPasswordBrandingSection() {
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
            
            // Company name
            Text(
              'Fresh Fade',
              style: GoogleFonts.bellefair(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppPalette.whiteColor,
                height: 1.2,
              ),
            ),
            
            // Tagline
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
            
            // Description for password reset
            Text(
              widget.isWhat
                  ? 'Secure password recovery made simple. Enter your email to receive reset instructions and regain access to your account.'
                  : 'Update your password securely. Enter your email to receive instructions for changing your account password.',
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

  // Right side form section
  Widget _buildPasswordFormSection() {
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
                _buildPasswordWebHeader(),
                
                const SizedBox(height: 40),
                
                // Form
                _buildPasswordWebForm(),
                
                const SizedBox(height: 32),
                
                // Back to login link
                _buildPasswordWebFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Password web form header
  Widget _buildPasswordWebHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.buttonColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            widget.isWhat ? Icons.lock_reset : Icons.lock_outline,
            size: 32,
            color: AppPalette.buttonColor,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          widget.isWhat ? 'Reset Password' : 'Change Password',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          widget.isWhat
              ? 'Enter your email to receive reset instructions'
              : 'Enter your email to receive change instructions',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Password web form
  Widget _buildPasswordWebForm() {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormFieldWidget(
            label: 'Email Address',
            hintText: "Enter your registered email",
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            validate: ValidatorHelper.validateEmailId,
          ),
          
          const SizedBox(height: 32),
          
          // Submit button
          BlocListener<PasswordBloc, PasswordState>(
            listener: (context, state) {
              handPasswordState(context, state);
            },
            child: SizedBox(
              height: 52,
              child: CustomButton(
                text: widget.isWhat ? "Send Reset Link" : "Send Change Link",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                borderRadius: 8,
                onPressed: () {
                  if (widget.formKey.currentState!.validate()) {
                    final passwordBloc = context.read<PasswordBloc>();
                    passwordBloc.add(PasswordRequestedEvent(email: emailController.text.trim()));
                  } else {
                    CustomSnackBar.show(
                      context,
                      message: 'Please enter a valid email address.',
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

  // Password web footer
  Widget _buildPasswordWebFooter() {
    return Column(
      children: [
        // Divider
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[200],
          margin: const EdgeInsets.symmetric(vertical: 24),
        ),
        
        // Back to login link
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Remember your password? ",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            children: [
              TextSpan(
                text: "Back to Login",
                style: GoogleFonts.poppins(
                  color: AppPalette.buttonColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}



  void handPasswordState(BuildContext context, PasswordState state){
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is PasswordLoadingState) {
    buttonCubit.startLoading();
  }
  if (state is PasswordSuccessState) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: 'Done! Open your inbox and follow the instructions to reset your password.',textAlign: TextAlign.center,backgroundColor: AppPalette.greenColor);
  } else if(state is PasswordErrorState){
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.message,textAlign: TextAlign.center,backgroundColor: AppPalette.redColor);
  }else if(state is PasswordAlertBoxState){
    buttonCubit.stopLoading();
    CustomCupertinoDialog.show(
      context: context, 
      title: "Password Mangement Alert", 
      message: "Are you sure you want to send a password reset email to ${state.email}?. Validate before proceeding.", 
      onTap: () {
        context.read<PasswordBloc>().add(PasswordConfirmationEvent());
      }, 
      firstButtonText: "Send Mail", 
      secondButtonText: "Cancel");
  }

}