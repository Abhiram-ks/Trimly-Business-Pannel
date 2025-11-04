import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/my_booking_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection_contains.dart';
import '../../../state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';

class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FetchBookingWithUserBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          final bool isWebView = screenWidth > 900;

          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(
                      title: 'Booking Management',
                      isTitle: true,
                      backgroundColor: AppPalette.whiteColor,
                      titleColor: AppPalette.blackColor,
                    ),
              body: isWebView
                  ? _buildWebLayout(screenWidth, screenHeight)
                  : BookingScreenWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWebLayout(double screenWidth, double screenHeight) {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            Container(
              width: screenWidth * 0.30,
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
              ),
              child: _buildWebSidebar(context, screenHeight),
            ),
            Expanded(
              child: Container(
                color: AppPalette.whiteColor,
                child: Column(
                  children: [
                    _buildWebHeader(),
                    
                    Expanded(
                      child: BookingScreenWidget(
                        screenWidth: screenWidth * 0.70,
                        screenHeight: screenHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Web Sidebar with Summary
  Widget _buildWebSidebar(BuildContext context, double screenHeight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantWidgets.hight20(context),
          BlocBuilder<FetchBookingWithUserBloc, FetchBookingWithUserState>(
            builder: (blocContext, state) {
              if (state is FetchBookingWithUserSuccess) {
                final totalBookings = state.bookings.length;
                final completed = state.bookings
                    .where((b) => b.booking.status.toLowerCase() == 'completed')
                    .length;
                final pending = state.bookings
                    .where((b) => b.booking.status.toLowerCase() == 'pending')
                    .length;
                final cancelled = state.bookings
                    .where((b) => b.booking.status.toLowerCase() == 'cancelled')
                    .length;

                return Column(
                  children: [
                    _buildSummaryCard(
                      'Total Bookings',
                      totalBookings.toString(),
                      Icons.calendar_month,
                      AppPalette.blackColor,
                      context,
                    ),
                    ConstantWidgets.hight10(context),
                    _buildSummaryCard(
                      'Completed',
                      completed.toString(),
                      Icons.check_circle,
                      AppPalette.greenColor,
                      context,
                    ),
                    ConstantWidgets.hight10(context),
                    _buildSummaryCard(
                      'Pending',
                      pending.toString(),
                      Icons.pending_actions,
                      AppPalette.orengeColor,
                       context,
                    ),
                    ConstantWidgets.hight10(context),
                    _buildSummaryCard(
                      'Cancelled',
                      cancelled.toString(),
                      Icons.cancel,
                      AppPalette.redColor,
                       context,
                    ),
                  ],
                );
              }
              
              return Column(
                children: [
                  _buildSummaryCard(
                    'Total Bookings',
                    '0',
                    Icons.calendar_month,
                    AppPalette.blackColor,  context,
                  ),
                  ConstantWidgets.hight10(context),
                  _buildSummaryCard(
                    'Completed',
                    '0',
                    Icons.check_circle,
                    AppPalette.greenColor,
                     context,
                  ),
                  ConstantWidgets.hight10(context),
                  _buildSummaryCard(
                    'Pending',
                    '0',
                    Icons.pending_actions,
                    AppPalette.orengeColor,
                    context,
                  ),
                  ConstantWidgets.hight10(context),
                  _buildSummaryCard(
                    'Cancelled',
                    '0',
                    Icons.cancel,
                    AppPalette.redColor,
                    context,
                  ),
                ],
              );
            },
          ),
          
          ConstantWidgets.hight10(context),
          const Text(
            'Quick Info',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          ConstantWidgets.hight20(context),
          
          _buildQuickInfo(
            Icons.info_outline,
            'Keep full control of your appointments',
            context,
          ),
          _buildQuickInfo(
            Icons.visibility_outlined,
            'Monitor booking statuses in real-time',
            context,
          ),
          _buildQuickInfo(
            Icons.people_outline,
            'Access client details instantly',
            context,
          ),
          _buildQuickInfo(
            Icons.schedule,
            'Ensure a smooth schedule every day',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
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
          ConstantWidgets.width10(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppPalette.greyColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppPalette.buttonColor,
          size: 18,
        ),
        ConstantWidgets.width10(context),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Web Header
  Widget _buildWebHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Management Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.blackColor,
                  ),
                ),
                Text(
                  'Manage and track all your appointments',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppPalette.greyColor,
                  ),
                ),
              ],
            ),
          ),
          
          BlocBuilder<FetchBookingWithUserBloc, FetchBookingWithUserState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<FetchBookingWithUserBloc>().add(
                    FetchBookingWithUserRequested(),
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppPalette.buttonColor.withValues(alpha: 0.1),
                  foregroundColor: AppPalette.buttonColor,
                  padding: const EdgeInsets.all(12),
                ),
                tooltip: 'Refresh bookings',
              );
            },
          ),
        ],
      ),
    );
  }
}
