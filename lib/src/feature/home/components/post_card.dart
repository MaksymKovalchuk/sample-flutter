import 'package:flutter/material.dart';
import 'package:sample/src/core/theme/colors.dart';
import 'package:sample/src/core/theme/style_manager.dart';
import 'package:sample/src/core/theme/typography.dart';
import 'package:sample/src/feature/home/model/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colors.cBgBlock,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          style: StyleManager.styleText(
            fMedium16,
            weight: semiBold,
            color: context.colors.cTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          post.body,
          style: StyleManager.styleText(
            fLSmall14,
            color: context.colors.cTextSec,
          ),
        ),
      ],
    ),
  );
}
