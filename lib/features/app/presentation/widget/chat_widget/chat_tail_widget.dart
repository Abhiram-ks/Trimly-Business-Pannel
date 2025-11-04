
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/message_badge_cubit/message_badge_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di/injection_contains.dart';
import '../../state/cubit/last_message_cubit/last_message_cubit.dart';

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String userId;

  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWebView = screenWidth >= 600;
    final avatarSize = isWebView ? 52.0 : 50.0;
    final horizontalSpacing = isWebView ? 12.0 : screenWidth * 0.04;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<MessageBadgeCubit>();
            cubit.numberOfBadges(userId: userId);
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<LastMessageCubit>();
            cubit.lastMessage(userId: userId);
            return cubit;
          },
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: isWebView ? 0 : 3,
          horizontal: isWebView ? 8 : screenWidth * 0.04,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isWebView ? 12 : 8,
          horizontal: isWebView ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: isWebView ? AppPalette.whiteColor : Colors.transparent,
          borderRadius: isWebView ? BorderRadius.circular(8) : null,
        ),
        child: Row(
          children: [
            // Avatar with WhatsApp-style border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isWebView
                    ? Border.all(
                        color: Color(0xFF00A884).withValues(alpha: 0.2),
                        width: 2,
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarSize / 2),
                child: SizedBox(
                  width: avatarSize,
                  height: avatarSize,
                  child: imageshow(
                    imageUrl: imageUrl,
                    imageAsset: AppImages.noImage,
                  ),
                ),
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isWebView ? 16 : 15,
                      color: Color(0xFF111B21),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<LastMessageCubit, LastMessageState>(
                    builder: (context, state) {
                      if (state is LastMessageLoading) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            color: Color(0xFF667781),
                            fontSize: isWebView ? 14 : 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else if (state is LastMessageSuccess) {
                        final message = state.message;
                        String lastMessage = message.message;

                        if (message.delete) {
                          lastMessage = 'This message was deleted';
                        }
                        if(lastMessage.startsWith('http')) {
                           lastMessage = 'Message Files(image/doc/link...)';
                        }
                        return Text(
                          lastMessage,
                          style: TextStyle(
                            color: Color(0xFF667781),
                            fontSize: isWebView ? 14 : 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return Text(
                        'Tap to view chats',
                        style: TextStyle(
                          color: Color(0xFF667781),
                          fontSize: isWebView ? 14 : 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: horizontalSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<LastMessageCubit, LastMessageState>(
                  builder: (context, state) {
                    if (state is LastMessageSuccess) {
                      final DateTime createdAt = state.message.createdAt;
                      final DateTime now = DateTime.now();
                      final bool isLessThan24Hours =  now.difference(createdAt).inHours < 24;

                      final formattedTime = isLessThan24Hours? DateFormat('hh:mm a').format(createdAt): DateFormat('dd MMM yyyy').format(createdAt);
                      return Text(
                        formattedTime,
                        style: TextStyle(
                          color: Color(0xFF667781),
                          fontSize: isWebView ? 12 : 11,
                        ),
                      );
                    }
                    return Text(
                      '1 Jan 2000',
                      style: TextStyle(
                        color: Color(0xFF667781),
                        fontSize: isWebView ? 12 : 11,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                BlocBuilder<MessageBadgeCubit, MessageBadgeState>(
                  builder: (context, state) {
                    if (state is MessageBadgeSuccess) {
                      final int badges = state.badges;
                      return Container(
                        constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                        padding: EdgeInsets.symmetric(
                          horizontal: isWebView ? 7 : avatarSize * 0.12,
                          vertical: isWebView ? 4 : avatarSize * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF25D366), // WhatsApp green for badges
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badges > 99 ? '99+' : badges.toString(),
                          style: TextStyle(
                            color: AppPalette.whiteColor,
                            fontSize: isWebView ? 12 : screenWidth * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
