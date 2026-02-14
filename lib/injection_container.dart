import 'package:get_it/get_it.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreference = await SharedPreferences.getInstance();
  // Register Shared Preference
  sl.registerSingleton<SharedPreferences>(sharedPreference);
  // Register Preference Manager passing the shared preference instance
  sl.registerSingleton<PreferencesManager>(
    await PreferencesManager.create(sharedPreference),
  );

  // Register dio client
  sl.registerSingleton<DioClient>(DioClient(ApiConstants.baseUrl));
}
