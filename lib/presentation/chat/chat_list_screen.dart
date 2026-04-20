import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}
