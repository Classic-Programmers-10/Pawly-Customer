import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class BoardingServicesScreen extends StatelessWidget {
  final bool isFromReschedule;

  BoardingServicesScreen({super.key, this.isFromReschedule = false});

  final BoardingServiceController boardingServiceController =
      Get.put(BoardingServiceController());
  final GlobalKey<FormState> _boardingformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return isFromReschedule
        ? rescheduleForm(context)
        : AppScaffold(
            appBartitleText: locale.value.boarding,
            isLoading: boardingServiceController.isLoading,
            appBarTitle: Hero(
              tag: currentSelectedService.value.name,
              child: Text(
                "${locale.value.book} ${getServiceNameByServiceElement(serviceSlug: currentSelectedService.value.slug)}",
                style:
                    primaryTextStyle(size: 16, decoration: TextDecoration.none),
              ),
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Form(
                    key: _boardingformKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        ChooseYourPet(
                          onChanged: (selectedPet) {
                            boardingServiceController.bookBoardingReq.petId =
                                selectedPet.id;
                          },
                        ),
                        32.height,
                        dropOffDateTimeWidget(context),
                        32.height,
                        pickupDateWidget(context),
                        32.height,
                        Obx(
                          () => AppTextField(
                            title: locale.value.boarder,
                            textStyle: primaryTextStyle(size: 12),
                            controller: boardingServiceController.boarderCont,
                            textFieldType: TextFieldType.OTHER,
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return locale.value.thisFieldIsRequired;
                              }

                              return null;
                            },
                            onTap: () async {
                              serviceCommonBottomSheet(
                                context,
                                onSheetClose: (p0) {
                                  BSScontroller getxBSSCont = Get.find();
                                  hideKeyboard(context);
                                  getxBSSCont.searchCont.clear();
                                  getxBSSCont.isSearchText(getxBSSCont
                                      .searchCont.text
                                      .trim()
                                      .isNotEmpty);
                                  boardingServiceController.getBoarders(
                                      searchtext: '');
                                },
                                child: Obx(
                                  () => BottomSelectionSheet(
                                    title: locale.value.chooseBoarder,
                                    hintText: locale.value.searchForBoarder,
                                    hasError: boardingServiceController
                                        .hasErrorFetchingBoarders.value,
                                    isEmpty: !boardingServiceController
                                            .isLoading.value &&
                                        boardingServiceController
                                            .boardersList.isEmpty,
                                    errorText: boardingServiceController
                                        .errorMessageBoarder.value,
                                    noDataTitle:
                                        locale.value.boarderListIsEmpty,
                                    noDataSubTitle:
                                        locale.value.thereAreNoBoarders,
                                    isLoading:
                                        boardingServiceController.isLoading,
                                    searchApiCall: (p0) {
                                      boardingServiceController.getBoarders(
                                          searchtext: p0);
                                    },
                                    onRetry: () {
                                      boardingServiceController.getBoarders();
                                    },
                                    listWidget: Obx(
                                      () => boarderListWid(
                                        boardingServiceController.boardersList,
                                      ).expand(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.chooseBoarder,
                              fillColor: context.cardColor,
                              filled: true,
                              prefixIconConstraints:
                                  BoxConstraints.loose(const Size.square(60)),
                              prefixIcon: boardingServiceController
                                          .selectedBoarder
                                          .value
                                          .profileImage
                                          .value
                                          .isEmpty &&
                                      boardingServiceController
                                          .selectedBoarder.value.id.isNegative
                                  ? null
                                  : CachedImageWidget(
                                      url: boardingServiceController
                                          .selectedBoarder
                                          .value
                                          .profileImage
                                          .value,
                                      height: 35,
                                      width: 35,
                                      firstName: boardingServiceController
                                          .selectedBoarder.value.fullName,
                                      fit: BoxFit.cover,
                                      circle: true,
                                      usePlaceholderIfUrlEmpty: true,
                                    ).paddingOnly(
                                      left: 12, top: 8, bottom: 8, right: 12),
                              suffixIcon: boardingServiceController
                                          .selectedBoarder
                                          .value
                                          .profileImage
                                          .value
                                          .isEmpty &&
                                      boardingServiceController
                                          .selectedBoarder.value.id.isNegative
                                  ? Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 24,
                                      color: darkGray.withOpacity(0.5),
                                    )
                                  : appCloseIconButton(
                                      context,
                                      onPressed: () {
                                        boardingServiceController
                                            .clearBoarderSelection();
                                      },
                                      size: 11,
                                    ),
                            ),
                          ).paddingSymmetric(horizontal: 16),
                        ),
                        32.height,
                        Obx(() => additionalFacilityWidget(context)),
                        32.height,
                        AppTextField(
                          title: locale.value.additionalInformation,
                          textStyle: primaryTextStyle(size: 12),
                          textFieldType: TextFieldType.MULTILINE,
                          isValidationRequired: false,
                          minLines: 5,
                          controller:
                              boardingServiceController.additionalInfoCont,
                          // focus: editUserProfileController.addressFocus,
                          decoration: inputDecoration(context,
                              hintText: locale.value.writeHere,
                              fillColor: context.cardColor,
                              filled: true),
                          enableChatGPT: appConfigs.value.enableChatGpt,
                          promptFieldInputDecorationChatGPT: inputDecoration(
                              context,
                              hintText: locale.value.writeHere,
                              fillColor: context.scaffoldBackgroundColor,
                              filled: true),
                          testWithoutKeyChatGPT:
                              appConfigs.value.testWithoutKey,
                          loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                        ).paddingSymmetric(horizontal: 16),
                      ],
                    ),
                  ),
                ).expand(),
                Obx(
                  () => AppButtonWithPricing(
                    price: totalAmount.toStringAsFixed(2).toDouble(),
                    tax: totalTax.toStringAsFixed(2).toDouble(),
                    items: getServiceNameByServiceElement(
                        serviceSlug: currentSelectedService.value.slug),
                    serviceImg: currentSelectedService.value.serviceImage,
                    onTap: () {
                      if (_boardingformKey.currentState!.validate()) {
                        _boardingformKey.currentState!.save();
                        if (boardingServiceController.bookBoardingReq.petId >
                            0) {
                          hideKeyboard(context);
                          boardingServiceController.handleBookNowClick();
                        } else {
                          toast(locale.value.pleaseSelectPet);
                        }
                      }
                    },
                  )
                      .paddingSymmetric(horizontal: 16)
                      .visible(boardingServiceController.showBookBtn.value),
                ),
              ],
            ),
          );
  }

  Widget rescheduleForm(BuildContext context) {
    return Form(
      key: _boardingformKey,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            title: locale.value.dropOffTime,
                            textStyle: primaryTextStyle(size: 12),
                            controller:
                                boardingServiceController.dropOfftimeCont,
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.fromDateTime(
                                    boardingServiceController.bookBoardingReq
                                        .dropoffTime.dateInHHmm24HourFormat),
                                //TODO: Make Time Extension
                                context: context,
                              );

                              if (pickedTime != null) {
                                if ("${boardingServiceController.bookBoardingReq.dropoffDate} ${pickedTime.formatTimeHHmm24Hour()}"
                                    .isAfterCurrentDateTime) {
                                  boardingServiceController
                                          .bookBoardingReq.dropoffTime =
                                      pickedTime.formatTimeHHmm24Hour();
                                  boardingServiceController.dropOfftimeCont
                                      .text = pickedTime.formatTimeHHmmAMPM();
                                  boardingServiceController.onDateTimeChanges();
                                } else {
                                  toast(locale.value.oopsItSeemsYouVe);
                                }
                              } else {
                                log("Time is not selected");
                              }
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.selectTime,
                              fillColor: context.cardColor,
                              filled: true,
                              suffixIcon: Assets.iconsIcTimeOutlined
                                  .iconImage(
                                      color: secondaryTextColor,
                                      fit: BoxFit.contain)
                                  .paddingAll(14),
                            ),
                          ),
                        ],
                      ).expand(),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            title: locale.value.pickupTime,
                            textStyle: primaryTextStyle(size: 12),
                            controller:
                                boardingServiceController.pickUptimeCont,
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            onTap: () async {
                              if (boardingServiceController.dropOffDateCont.text
                                  .trim()
                                  .isEmpty) {
                                toast(locale.value.pleaseSelectDropOff);
                              } else if (boardingServiceController
                                  .dropOfftimeCont.text
                                  .trim()
                                  .isEmpty) {
                                toast(locale.value.pleaseSelectDropOffTime);
                              } else {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.fromDateTime(
                                      boardingServiceController.bookBoardingReq
                                          .pickupTime.dateInHHmm24HourFormat),
                                  //TODO: Make Time Extension
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  if ("${boardingServiceController.bookBoardingReq.pickupDate} ${pickedTime.formatTimeHHmm24Hour()}"
                                      .isAfterCurrentDateTime) {
                                    boardingServiceController
                                            .bookBoardingReq.pickupTime =
                                        pickedTime.formatTimeHHmm24Hour();
                                    boardingServiceController.pickUptimeCont
                                        .text = pickedTime.formatTimeHHmmAMPM();
                                    boardingServiceController
                                        .onDateTimeChanges();
                                  } else {
                                    toast(locale.value.oopsItSeemsYouVe);
                                  }
                                } else {
                                  log("Time is not selected");
                                }
                              }
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.selectTime,
                              fillColor: context.cardColor,
                              filled: true,
                              suffixIcon: Assets.iconsIcTimeOutlined
                                  .iconImage(
                                      color: secondaryTextColor,
                                      fit: BoxFit.contain)
                                  .paddingAll(14),
                            ),
                          ),
                        ],
                      ).expand(),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ],
              ),
              const Spacer(),
              AppButton(
                width: Get.width,
                text: locale.value.update,
                textStyle: appButtonTextStyleWhite,
                color: primaryColor,
                onTap: () {
                  if (_boardingformKey.currentState!.validate()) {
                    _boardingformKey.currentState!.save();
                    hideKeyboard(context);
                    boardingServiceController.handleBookNowClick(
                        isFromReschedule: isFromReschedule);
                  }
                },
              ),
            ],
          ),
          Obx(() => const LoaderWidget()
              .center()
              .visible(boardingServiceController.isLoading.value))
        ],
      ),
    );
  }

  Widget boarderListWid(List<EmployeeModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].fullName,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(
              url: list[index].profileImage.value,
              height: 35,
              fit: BoxFit.cover,
              width: 35,
              circle: true),
          onTap: () {
            boardingServiceController.selectedBoarder(list[index]);
            boardingServiceController.boarderCont.text =
                boardingServiceController.selectedBoarder.value.fullName;
            boardingServiceController.bookBoardingReq.employeeId =
                boardingServiceController.selectedBoarder.value.id;
            boardingServiceController.isSelectedBoarderChange(true);
            boardingServiceController.onDateTimeChanges();
            boardingServiceController.getBoarders();
            boardingServiceController.getFacilityList(
                employeeId: boardingServiceController.selectedBoarder.value.id,
                isBooking: 1);
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget dropOffDateTimeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.dropOffDate,
                  textStyle: primaryTextStyle(size: 12),
                  controller: boardingServiceController.dropOffDateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      boardingServiceController.bookBoardingReq.dropoffDate =
                          selectedDate.formatDateYYYYmmdd();
                      boardingServiceController.dropOffDateCont.text =
                          selectedDate.formatDateDDMMYY();
                      boardingServiceController.onDateTimeChanges();
                      log('BOARDINGSERVICECONTROLLER.BOOKBOARDINGREQ: ${boardingServiceController.bookBoardingReq.toJson()}');
                    } else {
                      log("Date is not selected");
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectDate,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.navigationIcCalendarOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.dropOffTime,
                  textStyle: primaryTextStyle(size: 12),
                  controller: boardingServiceController.dropOfftimeCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      if ("${boardingServiceController.bookBoardingReq.dropoffDate} ${pickedTime.formatTimeHHmm24Hour()}"
                          .isAfterCurrentDateTime) {
                        boardingServiceController.bookBoardingReq.dropoffTime =
                            pickedTime.formatTimeHHmm24Hour();
                        boardingServiceController.dropOfftimeCont.text =
                            pickedTime.formatTimeHHmmAMPM();
                        boardingServiceController.onDateTimeChanges();
                      } else {
                        toast(locale.value.oopsItSeemsYouVe);
                      }
                    } else {
                      log("Time is not selected");
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectTime,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.iconsIcTimeOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
          ],
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget pickupDateWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.pickupDate,
                  textStyle: primaryTextStyle(size: 12),
                  controller: boardingServiceController.pickUpDateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    if (boardingServiceController.dropOffDateCont.text
                        .trim()
                        .isEmpty) {
                      toast(locale.value.pleaseSelectDropOff);
                    } else if (boardingServiceController.dropOfftimeCont.text
                        .trim()
                        .isEmpty) {
                      toast(locale.value.pleaseSelectDropOffTime);
                    } else {
                      log('GETDROPOFFDATETIME: ${boardingServiceController.getDropOFFDateTime}');
                      log('getpickUpDateTime: ${boardingServiceController.getpickUpDateTime}');
                      if (boardingServiceController
                          .getDropOFFDateTime.isValidDateTime) {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: boardingServiceController
                                  .getpickUpDateTime
                                  .trim()
                                  .isValidDateTime
                              ? boardingServiceController.getpickUpDateTime
                                  .trim()
                                  .dateInyyyyMMddFormat
                              : boardingServiceController.getDropOFFDateTime
                                  .trim()
                                  .dateInyyyyMMddFormat
                                  .add(const Duration(days: 1)),
                          firstDate: boardingServiceController
                              .getDropOFFDateTime
                              .trim()
                              .dateInyyyyMMddFormat
                              .add(const Duration(days: 1)),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          boardingServiceController.bookBoardingReq.pickupDate =
                              selectedDate.formatDateYYYYmmdd();
                          boardingServiceController.pickUpDateCont.text =
                              selectedDate.formatDateDDMMYY();
                          boardingServiceController.onDateTimeChanges();
                          log('BOARDINGSERVICECONTROLLER.BOOKBOARDINGREQ: ${boardingServiceController.bookBoardingReq.toJson()}');
                        } else {
                          log("Date is not selected");
                        }
                      } else {
                        toast(locale.value.pleaseSelectValidDrop);
                      }
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectDate,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.navigationIcCalendarOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: locale.value.pickupTime,
                  textStyle: primaryTextStyle(size: 12),
                  controller: boardingServiceController.pickUptimeCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    if (boardingServiceController.dropOffDateCont.text
                        .trim()
                        .isEmpty) {
                      toast(locale.value.pleaseSelectDropOff);
                    } else if (boardingServiceController.dropOfftimeCont.text
                        .trim()
                        .isEmpty) {
                      toast(locale.value.pleaseSelectDropOffTime);
                    } else {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        if ("${boardingServiceController.bookBoardingReq.pickupDate} ${pickedTime.formatTimeHHmm24Hour()}"
                            .isAfterCurrentDateTime) {
                          boardingServiceController.bookBoardingReq.pickupTime =
                              pickedTime.formatTimeHHmm24Hour();
                          boardingServiceController.pickUptimeCont.text =
                              pickedTime.formatTimeHHmmAMPM();
                          boardingServiceController.onDateTimeChanges();
                        } else {
                          toast(locale.value.oopsItSeemsYouVe);
                        }
                      } else {
                        log("Time is not selected");
                      }
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectTime,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Assets.iconsIcTimeOutlined
                        .iconImage(
                            color: secondaryTextColor, fit: BoxFit.contain)
                        .paddingAll(14),
                  ),
                ),
              ],
            ).expand(),
          ],
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget additionalFacilityWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.additionalFacility, style: primaryTextStyle())
            .paddingSymmetric(horizontal: 16),
        8.height,
        Obx(
          () => SnapHelperWidget(
            future: boardingServiceController.getFacility.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${locale.value.loading}... ",
                    style: secondaryTextStyle(
                        size: 14, fontFamily: fontFamilyFontBold)),
              ],
            ),
            onSuccess: (facilities) {
              return facilities.isEmpty
                  ? NoDataWidget(
                      title: locale.value.facilityListIsEmpty,
                      subTitle: locale.value.theFacilityListIs,
                      titleTextStyle: primaryTextStyle(),
                    ).paddingSymmetric(horizontal: 32)
                  : Container(
                      decoration: boxDecorationDefault(
                        shape: BoxShape.rectangle,
                        color: context.cardColor,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: facilities.map((element) {
                            return Obx(
                              () => CheckboxListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 16, right: 16),
                                activeColor: primaryColor,
                                checkColor: white,
                                shape: defaultAppButtonShapeBorder,
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: const BorderSide(
                                    color: borderColor, width: 1.5),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(element.name,
                                    style: primaryTextStyle()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (element.description.isNotEmpty)
                                      Text(
                                        element.description.validate(),
                                        style: secondaryTextStyle(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ).paddingBottom(4),
                                    Text(
                                      (element.createdBy ==
                                              boardingServiceController
                                                  .selectedBoarder.value.id)
                                          ? '${locale.value.providedBy} ${boardingServiceController.selectedBoarder.value.fullName}'
                                          : locale.value.providedByAdmin,
                                      style: secondaryTextStyle(
                                          color: primaryColor,
                                          fontStyle: FontStyle.italic),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                value: element.isChecked.value,
                                onChanged: (val) {
                                  element.isChecked(val);
                                  boardingServiceController.selectedFacilities(
                                      facilities
                                          .where((p0) => p0.isChecked.value)
                                          .toList());
                                },
                              ),
                            );
                          }).toList()),
                    ).paddingSymmetric(horizontal: 16);
            },
          ),
        ),
      ],
    );
  }
}
