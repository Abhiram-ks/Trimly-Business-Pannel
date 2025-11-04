
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../screens/setting/setting_screen.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final double screenWidth;
  final bool isWebView;

  const ChatAppBar({
    super.key,
    required this.userId,
    required this.screenWidth,
    this.isWebView = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchUserBloc>().add(FetchUserRequest(userId:userId));

    return BlocBuilder<FetchUserBloc, FetchUserState>(
      builder: (context, state) {
         if (state is FetchUserLoaded) {
          final UserEntity user = state.user;

          return AppBar(
            backgroundColor: isWebView ? Color(0xFFF0F2F5) : AppPalette.whiteColor,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: !isWebView,
            elevation:  4,
            shadowColor: AppPalette.blackColor.withValues(alpha: 0.2),
            scrolledUnderElevation: 4,
            titleSpacing: isWebView ? 16 : 0,
            iconTheme: const IconThemeData(color: AppPalette.blackColor),
            leading:  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
            title: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId),
              child: Row(
                children: [
                  Container(
                    decoration: isWebView
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppPalette.buttonColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          )
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width:40,
                        height:  40,
                        child: imageshow(
                          imageUrl: user.photoUrl,
                          imageAsset: AppImages.noImage,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isWebView ? 14 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isWebView ? 17 : 16,
                            color: Color(0xFF111B21),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            if (isWebView)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: AppPalette.buttonColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Flexible(
                              child: Text(
                                 user.email,
                                style: TextStyle(
                                  fontSize: isWebView ? 13 : screenWidth * 0.032,
                                  color: Color(0xFF667781),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                    ConstantWidgets.width40(context),
                ],
              ),
            ),
          );
        } return  AppBar(
            backgroundColor: AppPalette.whiteColor,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 4,
          shadowColor: AppPalette.blackColor.withValues(alpha: 0.15),
          scrolledUnderElevation: 4,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: AppPalette.blackColor),
            title: Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyColor,
          highlightColor: AppPalette.whiteColor,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl:'',
                        imageAsset: AppImages.appLogo,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name Loading..." ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: 16,
                            color: AppPalette.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                         'Loading...',
                          style: TextStyle(
                              fontSize: 16,
                            color:AppPalette.greyColor ,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
