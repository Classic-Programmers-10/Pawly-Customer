import 'package:pawlly/utils/library.dart';

class EventListScreenShimmer extends StatelessWidget {
  const EventListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16),
      child: ScreenShimmer(
        shimmerComponent: EventItemComponentShimmer(),
      ),
    );
  }
}
