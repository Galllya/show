import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioPlayerCustom extends StatefulWidget {
  final String audioPath;
  const AudioPlayerCustom({
    super.key,
    required this.audioPath,
  });

  @override
  State<AudioPlayerCustom> createState() => _AudioPlayerCustomState();
}

class _AudioPlayerCustomState extends State<AudioPlayerCustom> {
  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      player.onDurationChanged.listen((Duration d) {
        //get the duration of audio
        maxduration = d.inMilliseconds;
        setState(() {});
      });

      player.onPositionChanged.listen((Duration p) {
        currentpos =
            p.inMilliseconds; //get the current position of playing audio

        //generating the duration label
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() {
          //refresh the UI
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  currentpostlabel,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Slider(
                  value: double.parse(currentpos.toString()),
                  min: 0,
                  max: double.parse(maxduration.toString()),
                  divisions: maxduration,
                  label: currentpostlabel,
                  activeColor: Colors.white,
                  onChanged: (double value) async {
                    int seekval = value.round();
                    currentpos = seekval;

                    await player.seek(
                      Duration(
                        milliseconds: currentpos,
                      ),
                    );
                  },
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!isplaying && !audioplayed) {
                          await player.play(
                            DeviceFileSource(
                              widget.audioPath,
                            ),
                          );
                          setState(() {
                            isplaying = true;
                            audioplayed = true;
                          });
                        } else if (audioplayed && !isplaying) {
                          await player.resume();
                          setState(() {
                            isplaying = true;
                            audioplayed = true;
                          });
                        } else {
                          await player.pause();
                          setState(() {
                            isplaying = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: Icon(
                        isplaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      label: Text(
                        isplaying ? "Pause" : "Play",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await player.stop();
                        setState(() {
                          isplaying = false;
                          audioplayed = false;
                          currentpos = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "Stop",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
