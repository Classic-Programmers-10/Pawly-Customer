import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class BlogDetailScreen extends StatelessWidget {
  BlogDetailScreen({super.key});

  final BlogDetailController blogDetailController =
      Get.put(BlogDetailController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.blogDetail,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blogDetailController
                    .blogDetailFromArg.value.tags.isNotEmpty)
                  Text(
                    blogDetailController.blogDetailFromArg.value.tags,
                    style: secondaryTextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                        fontFamily: fontFamilyFontWeight600),
                  ),
                8.height,
                Text(blogDetailController.blogDetailFromArg.value.name,
                    style: primaryTextStyle(size: 18)),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogDetailController.blogDetailFromArg.value.createdAt
                          .dateInMMMMDyyyyFormat,
                      style:
                          primaryTextStyle(color: secondaryTextColor, size: 12),
                    ),
                    const Spacer(),
                    Text(
                        "${locale.value.readTime} : ${blogDetailController.blogDetailFromArg.value.description.calculateReadTime().minutes.inMinutes} ${locale.value.min}",
                        style: primaryTextStyle(
                            color: secondaryTextColor, size: 12)),
                  ],
                ),
                16.height,
              ],
            ).paddingSymmetric(horizontal: 16),
            Hero(
              tag:
                  "${blogDetailController.blogDetailFromArg.value.blogImage}${blogDetailController.blogDetailFromArg.value.id}",
              child: CachedImageWidget(
                  url: blogDetailController.blogDetailFromArg.value.blogImage,
                  width: Get.width,
                  fit: BoxFit.fitWidth),
            ),
            16.height,
            if (blogDetailController
                .blogDetailFromArg.value.description.isNotEmpty)
              HtmlWidget(
                content:
                    blogDetailController.blogDetailFromArg.value.description,
              ).paddingSymmetric(horizontal: 8)
            else
              NoDataWidget(
                title: locale.value.noDetailFound,
                subTitle:
                    "${locale.value.thereAreCurrentlyNoDetails} ${locale.value.thisBlog}",
                imageWidget: const EmptyStateWidget(),
              ).paddingOnly(left: 16, right: 16, top: 16),
          ],
        ),
      ),
    );
  }
}
