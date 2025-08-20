// ignore_for_file: must_be_immutable

import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ReschedulingComponent extends StatelessWidget {
  ReschedulingComponent({
    super.key,
    required this.bookingDetail,
  });

  Rx<BookingDataModel> bookingDetail;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.boarding))
            BoardingServicesScreen(isFromReschedule: true).expand(),
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.dayCare))
            DayCareScreen(isFromReschedule: true).expand(),
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.grooming))
            GroomingScreen(isFromReschedule: true).expand(),
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.training))
            TrainingServiceScreen(isFromReschedule: true).expand(),
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.veterinary))
            VeterineryServiceScreen(isFromReschedule: true).expand(),
          if (bookingDetail.value.service.slug
              .contains(ServicesKeyConst.walking))
            WalkingServiceScreen(isFromReschedule: true).expand(),
        ],
      ),
    );
  }
}

void handleRescheduleClick(
    {required BuildContext context,
    required RxBool isLoading,
    required Rx<BookingDataModel> bookingDetail}) {
  serviceCommonBottomSheet(
    context,
    child: Obx(
      () => BottomSelectionSheet(
        heightRatio:
            bookingDetail.value.service.slug.contains(ServicesKeyConst.dayCare)
                ? 0.55
                : 0.45,
        title: locale.value.rescheduleBooking,
        hideSearchBar: true,
        hintText: locale.value.searchForStatus,
        searchTextCont: TextEditingController(),
        hasError: false,
        isLoading: isLoading,
        isEmpty: false,
        noDataTitle: locale.value.statusListIsEmpty,
        noDataSubTitle: locale.value.thereAreNoStatus,
        listWidget: ReschedulingComponent(bookingDetail: bookingDetail)
            .visible(!isLoading.value)
            .expand(),
      ),
    ),
    onSheetClose: (p0) {
      if (bookingDetail.value.service.slug.contains(ServicesKeyConst.boarding))
        Get.delete<BoardingServiceController>();
      if (bookingDetail.value.service.slug.contains(ServicesKeyConst.dayCare))
        Get.delete<DayCareServiceController>();
      if (bookingDetail.value.service.slug.contains(ServicesKeyConst.grooming))
        Get.delete<GroomingController>();
      if (bookingDetail.value.service.slug.contains(ServicesKeyConst.training))
        Get.delete<TrainingController>();
      if (bookingDetail.value.service.slug
          .contains(ServicesKeyConst.veterinary))
        Get.delete<VeterineryController>();
      if (bookingDetail.value.service.slug.contains(ServicesKeyConst.walking))
        Get.delete<WalkingServiceController>();
    },
  );
}
