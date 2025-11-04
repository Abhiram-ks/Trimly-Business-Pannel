import 'package:barber_pannel/core/common/custom_chat_textfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/request_chat_statuc_cubit/request_chat_status_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/selected_chat_cubit/selected_chat_cubit.dart';
import 'package:barber_pannel/features/app/presentation/widget/chat_windows_widget/chat_window_body_widget.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_body_widget.dart';

/// Web Layout - Two-pane chat design (WhatsApp-like)
class ChatWebLayout extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String barberId;

  const ChatWebLayout({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.35,
          decoration: BoxDecoration(
            color: AppPalette.whiteColor,
            border: Border(
              right: BorderSide(
                color: AppPalette.greyColor.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildChatListHeader(context),
              
              Expanded(
                child: ChatScreenBodyWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth * 0.35,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEFE7DD),
              image: DecorationImage(
                image: NetworkImage(
                  'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZGVmcz48cGF0dGVybiBpZD0iYSIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgd2lkdGg9IjQwIiBoZWlnaHQ9IjQwIj48cGF0aCBkPSJNMCAwaDQwdjQwSDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTAgMjBoMjBNMjAgMGgyMCIgc3Ryb2tlPSIjZDlkOWQ5IiBzdHJva2Utd2lkdGg9IjEiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjYSkiLz48L3N2Zz4='
                ),
                repeat: ImageRepeat.repeat,
                opacity: 0.3,
              ),
            ),
            child: BlocBuilder<SelectedChatCubit, SelectedChatState>(
              builder: (context, state) {
                if (state is SelectedChatSelected) {
                  return _buildChatWindow(
                    context: context,
                    userId: state.userId,
                    barberId: barberId,
                    userName: state.userName,
                    photoUrl: state.photoUrl,
                  );
                }
                return _buildPlaceholder(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatListHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.buttonColor, 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppPalette.whiteColor,
            child: Icon(
              Icons.person,
              color: AppPalette.buttonColor,
              size: 24,
            ),
          ),
         ConstantWidgets.width10(context),
          Expanded(
            child: Text(
              'Chats',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppPalette.whiteColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showCupertinoDialog(
                      context: context,
                      builder:
                          (_) => CupertinoAlertDialog(
                            title: Text('About Chats and chat windows'),
                            content: Text(
                              'Chats and chat windows enable seamless real-time communication with customers, allowing you to exchange messages, share media, and stay informed with live updates. The platform includes message indicators and badges for active conversations, ensuring you never miss important interactions or responses.',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Got it',
                                  style: TextStyle(
                                    color: AppPalette.buttonColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
            },
            icon: Icon(
              Icons.more_vert,
              color: AppPalette.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatWindow({
    required BuildContext context,
    required String userId,
    required String barberId,
    required String userName,
    required String photoUrl,
  }) {
    final TextEditingController controller = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<FetchUserBloc>()..add(FetchUserRequest(userId: userId)),
        ),
        BlocProvider(
          create: (_) => sl<ImagePickerBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<SendMessageBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<StatusChatRequstDartCubit>(),
        ),
        BlocProvider(
          create: (_) => ProgresserCubit(),
        ),
        BlocProvider(
          create: (_) => EmojiPickerCubit(),
        ),
      ],
      child: Column(
        children: [
          _buildWebChatAppBar(context, userName, photoUrl, userId),
          Expanded(
            child: ChatWindowWidget(
              userId: userId,
              barberId: barberId,
              controller: controller,
              isWebView: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebChatAppBar(BuildContext context, String userName, String photoUrl, String userId) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFFF0F2F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppPalette.buttonColor,
              backgroundImage: photoUrl.isNotEmpty && photoUrl.startsWith('http')
                  ? NetworkImage(photoUrl)
                  : null,
              child: photoUrl.isEmpty || !photoUrl.startsWith('http')
                  ? Icon(
                      Icons.person,
                      color: AppPalette.whiteColor,
                      size: 26,
                    )
                  : null,
            ),
            ConstantWidgets.width10(context),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111B21),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppPalette.buttonColor, 
                          shape: BoxShape.circle,
                        ),
                      ),
                      ConstantWidgets.width10(context),
                      Text(
                        'Active now',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Color(0xFF667781),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action buttons
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Color(0xFF54656F),
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Color(0xFF54656F),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Color(0xFFF0F2F5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.chat_bubble_text,
                  size: 120,
                  color: AppPalette.buttonColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            ConstantWidgets.hight20(context),
            Text(
              'FreshFade Chat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111B21),
                letterSpacing: -0.5,
              ),
            ),
            ConstantWidgets.hight10(context),
            Container(
              constraints: BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    'Send and receive messages with your customers',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Select a conversation from the left to start chatting',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ConstantWidgets.hight20(context),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppPalette.buttonColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Color(0xFF667781),
                  ),
                  ConstantWidgets.width10(context),
                  Text(
                    'Your personal messages are end-to-end encrypted',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Color(0xFF667781),
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