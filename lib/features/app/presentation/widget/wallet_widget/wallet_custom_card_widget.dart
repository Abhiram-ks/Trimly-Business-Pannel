import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Row walletBalanceWidget(
    {required BuildContext context,
    required Color iconColor,
    IconData? icon,
    String? titile,
    required String balance,
    required Color balanceColor}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton.filled(
        onPressed: () {},
        icon: Icon(
          icon ?? Icons.account_balance_wallet,
          size: 40,
          color: AppPalette.whiteColor,
        ),
        style: IconButton.styleFrom(
          backgroundColor: iconColor,
          fixedSize: const Size(60, 60),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titile ?? 'Life time Earnings',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              balance,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: balanceColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
