import 'package:pawlly/utils/library.dart';

class HomeScreenShimmer extends StatelessWidget {
  final bool showGreeting;

  const HomeScreenShimmer({super.key, this.showGreeting = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      listAnimationType: ListAnimationType.None,
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        showGreeting ? const GreetingsComponentShimmer() : const Offstage(),
        const SlidersComponentShimmer(),
        const ChooseServiceComponentsShimmer(),
        const UpcomingAppointmentComponentShimmer(),
        const ChoosePetSitterHomeComponentsShimmer(),
        const FeaturedProductHomeComponentShimmer(),
      ],
    );
  }
}
