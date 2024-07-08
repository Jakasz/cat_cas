import 'package:cas_cat/components/shop_image.dart';
import 'package:flame/components.dart';

class ShopBackground {
  List<Component> get backgrounds => _getBacks();

  List<Component> _getBacks() {
    List<Component> backs = [];
    for (var i = 1; i <= 6; i++) {
      backs.add(ShopImage(i));
    }
    return backs;
  }
}
