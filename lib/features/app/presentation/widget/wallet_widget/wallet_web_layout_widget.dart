import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/wallet_widget/wallet_bloc_builder_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/wallet_widget/wallet_overview_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Web Layout - Split two-column design for Wallet Screen
class WalletWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const WalletWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ColoredBox(
            color: AppPalette.whiteColor,
            child: WalletWebLeftSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),

        Expanded(
          flex: 6,
          child: Container(
            color: AppPalette.whiteColor,
            child: WalletWebRightSection(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ),
      ],
    );
  }
}

/// Left Section - Wallet Overview and Filter Options
class WalletWebLeftSection extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const WalletWebLeftSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<WalletWebLeftSection> createState() => _WalletWebLeftSectionState();
}

class _WalletWebLeftSectionState extends State<WalletWebLeftSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchWalletBloc>().add(FetchWalletEventStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    'Wallet Overview',
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
            Text(
              'Manage your wallet effortlessly check history, monitor payments, and top up in seconds.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor,
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight10(context),
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
              child: WalletOverviewCard(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
              ),
            ),
            ConstantWidgets.hight20(context),
            Text(
              'Transaction Filters',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPalette.blackColor,
              ),
            ),
            ConstantWidgets.hight20(context),
            WalletWebFilterSection(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight,
            ),
            ConstantWidgets.hight30(context),

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
                      'All transactions are securely processed and updated in real-time.',
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

/// Right Section - Transaction List
class WalletWebRightSection extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const WalletWebRightSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<WalletWebRightSection> createState() => _WalletWebRightSectionState();
}

class _WalletWebRightSectionState extends State<WalletWebRightSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingWithUserBloc>().add(
            FetchBookingWithUserRequested(),
          );
    });
  }

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
                  'Transaction History',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              'View and manage all your wallet transactions in one place.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppPalette.blackColor.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
            ConstantWidgets.hight20(context),

            // Transaction List
            WalletBlocBuilderWidget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight,
            ),
          ],
        ),
      ),
    );
  }
}

/// Web Filter Section - Vertical Cards Layout
class WalletWebFilterSection extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WalletWebFilterSection({
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
          label: 'All Transactions',
          icon: Icons.history,
          color: AppPalette.blackColor,
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserRequested(),
                );
          },
        ),
        const SizedBox(height: 12),
        _buildFilterCard(
          context: context,
          label: 'Credited',
          icon: Icons.arrow_upward_sharp,
          color: AppPalette.greenColor,
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'completed'),
                );
          },
        ),
        const SizedBox(height: 12),
        _buildFilterCard(
          context: context,
          label: 'Debited',
          icon: Icons.arrow_downward_sharp,
          color: AppPalette.redColor,
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'cancelled'),
                );
          },
        ),
        const SizedBox(height: 12),
        _buildFilterCard(
          context: context,
          label: 'Pending',
          icon: Icons.arrow_outward_sharp,
          color: AppPalette.orengeColor,
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'pending'),
                );
          },
        ),
        const SizedBox(height: 12),
        _buildFilterCard(
          context: context,
          label: 'Processing',
          icon: Icons.timer,
          color: AppPalette.blueColor,
          onTap: () {
            context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'timeout'),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.blackColor,
                ),
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

