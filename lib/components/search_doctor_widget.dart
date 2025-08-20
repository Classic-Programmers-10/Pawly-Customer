// ignore_for_file: must_be_immutable

import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class SearchDoctorWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final PetSitterController doctorListController;

  const SearchDoctorWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.doctorListController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: doctorListController.searchCont,
            textFieldType: TextFieldType.OTHER,
            textInputAction: TextInputAction.done,
            textStyle: primaryTextStyle(),
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: (p0) {
              doctorListController.isSearchText(doctorListController.searchCont.text.trim().isNotEmpty);
              doctorListController.searchStream.add(p0);
            },
            suffix: Obx(
              () => appCloseIconButton(
                context,
                onPressed: () {
                  hideKeyboard(context);
                  doctorListController.searchCont.clear();
                  doctorListController.isSearchText(doctorListController.searchCont.text.trim().isNotEmpty);
                  if (onClearButton != null) {
                    onClearButton!.call();
                  }
                },
                size: 11,
              ).visible(doctorListController.isSearchText.value),
            ),
            decoration: inputDecorationWithOutBorder(
              context,
              hintText: hintText ?? locale.value.searchHere,
              filled: true,
              fillColor: context.cardColor,
              prefixIcon:
                  commonLeadingWid(imgPath: Assets.iconsIcSearch, icon: Icons.search_outlined, size: 18)
                      .paddingAll(14),
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            hideKeyboard(context);
            handleFilterClick(context);
          },
          icon: commonLeadingWid(
              imgPath: Assets.iconsIcFilter, color: switchColor, icon: Icons.filter_alt_outlined, size: 24),
        ),
      ],
    );
  }

  void handleFilterClick(BuildContext context) {
    doIfLoggedIn(context, () {
      serviceCommonBottomSheet(
        context,
        child: Obx(
          () => BottomSelectionSheet(
            heightRatio: 0.5,
            title: locale.value.filterBy,
            hideSearchBar: true,
            hintText: locale.value.searchForStatus,
            searchTextCont: TextEditingController(),
            hasError: false,
            isLoading: doctorListController.isLoading,
            isEmpty: allStatus.isEmpty,
            noDataTitle: locale.value.statusListIsEmpty,
            noDataSubTitle: locale.value.thereAreNoStatus,
            listWidget: statusListWid(context),
          ),
        ),
      );
    });
  }

  Widget statusListWid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.findBestPawllyAround, style: secondaryTextStyle()),
        8.height,
        AnimatedWrap(
          runSpacing: 8,
          spacing: 6,
          itemCount: 1,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  if (doctorListController.selectedStatus.contains("location")) {
                    doctorListController.selectedStatus.remove("location");
                  } else {
                    doctorListController.selectedStatus.add("location");
                  }
                },
                child: Container(
                  width: Get.width / 3.71,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: boxDecorationDefault(
                    color: doctorListController.selectedStatus.contains("location")
                        ? isDarkMode.value
                            ? primaryColor
                            : lightPrimaryColor
                        : isDarkMode.value
                            ? lightPrimaryColor2
                            : Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        size: 14,
                        color: isDarkMode.value ? whiteColor : primaryColor,
                      ).visible(doctorListController.selectedStatus.contains(allStatus[index].status)),
                      4.width.visible(doctorListController.selectedStatus.contains(allStatus[index].status)),
                      Text(
                        "Near me",
                        style: secondaryTextStyle(
                          color: doctorListController.selectedStatus.contains(allStatus[index].status)
                              ? isDarkMode.value
                                  ? whiteColor
                                  : primaryColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Text(locale.value.ourMostLoveChewTreats, style: secondaryTextStyle()),
        8.height,
        Text(locale.value.searchForService, style: secondaryTextStyle()),
        8.height,
        Text(locale.value.servicePackages, style: secondaryTextStyle()),
        16.height,
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
              text: locale.value.clearFilter,
              textStyle: appButtonTextStyleGray,
              color: lightSecondaryColor,
              onTap: () {
                Get.back();
                doctorListController.selectedStatus.remove("location");
              },
            ).expand(),
            16.width,
            AppButton(
              text: locale.value.apply,
              textStyle: appButtonTextStyleWhite,
              onTap: () {
                if (doctorListController.selectedStatus.contains("location")) {
                  doctorListController.isSearchText(doctorListController.searchCont.text.trim().isNotEmpty);
                  doctorListController.handleCurrentLocationClick();
                }
              },
            ).expand(),
          ],
        ),
      ],
    ).expand();
  }
}
