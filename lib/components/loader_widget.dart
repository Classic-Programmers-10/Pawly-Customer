import 'package:pawlly/utils/library.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Loader(
      valueColor: AlwaysStoppedAnimation(
        context.primaryColor,
      ),
    );
  }
}
