import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/chat/presentation/provider/chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';
  static const String pageName = "chat";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(chattingControllerProvider.notifier);
    final data = ref.watch(chattingControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "채팅",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.4),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: TTColors.gray200,
            height: 1.0,
          ),
        ),
      ),
      body: data.when(
        skipError: true,
        data: (chatData) => SafeArea(
          child: RefreshIndicator(
            onRefresh: notifier.refreshAction,
            child: chatData.isEmpty
                ? buildEmptyState(notifier.refreshAction)
                : buildChatList(
                    chatData: chatData, scrollController: _scrollController),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => buildErrorState(
          e.toString(),
          notifier.refreshAction,
        ),
      ),
    );
  }
}
