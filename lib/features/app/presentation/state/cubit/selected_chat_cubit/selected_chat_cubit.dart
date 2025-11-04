import 'package:bloc/bloc.dart';

part 'selected_chat_state.dart';

class SelectedChatCubit extends Cubit<SelectedChatState> {
  SelectedChatCubit() : super(SelectedChatInitial());

  void selectChat({required String userId, required String userName, required String photoUrl}) {
    emit(SelectedChatSelected(userId: userId, userName: userName, photoUrl: photoUrl));
  }

  void clearSelection() {
    emit(SelectedChatInitial());
  }
}

