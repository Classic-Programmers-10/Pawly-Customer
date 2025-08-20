import 'package:pawlly/utils/library.dart';

class MyPetsScreenShimmer extends StatelessWidget {
  const MyPetsScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScreenShimmer(shimmerComponent: PetCardComponentShimmer());
  }
}
