import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_chat_textfiled.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/bloc/send_message_bloc/send_message_bloc.dart';
import '../../state/cubit/request_chat_statuc_cubit/request_chat_status_cubit.dart';
import '../../widget/chat_windows_widget/chat_appbar_widget.dart';
import '../../widget/chat_windows_widget/chat_window_body_widget.dart';

class ChatWindowsScreen extends StatefulWidget {
  final String userId;
  final String barberId;

  const ChatWindowsScreen({
    super.key,
    required this.userId,
    required this.barberId,
  });

  @override
  State<ChatWindowsScreen> createState() => _ChatWindowsScreenState();
}

class _ChatWindowsScreenState extends State<ChatWindowsScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<FetchUserBloc>()..add(FetchUserRequest(userId: widget.userId)),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          final bool isWebView = screenWidth >= 600;

          return Scaffold(
              backgroundColor: isWebView ? Color(0xFFEFE7DD) : AppPalette.whiteColor,
              appBar: ChatAppBar(
                userId: widget.userId,
                screenWidth: screenWidth,
                isWebView: isWebView,
              ),
             body: isWebView
                 ? Center(
                     child: Container(
                       constraints: BoxConstraints(maxWidth: 1400),
                       margin: EdgeInsets.symmetric(
                         horizontal: screenWidth * 0.08,
                         vertical: 20,
                       ),
                       decoration: BoxDecoration(
                         color: AppPalette.whiteColor,
                         borderRadius: BorderRadius.circular(12),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withValues(alpha: 0.1),
                             blurRadius: 20,
                             offset: const Offset(0, 4),
                           ),
                         ],
                       ),
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(12),
                         child: ChatWindowWidget(
                           userId: widget.userId,
                           barberId: widget.barberId,
                           controller: controller,
                           isWebView: isWebView,
                         ),
                       ),
                     ),
                   )
                 : ChatWindowWidget(
                     userId: widget.userId,
                     barberId: widget.barberId,
                     controller: controller,
                     isWebView: isWebView,
                   ));
        },
      ),
    );
  }
}





