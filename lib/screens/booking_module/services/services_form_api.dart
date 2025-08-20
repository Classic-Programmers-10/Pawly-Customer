import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../pet/model/breed_model.dart';
import '../../shop/model/category_model.dart';
import '../model/employe_model.dart';
import '../model/facilities_model.dart';
import '../model/save_booking_res.dart';
import '../model/service_model.dart';
import '../model/training_model.dart';
import '../model/walking_model.dart';

class PetServiceFormApis {
  static Future<List<FacilityModel>> getFacility({int? employeeId, int? isBooking}) async {
    String empId = employeeId != -1 ? 'employee_id=$employeeId' : "";
    String isFacilityBooking = isBooking != 0
        ? employeeId != -1
            ? '&is_booking=$isBooking'
            : 'is_booking=$isBooking'
        : "";

    final facilityRes = FacilityRes.fromJson(
      await handleResponse(
        await buildHttpResponse("${APIEndPoints.getFacility}?$empId$isFacilityBooking", method: HttpMethodType.GET),
      ),
    );
    return facilityRes.data;
  }

  static Future<List<TrainingModel>> getTraining({
    int? employeeId,
    int? isBooking,
    String search = "",
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<TrainingModel> trainingList,
    Function(bool)? lastPageCallBack,
  }) async {
    String empId = employeeId != null && employeeId != -1 ? 'employee_id=$employeeId' : "";
    String isTrainingBooking = isBooking != null && isBooking != 0
        ? employeeId != null && employeeId != -1
            ? '&is_booking=$isBooking'
            : 'is_booking=$isBooking'
        : "";
    String searchTraining = search.isNotEmpty ? '&search=$search' : '';

    var res = TrainingRes.fromJson(await handleResponse(await buildHttpResponse(
      "${APIEndPoints.getTraining}?$empId$isTrainingBooking$searchTraining&page=$page&per_page=$perPage",
      method: HttpMethodType.GET,
    )));

    if (page == 1) trainingList.clear();
    trainingList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);

    return trainingList.obs;
  }

  static Future<List<ServiceModel>> getService({
    required String type,
    String search = "",
    String? categoryId,
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ServiceModel> serviceList,
    Function(bool)? lastPageCallBack,
  }) async {
    String categoryIdParam = categoryId != null ? '&category_id=$categoryId' : "";
    String searchService = search.isNotEmpty ? '&search=$search' : '';

    var res = ServiceRes.fromJson(await handleResponse(await buildHttpResponse(
      "${APIEndPoints.getService}?type=$type$categoryIdParam$searchService&page=$page&per_page=$perPage",
      method: HttpMethodType.GET,
    )));

    if (page == 1) serviceList.clear();
    serviceList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);

    return serviceList.obs;
  }

  static Future<EmployeeRes> getEmployee({
    int page = 1,
    int perPage = 50,
    required String role,
    String search = "",
    String? serviceId,
    String latitude = "",
    String longitude = "",
    bool showNearby = false,
  }) async {
    String serviceIdParam = serviceId != null ? '&service_ids=$serviceId' : "";
    String searchEmployee = search.isNotEmpty ? '&search=$search' : '';
    String lat = '';
    String long = '';

    if (showNearby) {
      lat = latitude.trim().isNotEmpty ? '&latitude=$latitude' : "";
      long = longitude.trim().isNotEmpty ? '&longitude=$longitude' : "";
    }
    return EmployeeRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getEmployeeList}?per_page=$perPage&page=$page&type=$role$serviceIdParam$searchEmployee$lat$long", method: HttpMethodType.GET)));
  }

  static Future<RxList<EmployeeModel>> getPetSitters({
    int page = 1,
    int perPage = 10,
    required List<EmployeeModel> petSittersList,
    Function(bool)? lastPageCallBack,
    required String role,
    String search = "",
    String? serviceId,
    String latitude = "",
    String longitude = "",
    bool showNearby = false,
  }) async {
    String serviceIdParam = serviceId != null ? '&service_ids=$serviceId' : "";
    String searchEmployee = search.isNotEmpty ? '&search=$search' : '';
    String lat = '';
    String long = '';

    if (showNearby) {
      lat = latitude.trim().isNotEmpty ? '&latitude=$latitude' : "";
      long = longitude.trim().isNotEmpty ? '&longitude=$longitude' : "";
    }

    final empRes = EmployeeRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getEmployeeList}?per_page=$perPage&page=$page&type=$role$serviceIdParam$searchEmployee$lat$long", method: HttpMethodType.GET)));

    if (page == 1) petSittersList.clear();
    petSittersList.addAll(empRes.data);
    lastPageCallBack?.call(empRes.data.length != perPage);

    return petSittersList.obs;
  }

  static Future<List<ShopCategoryModel>> getCategory({
    required String categoryType,
    String search = "",
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ShopCategoryModel> categoryList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchCategory = search.isNotEmpty ? '&search=$search' : '';

    var res = CategoryRes.fromJson(await handleResponse(await buildHttpResponse(
      "${APIEndPoints.getCategory}?type=$categoryType$searchCategory&page=$page&per_page=$perPage",
      method: HttpMethodType.GET,
    )));

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);

    return categoryList.obs;
  }

  static Future<BreedRes> getBreed({
    required int petTypeId,
    String search = "",
    int page = 1,
    int perPage = 50,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchBreed = search.isNotEmpty ? '&search=$search' : '';
    return BreedRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getBreed}?pettype_id=$petTypeId&per_page=$perPage&page=$page$searchBreed", method: HttpMethodType.GET)));
  }

  static Future<List<DurationData>> getDuration({
    required String serviceType,
    int? isBooking,
    int? employeeId,
    int page = 1,
    int perPage = 50,
  }) async {
    String empId = employeeId != null && employeeId != 0 ? '&employee_id=$employeeId' : "";
    String isDurationBooking = isBooking != null && isBooking != 0 ? '&is_booking=$isBooking' : "";
    final res = WalkingDurationRes.fromJson(
      await handleResponse(
        await buildHttpResponse("${APIEndPoints.getDuration}?type=$serviceType$empId$isDurationBooking&per_page=$perPage&page=$page", method: HttpMethodType.GET),
      ),
    );
    return res.data;
  }

  static Future<List<DurationData>> getTrainingDuration({
    required String serviceType,
    int? trainingTypeId,
    int page = 1,
    int perPage = 50,
  }) async {
    String trainigtypeId = trainingTypeId != null && trainingTypeId != 0 ? '&training_type_id=$trainingTypeId' : "";
    final res = WalkingDurationRes.fromJson(
      await handleResponse(
        await buildHttpResponse(
          "${APIEndPoints.grtTrainingDurationList}?type=$serviceType$trainigtypeId&per_page=$perPage&page=$page",
          method: HttpMethodType.GET,
        ),
      ),
    );
    return res.data;
  }

  static Future<void> bookServiceApi({required Map<String, dynamic> request, List<PlatformFile>? files, required VoidCallback onSuccess, required VoidCallback loaderOff}) async {
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.saveBooking);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath('medical_report', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      // multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */

    log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Files ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ${multiPartRequest.files.map((e) => e.filename!.split(".").last)}");
    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      // toast(baseResponseModel.message, print: true);
      try {
        saveBookingRes(SaveBookingRes.fromJson(jsonDecode(temp)));
      } catch (e) {
        log('SaveBookingRes.fromJson E: $e');
      }
      onSuccess.call();
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff.call();
    });
  }

  static Future<BaseResponseModel> savePayment({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.savePayment, request: request, method: HttpMethodType.POST)));
  }
}
