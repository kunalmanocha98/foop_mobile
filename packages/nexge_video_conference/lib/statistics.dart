import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:nexge_video_conference/signaling.dart';

class Statistics {
  var statsTimer = null;
  Map<String, int>? bitrateAudio;
  Map<String, int>? bitrateVideo;
  dynamic dummy;
  Signaling? signaling;
  JsonEncoder _encoder = JsonEncoder();
  Timer? timer;

  Statistics(Signaling signaling) {
    this.signaling = signaling;
    bitrateAudio = {
      'bitrateDownload': 0,
      'bitrateUpload': 0,
      'bytesReceivedPrev': 0,
      'timestampReceivedPrev': 0,
      'bytesSentPrev': 0,
      'timestampSentPrev': 0,
    };

    bitrateVideo = {
      'bitrateDownload': 0,
      'bitrateUpload': 0,
      'bytesReceivedPrev': 0,
      'timestampReceivedPrev': 0,
      'bytesSentPrev': 0,
      'timestampSentPrev': 0,
    };

    dummy = {
      'colibriClass': "EndpointStats",
      'bitrate': {
        'upload': 1707,
        'download': 1712,
        'audio': {'upload': 29, 'download': 28},
        'video': {'upload': 1678, 'download': 1684},
      },
      'packetLoss': {'total': 0, 'download': 0, 'upload': 0},
      'connectionQuality': 100,
      'jvbRTT': 89,
      'serverRegion': "ap-south-1",
      'maxEnabledResolution': 2160,
    };
  }

  start() {
    Timer.periodic(new Duration(seconds: 10), (timer) async {
      this.timer = timer;
      try {
        print(timer.tick.toString());

        List<StatsReport> stats = (await this.signaling?.pc?.getStats())!;
        //console.log("gstats", stats);
        if (this.signaling?.statusSocket != null) {
          print('Sending stats=====');
          this.signaling?.statusSocket?.send(_encoder.convert(this.dummy));
        }
        stats.asMap().forEach((index, report) {
          if (report.type != "codec" &&
              report.type != "media-source" &&
              report.type != "local-candidate" &&
              report.type != "remote-candidate" &&
              report.type != "peer-connection" &&
              report.type != "certificate") {
            //if (report.type == "candidate-pair" && report.state == "succeeded")
            //console.log("report" + index, report);

            int bitrate;
            double now = report.timestamp;
            if (report.type == "inbound-rtp" && report.type == "video") {
              /*const bytes = report.bytesReceived;
            if (timestampPrev) {
              bitrate =
                (8 * (bytes - this.bytesReceivedPrev)) /
                (now - this.timestampReceivedPrev);
              bitrate = Math.floor(bitrate);
            }
            this.bytesReceivedPrev = bytes;
            this.timestampReceivedPrev = now;
          }*/
            }
          }
          // this.senders.forEach(async sender => {
          //   const s = await sender.getStats();
          //   console.log(s);
          // });
        });
      } catch (err, s) {
        print('ERROR: ${err}');
        print('ERROR: ${s}');
        timer.cancel();
      }
    });
  }

  stop() {
    this.timer?.cancel();
  }
}
