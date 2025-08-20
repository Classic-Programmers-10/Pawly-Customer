import 'package:get/get.dart';
import 'package:pawlly/screens/dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          return await homeScreenController.getDashboardDetail(
              isFromSwipRefresh: true);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: homeScreenController.getDashboardDetailFuture.value,
            initialData: homeScreenController
                    .dashboardData.value.systemService.isEmpty
                ? null
                : DashboardRes(data: homeScreenController.dashboardData.value),
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  homeScreenController.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: const HomeScreenShimmer(showGreeting: true),
            onSuccess: (dashboardData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    32.height,
                    GreetingsComponent(),
                    16.height,
                    Obx(
                      () => homeScreenController.isLoading.value
                          ? const HomeScreenShimmer()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SlidersComponent(),
                                ChooseServiceComponents(),
                                UpcomingAppointmentComponents(),
                                ChoosePetSitterComponents(),
                                YourEventsComponents(
                                    events: homeScreenController
                                        .dashboardData.value.event),
                                BlogHomeComponent(),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
