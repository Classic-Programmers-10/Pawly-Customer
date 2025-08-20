import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pawlly/utils/library.dart';

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  const ZoomImageScreen({super.key, required this.index, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) {
        exitFullScreen();
      },
      child: AppScaffold(
        appBartitleText: locale.value.gallery,
        body: GestureDetector(
          onTap: () {
            showAppBar = !showAppBar;

            if (showAppBar) {
              exitFullScreen();
            } else {
              enterFullScreen();
            }

            setState(() {});
          },
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            enableRotation: false,
            backgroundDecoration: const BoxDecoration(color: white),
            pageController: PageController(initialPage: widget.index),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    CachedNetworkImageProvider(widget.galleryImages![index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) =>
                    PlaceHolderWidget(),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.galleryImages![index]),
              );
            },
            itemCount: widget.galleryImages!.length,
            loadingBuilder: (context, event) => const LoaderWidget(),
          ),
        ),
      ),
    );
  }
}
