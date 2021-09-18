import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  bool isLoading = false;
}

class ToggleLoading extends VxMutation<MyStore> {
  @override
  perform() {
    store.isLoading = !(store.isLoading);
  }
}
