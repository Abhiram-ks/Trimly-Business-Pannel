import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/wallet_widget/wallet_body_widget.dart';
import '../../../widget/wallet_widget/wallet_web_layout_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (_) => sl<FetchWalletBloc>()),
       BlocProvider(create: (_) => sl<FetchBookingWithUserBloc>()),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;
        final bool isWebView = screenWidth >= 600;

        return SafeArea(
            child: Scaffold(
          appBar: CustomAppBar2(
            title: 'My Wallet',
            isTitle: true,
            backgroundColor: AppPalette.whiteColor,
            titleColor: AppPalette.blackColor,
            iconColor: AppPalette.blackColor,
          ),
          body: isWebView
              ? WalletWebLayout(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                )
              : WalletScreenWidget(
                  screenWidth: screenWidth, screenHeight: screenHeight),
        ));
      }),
    );
  }
}