import 'package:get/get.dart';
import '../../dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

class BlogItemComponent extends StatelessWidget {
  final Blog blog;

  const BlogItemComponent({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BlogDetailScreen(),
            arguments: blog, duration: const Duration(milliseconds: 500));
      },
      child: Container(
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "${blog.blogImage}${blog.id}",
              child: Container(
                decoration: boxDecorationDefault(),
                child: CachedImageWidget(
                  url: blog.blogImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  topLeftRadius: defaultRadius.toInt(),
                  bottomLeftRadius: defaultRadius.toInt(),
                  topRightRadius: 0,
                  bottomRightRadius: 0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(
                  blog.tags,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: secondaryTextStyle(
                      color: primaryColor,
                      fontStyle: FontStyle.italic,
                      fontFamily: fontFamilyFontWeight600),
                ),
                4.height,
                Text(
                  blog.name,
                  style: primaryTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.height,
                Text(
                  blog.createdAt.dateInMMMMDyyyyFormat,
                  style: secondaryTextStyle(size: 10),
                ),
              ],
            ).paddingSymmetric(horizontal: 16).expand(),
          ],
        ),
      ).paddingSymmetric(vertical: 8),
    );
  }
}
