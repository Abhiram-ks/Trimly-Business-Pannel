import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/routes/routes.dart' show AppRoutes;
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/presentation/widget/home_widget/home_image_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import '../../state/bloc/lauch_service_bloc/lauch_service_bloc.dart';
import '../../widget/home_widget/time_line_builder_pending_widget.dart' show TimelineBuilderPendings;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LauchServiceBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final isWebView = screenWidth >= 600;

          return Scaffold(
            appBar: CustomAppBar2(
              isTitle: true,
              title: 'Dashboard Overview',
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.wallet);
                  },
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.notification);
                  },
                  icon: const Icon(
                    Icons.notifications_active_sharp,
                    color: AppPalette.buttonColor,
                  ),
                ),
                ConstantWidgets.width20(context),
              ],
            ),
            body: isWebView
                ? HomeWebLayout(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  )
                : HomePageCustomScrollViewWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
          );
        },
      ),
    );
  }
}

// Web Layout - Split two-column design
class HomeWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const HomeWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side - Banner Section
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppPalette.buttonColor.withValues(alpha: 0.05),
                  AppPalette.whiteColor,
                  AppPalette.hintColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: WebBannerSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
        
        // Right Side - Content Section
        Expanded(
          flex: 6,
          child: Container(
            color: AppPalette.whiteColor,
            child: WebContentSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
      ],
    );
  }
}

// Web Banner Section - Left Side
class WebBannerSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const WebBannerSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWebView = screenWidth >= 600;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<FetchBannersBloc, FetchBannerState>(
              builder: (context, state) {
                if (state is FetchBannersLoaded) {
                  return Container(
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.blackColor.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ImageSlider(banners: state.banners, isWebView:  isWebView),
                    ),
                  );
                } else if (state is FetchBannersLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                    highlightColor: AppPalette.whiteColor,
                    child: Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppPalette.greyColor,
                      ),
                    ),
                  );
                }
                return ConstantWidgets.hight20(context);
              },
            ),
            ConstantWidgets.hight30(context),
            Text(
              'Welcome to Your',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppPalette.blackColor.withValues(alpha: 0.7),
              ),
            ),
            Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppPalette.buttonColor,
                height: 1.2,
              ),
            ),
            Text(
              'Manage your bookings, track appointments, and grow your business all in one place.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
             ConstantWidgets.hight10(context),
          ],
        ),
      ),
    );
  }
}

// Web Content Section - Right Side
class WebContentSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const WebContentSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
       final bool isWebView = screenWidth >= 600;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppPalette.buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Track Upcoming Bookings',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ConstantWidgets.hight10(context),
             Padding(
               padding: EdgeInsets.symmetric(horizontal:isWebView ? screenWidth * 0.07 : 0),
               child: const TimelineBuilderPendings(),
             ),
            
            
            ConstantWidgets.hight10(context),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppPalette.buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ConstantWidgets.width10(context),
                Text(
                  'Track Booking Status',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            ConstantWidgets.hight10(context),
            
            Text(
              "Easily track and manage your bookings, view detailed history and payments, and stay updated with notifications for upcoming appointments.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
              
              const SizedBox(height: 60),
            Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppPalette.hintColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.blackColor.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppImages.appLogo,
                        height: 60,
                        width: 60,
                      ),
                      ),
                      ConstantWidgets.hight10(context),
                    Text(
                      "No bookings yet",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ConstantWidgets.hight10(context),
                    Text(
                      "Your upcoming bookings will appear here",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppPalette.blackColor.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageCustomScrollViewWidget extends StatefulWidget {
  const HomePageCustomScrollViewWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<HomePageCustomScrollViewWidget> createState() =>
      _HomePageCustomScrollViewWidgetState();
}

class _HomePageCustomScrollViewWidgetState
    extends State<HomePageCustomScrollViewWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          HomeScreenBodyWidget(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
          ),
        ],
      ),
    );
  }
}

class HomeScreenBodyWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const HomeScreenBodyWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWebView = screenWidth >= 600;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<FetchBannersBloc, FetchBannerState>(
            builder: (context, state) {
              if (state is FetchBannersLoaded) {
                return ImageSlider(banners: state.banners, isWebView: isWebView);
              } else if (state is FetchBannersLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                  highlightColor: AppPalette.whiteColor,
                  child: ImageSlider(
                    isWebView: isWebView,
                    banners: BannerEntity(
                      bannerImage: [AppImages.appLogo, AppImages.appLogo],
                      index: 1,
                    ),
                  ),
                );
              }
              return ConstantWidgets.hight10(context);
            },
          ),
          ConstantWidgets.hight30(context),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  screenWidth > 600 ? screenWidth * .15 : screenWidth * .04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Upcoming Bookings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                  ConstantWidgets.hight10(context),
                TimelineBuilderPendings(),
                ConstantWidgets.hight10(context),
                Text(
                  'Track Booking Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Easily track and manage your bookings, view detailed history and payments, and stay updated with notifications for upcoming appointments.",
                  style: TextStyle(fontSize: 10),
                ),
                ConstantWidgets.hight30(context),
                Center(
                  child: Image.asset(AppImages.appLogo, height: 50, width: 50),
                ),
                ConstantWidgets.hight10(context),
                Center(
                  child: Text(
                    "No bookings yet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Unable to connect to the server. Please contact the administrator for assistance.",
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
