import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_lyrics/service/models/song.dart';
import 'package:music_lyrics/service/repositories/genius_repository.dart';

part 'song_state.dart';

class SongCubit extends Cubit<SongState> {
  SongCubit({required this.repository}) : super(SongInitial());

  final GeniusRepository repository;

  Future<void> getSongInfo(int songId) async {
    emit(SongLoading());
    final Song song;
    final String featuredArtists;
    final String writeredArtists;
    final String producerArtists;
    final String videoUrl;
    try {
      song = await repository.getSong(songId);

      if (song.media.length != 0) {
        String _videoUrl = '';
        for (int i = 0; i < song.media.length; i++) {
          if (song.media[i].provider == 'youtube') {
            _videoUrl = song.media[i].url;
            if (_videoUrl.contains('https') == false) {
              _videoUrl = _videoUrl.replaceFirst(RegExp(r".{4}"), 'https');
            }
          }
        }
        videoUrl = _videoUrl;
      } else
        videoUrl = '';

      if (song.featuredArtists!.length != 0) {
        List<String> _featureArtists = [];
        for (int x = 0; x < song.featuredArtists!.length; x++) {
          _featureArtists.add(song.featuredArtists![x].name);
        }
        featuredArtists = _featureArtists.join(', ');
      } else
        featuredArtists = '';

      if (song.writerArtists!.length != 0) {
        List<String> _writerArtists = [];
        for (var x = 0; x < song.writerArtists!.length; x++) {
          _writerArtists.add(song.writerArtists![x].name);
        }
        writeredArtists = _writerArtists.join(', ');
      } else
        writeredArtists = '';

      if (song.producerArtists!.length != 0) {
        List<String> _prodArtists = [];
        for (var x = 0; x < song.producerArtists!.length; x++) {
          _prodArtists.add(song.producerArtists![x].name);
        }
        producerArtists = _prodArtists.join(', ');
      } else
        producerArtists = '';

      emit(
        SongComplete(
            song, videoUrl, featuredArtists, writeredArtists, producerArtists),
      );
    } catch (e) {
      emit(SongError());
    }
  }
}