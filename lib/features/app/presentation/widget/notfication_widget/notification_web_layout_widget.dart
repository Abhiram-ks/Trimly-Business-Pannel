import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/notfication_widget/notification_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Web Layout - Split two-column design for Notification Screen
class NotificationWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const NotificationWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side - Info & Filter Section
        Expanded(
          flex: 5,
          child: ColoredBox(
            color: AppPalette.whiteColor,
            child: NotificationWebLeftSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),

        // Right Side - Notification List Section
        Expanded(
          flex: 6,
          child: Container(
            color: AppPalette.whiteColor,
            child: NotificationWebRightSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
      ],
    );
  }
}

/// Left Section - Information and Filter Options
class NotificationWebLeftSection extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const NotificationWebLeftSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<NotificationWebLeftSection> createState() =>
      _NotificationWebLeftSectionState();
}

class _NotificationWebLeftSectionState
    extends State<NotificationWebLeftSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchBookingWithUserBloc>()
          .add(FetchBookingWithUserFilteredRequested(status: 'timeout'));
    });
  }

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
                    'Notifications',
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
              'Stay updated with important booking alerts, including pending and confirmed appointments. To complete your booking process, long-press the Timeout category.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor,
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight10(context),

            // Info Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppPalette.buttonColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.blackColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: AppPalette.buttonColor,
                    size: 32,
                  ),
                  ConstantWidgets.width10(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.blackColor,
                          ),
                        ),
                        Text(
                          'Long-press Timeout to complete bookings',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppPalette.blackColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ConstantWidgets.hight20(context),
            Text(
              'Notification Filters',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPalette.blackColor,
              ),
            ),
            ConstantWidgets.hight20(context),
            NotificationWebFilterSection(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight,
            ),
            ConstantWidgets.hight20(context),
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
                      'All notifications are updated in real-time. Pull down to refresh for the latest updates.',
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
}

/// Right Section - Notification List
class NotificationWebRightSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const NotificationWebRightSection({
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
                  'Notification History',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              'View and manage all your booking notifications in one place.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight20(context),
            notificationWidgetBuilder(
              context,
              screenHeight,
              screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}

/// Web Filter Section - Vertical Cards Layout
class NotificationWebFilterSection extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const NotificationWebFilterSection({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterCard(
          context: context,
          label: 'Timeout',
          icon: Icons.timer,
          color: AppPalette.blueColor,
          description: 'Long-press to mark as completed',
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'timeout'),
                );
          },
        ),
        const SizedBox(height: 12),
        _buildFilterCard(
          context: context,
          label: 'Pending',
          icon: Icons.pending_actions_rounded,
          color: AppPalette.orengeColor,
          description: 'Awaiting confirmation',
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'pending'),
                );
          },
        ),
      ],
    );
  }

  Widget _buildFilterCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.02),
              color.withValues(alpha: 0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
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
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.blackColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppPalette.blackColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppPalette.greyColor,
            ),
          ],
        ),
      ),
    );
  }
}

