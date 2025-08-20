import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class BlogListScreen extends StatelessWidget {
  BlogListScreen({super.key});

  final BlogController blogController = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.blogList,
      isLoading: blogController.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: blogController.getBlog.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                blogController.page(1);
                blogController.isLoading(true);
                blogController.init();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: const BlogListScreenShimmer(),
          onSuccess: (blogs) {
            return AnimatedListView(
              shrinkWrap: true,
              itemCount: blogs.length,
              listAnimationType: ListAnimationType.None,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              emptyWidget: NoDataWidget(
                title: locale.value.noBlogsFound,
                imageWidget: const EmptyStateWidget(),
                subTitle: locale.value.thereAreNoBlogs,
                retryText: locale.value.reload,
                onRetry: () {
                  blogController.page(1);
                  blogController.isLoading(true);
                  blogController.init();
                },
              ).paddingSymmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return BlogItemComponent(blog: blogs[index]);
              },
              onNextPage: () async {
                if (!blogController.isLastPage.value) {
                  blogController.page(blogController.page.value + 1);
                  blogController.isLoading(true);
                  blogController.init();
                  return await Future.delayed(const Duration(seconds: 2), () {
                    blogController.isLoading(false);
                  });
                }
              },
              onSwipeRefresh: () async {
                blogController.page(1);
                return await blogController.init();
              },
            );
          },
        ),
      ),
    );
  }
}
