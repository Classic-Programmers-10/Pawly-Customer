import 'package:pawlly/utils/library.dart';

class UpcomingAppointmentComponentShimmer extends StatelessWidget {
  const UpcomingAppointmentComponentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8)),
            ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8)),
          ],
        ),
        16.height,
        const BookingCardShimmer()
      ],
    ).paddingSymmetric(horizontal: 16).paddingTop(16);
  }
}
