import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/feature/home/bloc/home_bloc.dart';
import 'package:sample/src/feature/home/bloc/home_event.dart';
import 'package:sample/src/feature/home/bloc/home_state.dart';
import 'package:sample/src/feature/home/components/post_card.dart';

class PostsList extends StatelessWidget {
  const PostsList({required this.state, super.key});
  final HomeSuccess state;

  @override
  Widget build(BuildContext context) {
    // extendBody:true already bakes nav-bar height into padding.bottom
    final bottomInset = MediaQuery.of(context).padding.bottom + 8;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeRefreshed());
        await context.read<HomeBloc>().stream.firstWhere(
          (s) => s is! HomeSuccess || !s.isRefreshing,
        );
      },
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset),
        itemCount: state.posts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => PostCard(post: state.posts[i]),
      ),
    );
  }
}
