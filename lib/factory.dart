import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_lyrics/logic/cubit/artist/artist_cubit.dart';
import 'package:music_lyrics/logic/cubit/change_lang/change_lang_cubit.dart';
import 'package:music_lyrics/logic/cubit/favorite/favorite_cubit.dart';
import 'package:music_lyrics/logic/cubit/favorite_change/favorite_change_cubit.dart';
import 'package:music_lyrics/logic/cubit/home/home_cubit.dart';
import 'package:music_lyrics/logic/cubit/log_check/log_check_cubit.dart';
import 'package:music_lyrics/logic/cubit/search/search_cubit.dart';
import 'package:music_lyrics/logic/cubit/song/song_cubit.dart';
import 'package:music_lyrics/service/repositories/change_lang_repository.dart';
import 'package:music_lyrics/service/repositories/favorite_repository.dart';
import 'package:music_lyrics/service/repositories/genius_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Factory {
  void initialize() {
    GetIt.I.registerFactory<SongCubit>(
      () => SongCubit(
        repository: GeniusRepository(dio: GetIt.I.get<Dio>(),
          storage: GetIt.I.get<SharedPreferences>(),),
      ),
    );

    GetIt.I.registerFactory<SearchCubit>(
      () => SearchCubit(
        repository: GeniusRepository(dio: GetIt.I.get<Dio>(),
          storage: GetIt.I.get<SharedPreferences>(),),
      ),
    );

    GetIt.I.registerFactory<ArtistCubit>(
      () => ArtistCubit(
        repository: GeniusRepository(dio: GetIt.I.get<Dio>(),
          storage: GetIt.I.get<SharedPreferences>(),),
      ),
    );

    GetIt.I.registerFactory<ChangeLangCubit>(
      () => ChangeLangCubit(
        langRepository: ChangeLangClass(),
      ),
    );

    GetIt.I.registerFactory<FavoriteCubit>(
      () => FavoriteCubit(
        favoriteRepository: FavoriteSongRepository(storage: GetIt.I.get<SharedPreferences>()),
      ),
    );

    GetIt.I.registerFactory<FavoriteChangeCubit>(
      () => FavoriteChangeCubit(
        favoriteRepository: FavoriteSongRepository(storage: GetIt.I.get<SharedPreferences>()),
      ),
    );

    GetIt.I.registerFactory<HomeCubit>(
      () => HomeCubit(
        repository: GeniusRepository(
          dio: GetIt.I.get<Dio>(),
          storage: GetIt.I.get<SharedPreferences>(),
        ),
      ),
    );

    GetIt.I.registerFactory<UserCheckCubit>(
      () => UserCheckCubit(
        firebaseAuth: FirebaseAuth.instance,
        googleAuthProvider: GoogleAuthProvider(),
        googleSignIn: GoogleSignIn(),
      ),
    );

    GetIt.I.registerFactory<Dio>(
      () => Dio(),
    );

    GetIt.I.registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    );
  }
}
