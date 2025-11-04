import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_locationfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/custom_appbar.dart';
import '../../../../core/common/custom_phonetextfiled.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/validation/validation_helper.dart';
import '../state/bloc/register_bloc/register_bloc.dart';
import 'login_screen.dart';

class RegisterDetailsScreen extends StatelessWidget {
  RegisterDetailsScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgresserCubit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          
          return RegisterResponsiveWrapper(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            formKey: _formKey,
          );
        },
      ),
    );
  }
}

class RegisterResponsiveWrapper extends StatefulWidget {
  const RegisterResponsiveWrapper({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;

  @override
  State<RegisterResponsiveWrapper> createState() => _RegisterResponsiveWrapperState();
}

class _RegisterResponsiveWrapperState extends State<RegisterResponsiveWrapper> {
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
          horizontal: widget.screenWidth * 0.09,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register here',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            ConstantWidgets.hight10(context),
            Text(
              'Please enter your data to complete your account registration process.',
            ),
            ConstantWidgets.hight20(context),
            DetilsFormField(
              screenWidth: widget.screenWidth,
              screenHight: widget.screenHeight,
              formKey: widget.formKey,
            ),
            ConstantWidgets.hight10(context),
            LoginPolicyWidget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight,
              onRegisterTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              suffixText: "Already have an account? ",
              prefixText: "Login",  
            ),
          ],
        ),
      ),
    );
  }

  // Web Layout - Varied centered design approach
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
              maxWidth: 600,
              minHeight: widget.screenHeight * 0.9,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                _buildMainFormCard(),
                ConstantWidgets.hight10(context),
                _buildBottomNavigationCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Main form card with glassmorphism effect
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
              Icons.person_add_alt_1,
              color: AppPalette.whiteColor,
              size: 24,
            ),
          ),
          
          ConstantWidgets.hight10(context),
          Text(
            'Create Your Account',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        
          Text(
            'Join thousands of successful barbers worldwide',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12
            ),
          ),
          
          ConstantWidgets.hight30(context),
          EnhancedRegistrationForm(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            formKey: widget.formKey,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppPalette.hintColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user,
                size: 16,
                color: AppPalette.greenColor,
              ),
              Text(
                'Secure & Trusted Platform',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              children: [
                TextSpan(
                  text: 'Sign In',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppPalette.buttonColor,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced registration form for web with better styling
class EnhancedRegistrationForm extends StatefulWidget {
  const EnhancedRegistrationForm({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;

  @override
  State<EnhancedRegistrationForm> createState() => _EnhancedRegistrationFormState();
}

class _EnhancedRegistrationFormState extends State<EnhancedRegistrationForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ventureNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ventureNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            controller: nameController,
            validate: ValidatorHelper.validateText,
          ),
          
          TextFormFieldWidget(
            label: 'Business Name',
            hintText: 'Enter your business name',
            prefixIcon: Icons.business_outlined,
            controller: ventureNameController,
            validate: ValidatorHelper.validateText,
          ),
          
          TextfiledPhone(
            label: "Phone Number",
            hintText: "Enter your phone number",
            prefixIcon: Icons.phone_outlined,
            controller: phoneController,
            validator: ValidatorHelper.validatePhoneNumber,
          ),
          
          LocationTextformWidget.locationAccessField(
            label: 'Business Address',
            hintText: 'Enter address or select from map',
            prefixIcon: Icons.location_on_outlined,
            controller: addressController,
            validator: ValidatorHelper.validateLocation,
            prefixClr: AppPalette.blackColor,
            suffixClr: AppPalette.buttonColor,
            action: () {
              Navigator.pushNamed(context, AppRoutes.map, arguments: addressController);
            },
            suffixIcon: Icons.map_outlined,
            context: context,
          ),
          ConstantWidgets.hight20(context),
          CustomButton(text: 'Continue Registration', onPressed: () => _handleSubmit()),
          ConstantWidgets.hight20(context),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (widget.formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(RegisterPersonInfo(
        name: nameController.text.trim(),
        venturename: ventureNameController.text.trim(),
        phonNumber: phoneController.text,
        address: addressController.text,
      ));  
      Navigator.pushNamed(context, AppRoutes.registerCredential, arguments: addressController);
    } else {
      CustomSnackBar.show(
        context,
        message: 'Please fill in all the required fields before proceeding.',
        textAlign: TextAlign.center,
        backgroundColor: AppPalette.redColor,
      );
    }
  }
}

class DetilsFormField extends StatefulWidget {
  const DetilsFormField({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHight;
  final GlobalKey<FormState> formKey;

  @override
  State<DetilsFormField> createState() => _DetilsFormFieldState();
}

class _DetilsFormFieldState extends State<DetilsFormField> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ventureNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ventureNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: 'Full Name',
            hintText: 'Authorized Person Name',
            prefixIcon: CupertinoIcons.person_fill,
            controller: nameController,
            validate: ValidatorHelper.validateText,
          ),
          TextFormFieldWidget(
            label: 'Venture name',
            hintText: 'Registered Venture Name',
            prefixIcon: Icons.add_business,
            controller: ventureNameController,
            validate: ValidatorHelper.validateText,
          ),
          TextfiledPhone(
            label: "Phone Number",
            hintText: "Enter your number",
            prefixIcon: Icons.phone_android,
            controller: phoneController,
            validator: ValidatorHelper.validatePhoneNumber,
          ),
          LocationTextformWidget.locationAccessField(
            label: 'Venture Address',
            hintText: 'Your Answer or Select from the map',
            prefixIcon: CupertinoIcons.location_solid,
            controller: addressController,
            validator: ValidatorHelper.validateLocation,
            prefixClr: AppPalette.blackColor,
            suffixClr: AppPalette.redColor,
            action: () {
              Navigator.pushNamed(context, AppRoutes.map, arguments: addressController);
            },
            suffixIcon: CupertinoIcons.map_pin_ellipse,
            context: context,
          ),
          ConstantWidgets.hight20(context),
      
          CustomButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                context.read<RegisterBloc>().add(RegisterPersonInfo(
                  name: nameController.text.trim(),
                  venturename: ventureNameController.text.trim(),
                  phonNumber: phoneController.text,
                  address: addressController.text,
                ));  
                Navigator.pushNamed(context, AppRoutes.registerCredential, arguments: addressController);
              } else {
                CustomSnackBar.show(
                  context,
                  message:'Please fill in all the required fields before proceeding.',
                  textAlign: TextAlign.center,
                  backgroundColor: AppPalette.redColor,
                );
              }
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }
}
