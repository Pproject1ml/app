import 'package:chat_location/constants/colors.dart';

import 'package:chat_location/features/chat/presentation/provider/personal_chatting_controller.dart';
import 'package:chat_location/features/chat/presentation/ui/chat_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalChatScreen extends ConsumerStatefulWidget {
  const PersonalChatScreen({super.key});
  static const String routeName = '/personalchat';
  static const String pageName = "personalchat";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<PersonalChatScreen> {
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
    final notifier = ref.read(personalchattingControllerProvider.notifier);
    final data = ref.watch(personalchattingControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "1:1 채팅",
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
                    chatData: chatData,
                    scrollController: _scrollController,
                    isPrivate: true),
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
