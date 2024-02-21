import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimmerViewer extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  /// For showing the video playback area.
  ///
  /// This only contains optional parameters. They are:
  ///
  /// * [borderColor] for specifying the color of the video
  /// viewer area border. By default it is set to `Colors.transparent`.
  ///
  ///
  /// * [borderWidth] for specifying the border width around
  /// the video viewer area. By default it is set to `0.0`.
  ///
  ///
  /// * [padding] for specifying a padding around the video viewer
  /// area. By default it is set to `EdgeInsets.all(0.0)`.
  ///
  const VideoTrimmerViewer({
    super.key,
    required this.trimmer,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.padding = const EdgeInsets.all(0.0),
  });

  /// The Trimmer instance controlling the data.
  final Trimmer trimmer;

  /// For specifying the color of the video
  /// viewer area border. By default it is set to `Colors.transparent`.
  final Color borderColor;

  /// For specifying the border width around
  /// the video viewer area. By default it is set to `0.0`.
  final double borderWidth;

  /// For specifying a padding around the video viewer
  /// area. By default it is set to `EdgeInsets.all(0.0)`.
  final EdgeInsets padding;

  @override
  State<VideoTrimmerViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoTrimmerViewer> {
  /// Quick access to VideoPlayerController, only not null after [TrimmerEvent.initialized]
  /// has been emitted.
  VideoPlayerController? get videoPlayerController =>
      widget.trimmer.videoPlayerController;

  @override
  void initState() {
    widget.trimmer.eventStream.listen((event) {
      if (event == TrimmerEvent.initialized) {
        //The video has been initialized, now we can load stuff
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = videoPlayerController;
    return controller == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: controller.value.isInitialized
                ? Container(
                    foregroundDecoration: BoxDecoration(
                      border: Border.all(
                        width: widget.borderWidth,
                        color: widget.borderColor,
                      ),
                    ),
                    child: VideoPlayer(controller),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
          );
  }

  @override
  void dispose() {
    widget.trimmer.dispose();
    super.dispose();
  }
}
