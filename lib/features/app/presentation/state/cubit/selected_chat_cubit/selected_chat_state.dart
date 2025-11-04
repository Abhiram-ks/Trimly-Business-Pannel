part of 'selected_chat_cubit.dart';

abstract class SelectedChatState {
  const SelectedChatState();
}

class SelectedChatInitial extends SelectedChatState {}

class SelectedChatSelected extends SelectedChatState {
  final String userId;
  final String userName;
  final String photoUrl;

  const SelectedChatSelected({
    required this.userId,
    required this.userName,
    required this.photoUrl,
  });
}

