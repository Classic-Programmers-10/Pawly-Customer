import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class BlogHomeComponent extends StatelessWidget {
  BlogHomeComponent({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          16.height,
          ViewAllLabel(
            label: locale.value.blogs,
            onTap: () {
              Get.to(() => BlogListScreen());
            },
          ).paddingOnly(left: 16, right: 8),
          8.height,
          Obx(
            () => AnimatedListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              emptyWidget: NoDataWidget(
                title: locale.value.noBlogsFound,
                subTitle: locale.value.thereAreNoBlogs,
                retryText: locale.value.reload,
                onRetry: () {
                  homeScreenController.init();
                  Future.delayed(const Duration(seconds: 2), () {
                    homeScreenController.isLoading(false);
                  });
                },
              ).paddingSymmetric(horizontal: 16),
              itemCount: homeScreenController.dashboardData.value.blog.length,
              itemBuilder: (context, index) {
                final bool isLastItem = (index + 1) ==
                    homeScreenController.dashboardData.value.blog.length;

                return BlogItemComponent(
                  blog: homeScreenController.dashboardData.value.blog[index],
                ).paddingOnly(
                  left: 16,
                  right: 16,
                  bottom: isLastItem ? 16 : 0,
                );
              },
            ),
          )
        ],
      ).visible(appConfigs.value.isBlog &&
          homeScreenController.dashboardData.value.blog.isNotEmpty),
    );
  }
}
