import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:music_lyrics/logic/cubit/home/home_cubit.dart';
import 'package:music_lyrics/presentation/screens/artist_info.dart';
import 'package:music_lyrics/presentation/screens/song_info.dart';
import 'package:music_lyrics/service/models/genius_models/artist_model/artist_model.dart';
import 'package:music_lyrics/service/models/universal_models/brief_song.dart';
import 'package:ui/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future _pullRefresh() async {
    await BlocProvider.of<HomeCubit>(context, listen: false).updateLists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: _pullRefresh,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.map(
            loading: (loading) => const Center(child: LoadingWidget()),
            loaded: (loaded) => SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  if (loaded.listRandomTopSongs != null)
                    GroupSongsWidget(
                      listTopSongs: loaded.listRandomTopSongs!.songs,
                      titleGroupSong: 'Now trending in'.tr,
                      country: loaded.listRandomTopSongs!.countryName,
                    )
                  else
                    const SizedBox(
                      height: 250,
                      child: Center(child: LoadingWidget()),
                    ),
                  const SizedBox(height: 10),
                  if (loaded.listTopCounrtySong != null)
                    PopularSongInCountry(
                      listTopSongs: loaded.listTopCounrtySong!.songs,
                      countryName: loaded.listTopCounrtySong!.countryName,
                      titleGroupSong: 'Popular songs (country)'.tr,
                    )
                  else
                    const SizedBox(
                      height: 250,
                      child: Center(child: LoadingWidget()),
                    ),
                  const SizedBox(height: 10),
                  if (loaded.listTopArtists != null)
                    PopularArtistInCountry(
                      listTopArtists: loaded.listTopArtists!,
                    )
                  else
                    const SizedBox(
                      height: 250,
                      child: Center(child: LoadingWidget()),
                    ),
                ],
              ),
            ),
            error: (error) => InfoScreenWidget(
              child: Text(
                'Something went wrong'.tr,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PopularArtistInCountry extends StatelessWidget {
  const PopularArtistInCountry({Key? key, required this.listTopArtists})
      : super(key: key);

  final List<ArtistFullInfo> listTopArtists;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${'Popular artist (country)'.tr} ${'Russia'.tr}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 150,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(width: 13);
            },
            padding: const EdgeInsets.symmetric(horizontal: 13),
            itemCount: listTopArtists.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 130,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistInfo(
                              artistId: listTopArtists[index].id,
                              artistImageUrl: listTopArtists[index].imageUrl,
                              artistName: listTopArtists[index].name,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(listTopArtists[index].imageUrl),
                            radius: 60,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            listTopArtists[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GroupSongsWidget extends StatelessWidget {
  const GroupSongsWidget(
      {Key? key,
      required this.listTopSongs,
      required this.titleGroupSong,
      required this.country})
      : super(key: key);

  final List<BriefGeniusSongModel> listTopSongs;
  final String titleGroupSong;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$titleGroupSong ${country.tr}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(width: 13);
            },
            padding: const EdgeInsets.symmetric(horizontal: 13),
            itemCount: listTopSongs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SongBigCard(
                songId: listTopSongs[index].songId,
                artistName: Text(listTopSongs[index].artistName),
                pictureUrl: listTopSongs[index].songHeaderImageUrl,
                nameSong: Text(listTopSongs[index].title),
                widget: SongInfo(songId: listTopSongs[index].songId),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularSongInCountry extends StatelessWidget {
  const PopularSongInCountry({
    Key? key,
    required this.listTopSongs,
    required this.countryName,
    required this.titleGroupSong,
  }) : super(key: key);

  final List<BriefGeniusSongModel> listTopSongs;
  final String countryName;
  final String titleGroupSong;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$titleGroupSong ${countryName.tr}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(width: 13);
            },
            padding: const EdgeInsets.symmetric(horizontal: 13),
            itemCount: listTopSongs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SongMediumPicture(
                songId: listTopSongs[index].songId,
                artistName: Text(listTopSongs[index].artistName),
                pictureUrl: listTopSongs[index].songHeaderImageUrl,
                nameSong: Text(listTopSongs[index].title),
                widget: SongInfo(songId: listTopSongs[index].songId),
              );
            },
          ),
        ),
      ],
    );
  }
}
