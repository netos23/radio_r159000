import 'package:elementary/elementary.dart';
import 'package:radio_r159000/util/logger.dart';

class DefaultErrorHandler extends ErrorHandler {
  @override
  void handleError(Object error, {StackTrace? stackTrace}) {
    logger.e('Error thrown by model', error, stackTrace);
  }
}
