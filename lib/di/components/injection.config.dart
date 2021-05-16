// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sembast/sembast.dart' as _i3;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import '../../data/local/datasources/post/post_datasource.dart' as _i11;
import '../../data/network/apis/posts/post_api.dart' as _i10;
import '../../data/network/dio_client.dart' as _i17;
import '../../data/network/rest_client.dart' as _i16;
import '../../data/repository.dart' as _i9;
import '../../data/sharedpref/shared_preference_helper.dart' as _i8;
import '../../stores/error/error_store.dart' as _i4;
import '../../stores/form/form_store.dart' as _i5;
import '../../stores/language/language_store.dart' as _i14;
import '../../stores/post/post_store.dart' as _i15;
import '../../stores/theme/theme_store.dart' as _i12;
import '../../stores/user/user_store.dart' as _i13;
import '../module/local_module.dart' as _i18;
import '../module/network_module.dart'
    as _i19; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final localModule = _$LocalModule();
  final networkModule = _$NetworkModule();
  await gh.factoryAsync<_i3.Database>(() => localModule.provideDatabase(),
      preResolve: true);
  gh.factory<_i4.ErrorStore>(() => _i4.ErrorStore());
  gh.factory<_i5.FormStore>(() => _i5.FormStore());
  await gh.factoryAsync<_i6.SharedPreferences>(
      () => localModule.provideSharedPreferences(),
      preResolve: true);
  gh.factory<_i7.Dio>(
      () => networkModule.provideDio(get<_i8.SharedPreferenceHelper>()));
  gh.factory<_i9.Repository>(() => localModule.provideRepository(
      get<_i10.PostApi>(),
      get<_i8.SharedPreferenceHelper>(),
      get<_i11.PostDataSource>()));
  gh.factory<_i12.ThemeStore>(() => _i12.ThemeStore(get<_i9.Repository>()));
  gh.factory<_i13.UserStore>(() => _i13.UserStore(get<_i9.Repository>()));
  gh.factory<_i14.LanguageStore>(
      () => _i14.LanguageStore(get<_i9.Repository>()));
  gh.factory<_i15.PostStore>(() => _i15.PostStore(get<_i9.Repository>()));
  gh.singleton<_i11.PostDataSource>(_i11.PostDataSource(get<_i3.Database>()));
  gh.singleton<_i16.RestClient>(_i16.RestClient());
  gh.singleton<_i8.SharedPreferenceHelper>(
      _i8.SharedPreferenceHelper(get<_i6.SharedPreferences>()));
  gh.singleton<_i17.DioClient>(_i17.DioClient(get<_i7.Dio>()));
  gh.singleton<_i10.PostApi>(
      _i10.PostApi(get<_i17.DioClient>(), get<_i16.RestClient>()));
  return get;
}

class _$LocalModule extends _i18.LocalModule {}

class _$NetworkModule extends _i19.NetworkModule {}
