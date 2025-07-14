import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'profile_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select((SessionBloc bloc) => bloc.state.userId);
    if (userId == 0) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your profile.', style: TextStyle(fontSize: 18),),
        ),
      );
    }
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile(userId)),
      child: const Scaffold(
        body: ProfileLayout(),
      ),
    );
  }
}
