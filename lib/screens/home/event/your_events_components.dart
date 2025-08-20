import 'package:get/get.dart';
import '../../dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

class YourEventsComponents extends StatelessWidget {
  final List<PetEvent> events;
  final bool isFromDetail;

  const YourEventsComponents(
      {super.key, required this.events, this.isFromDetail = false});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ViewAllLabel(
            label: locale.value.upcomingEvents,
            onTap: () {
              Get.to(() => EventListScreen());
            },
          )
              .paddingOnly(left: 16, right: 8)
              .paddingTop(16)
              .visible(!isFromDetail),
          8.height,
          HorizontalList(
            runSpacing: 16,
            spacing: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventItemComponent(
                  event: events[index],
                  youMayAlsoLikeEvent: events,
                  itemWidth: 300);
            },
          ),
        ],
      ).visible(appConfigs.value.isEvent && events.isNotEmpty),
    );
  }
}
