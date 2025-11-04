import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/revenue/revenu_screen.dart';

/// Web Layout - Split two-column design for Revenue Screen
class RevenueWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const RevenueWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side - Revenue Info & Overview
        Expanded(
          flex: 5,
          child: ColoredBox(
            color: AppPalette.whiteColor,
            child: RevenueWebLeftSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),

        // Right Side - Revenue Metrics Grid
        Expanded(
          flex: 6,
          child: Container(
            color: AppPalette.whiteColor,
            child: RevenueWebRightSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
      ],
    );
  }
}

/// Left Section - Revenue Overview and Information
class RevenueWebLeftSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const RevenueWebLeftSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Row(
              children: [
                Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppPalette.buttonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  child: Text(
                    'Revenue Overview',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            ConstantWidgets.hight10(context),

            // Description
            Text(
              'Track revenue effectively and monitor your shop\'s financial performance. Revenue tracking helps with monitoring, analysis, and provides visual presentation to show your revenue status and trends.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor,
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight10(context),

            // Main Revenue Card
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppPalette.buttonColor,
                      Color.fromARGB(255, 154, 108, 232),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.buttonColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.auto_graph_sharp,
                            color: AppPalette.whiteColor,
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Track and Analyze Revenue',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppPalette.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Here\'s an overview of your shop',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppPalette.whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstantWidgets.hight20(context),

            // Metrics Section Title
            Text(
              'Key Performance Metrics',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPalette.blackColor,
              ),
            ),
            ConstantWidgets.hight10(context),

            // Info Description
            Text(
              'View detailed statistics about your business performance, including total revenue, daily earnings, services offered, customer base, work hours, and booking history.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppPalette.blackColor.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            ConstantWidgets.hight20(context),

            // Quick Stats Cards
            _buildQuickStatCard(
              context: context,
              icon: Icons.trending_up,
              title: 'Revenue Tracking',
              description: 'Monitor your earnings and financial growth',
              color: AppPalette.greenColor,
            ),
            const SizedBox(height: 12),
            _buildQuickStatCard(
              context: context,
              icon: Icons.people_outline,
              title: 'Customer Insights',
              description: 'Track your growing customer base',
              color: AppPalette.blueColor,
            ),
            const SizedBox(height: 12),
            _buildQuickStatCard(
              context: context,
              icon: CupertinoIcons.time,
              title: 'Work Analytics',
              description: 'View your total working hours and efficiency',
              color: AppPalette.orengeColor,
            ),
            ConstantWidgets.hight20(context),

            // Additional Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppPalette.buttonColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppPalette.buttonColor,
                    size: 24,
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Text(
                      'For assistance with revenue features, please connect with administration. All metrics are updated in real-time.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppPalette.blackColor.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.blackColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppPalette.blackColor.withValues(alpha: 0.6),
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

/// Right Section - Revenue Metrics Grid
class RevenueWebRightSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const RevenueWebRightSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
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
                ConstantWidgets.width20(context),
                Text(
                  'Revenue Metrics',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              'Comprehensive view of all your business performance indicators.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight20(context),

            // Revenue Metrics Grid
            SizedBox(
              height: screenHeight * 0.85,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InkWell(
                    onTap: () {},
                    child: RevenueDetailsContainer(
                      gradient: const LinearGradient(
                        colors: [
                          AppPalette.buttonColor,
                          Color.fromARGB(255, 190, 157, 248),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Total Revenue',
                      description: 'A clear snapshot of your earnings.',
                      icon: Icons.currency_rupee_sharp,
                      salesText: 'No Bookings',
                      iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: RevenueDetailsContainer(
                      gradient: const LinearGradient(
                        colors: [
                          AppPalette.buttonColor,
                          Color.fromARGB(255, 190, 157, 248),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Today\'s Earnings',
                      description: 'A focused glimpse of your daily hustle.',
                      icon: Icons.shopping_basket,
                      salesText: 'No Bookings',
                      iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.serviceManage);
                    },
                    child: BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>(
                      builder: (context, state) {
                        String serviceCount = '0';
                        if (state is FetchBarberServiceLoading) {
                          serviceCount = 'Loading...';
                        } else if (state is FetchBarberServiceLoaded) {
                          serviceCount = state.services.length.toString();
                        } else if (state is FetchBarberServiceEmpty) {
                          serviceCount = 'No services found';
                        } else if (state is FetchBarberServiceError) {
                          serviceCount = 'Error: Try Again';
                        }
                        return RevenueDetailsContainer(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 190, 157, 248),
                              AppPalette.buttonColor,
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          title: 'Total Services',
                          description: "The total count of every service you've provided",
                          icon: CupertinoIcons.wrench_fill,
                          salesText: serviceCount,
                          iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: RevenueDetailsContainer(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 190, 157, 248),
                          AppPalette.buttonColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Total Customers',
                      description: 'The clients who\'ve chosen you as their go-to barber',
                      icon: Icons.people,
                      salesText: 'No Bookings',
                      iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: RevenueDetailsContainer(
                      gradient: const LinearGradient(
                        colors: [
                          AppPalette.buttonColor,
                          Color.fromARGB(255, 190, 157, 248),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Work Legacy',
                      description: "The accumulated hours of your craft, reflecting a lifetime of skill and passion.",
                      icon: CupertinoIcons.timer_fill,
                      salesText: 'No Bookings',
                      iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: RevenueDetailsContainer(
                      gradient: const LinearGradient(
                        colors: [
                          AppPalette.buttonColor,
                          Color.fromARGB(255, 190, 157, 248),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Total Bookings',
                      description: 'Every booking is a step towards building your success.',
                      icon: Icons.book,
                      salesText: 'No Bookings',
                      iconColor: AppPalette.whiteColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

