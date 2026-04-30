import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/mock/mock_data.dart';
import '../../shared/widgets/screen_layout.dart';
import '../../shared/widgets/section_card.dart';

class FanPageScreen extends StatelessWidget {
  const FanPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      children: [
        Text(
          '팔로잉 팬 페이지',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        ...MockData.fanPages.map(
          (page) => SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(page.name.characters.first)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            page.name,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '${page.category} · 팔로워 ${NumberFormat.decimalPattern().format(page.followers)}명',
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: Text(page.isFollowing ? '팔로잉' : '팔로우'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(page.description),
              ],
            ),
          ),
        ),
        Text(
          '커뮤니티 피드',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        ...MockData.fanPosts.map(
          (post) => SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${post.author} · ${post.pageName}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      DateFormat('M/d HH:mm').format(post.postedAt),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.message),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    InfoPill(
                      label: '좋아요 ${post.likes}',
                      icon: Icons.favorite_border,
                    ),
                    InfoPill(
                      label: '댓글 ${post.comments}',
                      icon: Icons.chat_bubble_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
