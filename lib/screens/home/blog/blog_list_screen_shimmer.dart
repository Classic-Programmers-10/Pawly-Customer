import 'package:pawlly/utils/library.dart';

class BlogListScreenShimmer extends StatelessWidget {
  const BlogListScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16),
      child: ScreenShimmer(
        shimmerComponent: BlogItemComponentShimmer(),
      ),
    );
  }
}
