import 'package:dfamedia/core/theme/app_colors.dart';
import 'package:dfamedia/features/chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class BottomNavigationWrapper extends StatelessWidget {
  final Widget child;

  const BottomNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: child)]),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Левая часть - 2 элемента
              _buildNavItem(
                context,
                icon: 'assets/svg/home.svg.vec',
                label: 'Главная',
                isActive: true,
                onTap: () {},
              ),
              _buildNavItem(
                context,
                icon: 'assets/svg/bag-happy-icon.svg.vec',
                label: 'Доставка',
                isActive: false,
                onTap: () {},
              ),
              // Центральная часть - пустое место
              const Spacer(),
              // Правая часть - 2 элемента
              _buildNavItem(
                context,
                icon: 'assets/svg/shop-icon.svg.vec',
                label: 'Магазины',
                isActive: false,
                onTap: () {},
              ),
              _buildNavItem(
                context,
                icon: 'assets/svg/message-icon.svg.vec',
                label: 'Связаться',
                isActive: false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture(
              AssetBytesLoader(icon),
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.crimson400 : Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Stolzl',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isActive ? AppColors.crimson400 : Theme.of(context).iconTheme.color!,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
