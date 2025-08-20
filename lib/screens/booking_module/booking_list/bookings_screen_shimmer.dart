import 'package:pawlly/utils/library.dart';

class BookingsScreenShimmer extends StatelessWidget {
  const BookingsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (BuildContext context, int index) {
        return const BookingCardShimmer(isFromHome: true);
      },
    );
  }
}
