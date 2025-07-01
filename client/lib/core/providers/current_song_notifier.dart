import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  late HomeLocalRepository _homeLocalRepository;
  bool isPlayiing = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    try {
      await audioPlayer?.stop();
      // audioPlayer?.dispose(); // Dispose previous player if needed
      audioPlayer = AudioPlayer();
      print("Song URL: ${song.song_url}");

      final audioSource = AudioSource.uri(
        Uri.parse(song.song_url),
        tag: MediaItem(
          id: song.id,
          title: song.song_name,
          artist: song.artist,
          artUri: Uri.parse(song.thumbnail_url),
        ),
      );
      await audioPlayer!.setAudioSource(audioSource);
      audioPlayer!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlayiing = false;
          this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
        }
      });
      _homeLocalRepository.uploadLocalSongs(song);
      audioPlayer!.play();
      isPlayiing = true;

      state = song;
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void playPause() {
    if (isPlayiing) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlayiing = !isPlayiing;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double value) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
