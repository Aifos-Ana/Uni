import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:uni_calendar/controller/load_info.dart';
import 'package:uni_calendar/model/app_state.dart';
import 'package:uni_calendar/redux/refresh_items_action.dart';

void generalMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is RefreshItemsAction) {
    loadUserInfoToState(store).whenComplete(() => action.completer.complete());
  } else if (action is ThunkAction<AppState>) {
    action(store);
  } else {
    next(action);
  }
}
