import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onCompleted});

  final Future<void> Function() onCompleted;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _pageIndex = 0;

  static const _slideCount = 3;

  Future<void> _finish() async {
    await widget.onCompleted();
  }

  void _next(AppLocalizations l10n) {
    if (_pageIndex >= _slideCount - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final slides = [
      _OnboardingSlideData(
        icon: Icons.meeting_room_outlined,
        title: l10n.onboardingSlide1Title,
        body: l10n.onboardingSlide1Body,
      ),
      _OnboardingSlideData(
        icon: Icons.handshake_outlined,
        title: l10n.onboardingSlide2Title,
        body: l10n.onboardingSlide2Body,
      ),
      _OnboardingSlideData(
        icon: Icons.place_outlined,
        title: l10n.onboardingSlide3Title,
        body: l10n.onboardingSlide3Body,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(slide.icon, size: 72, color: colorScheme.primary),
                        const SizedBox(height: 24),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _pageIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _pageIndex == index
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: FilledButton(
                onPressed: () => _next(l10n),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(
                  _pageIndex >= _slideCount - 1
                      ? l10n.onboardingStart
                      : l10n.onboardingNext,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}
