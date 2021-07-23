import 'package:nexge_video_conference/utils/sdp_util.dart';

class SDP {
  List<String>? media;
  String? raw;
  String? session;

  SDP(String sdp) {
    List<String> media = sdp.split("\r\nm=");

    for (int i = 1, length = media.length; i < length; i++) {
      String mediaI = 'm=${media[i]}';
      if (i != length - 1) {
        mediaI += "\r\n";
      }
      media[i] = mediaI;
    }

    String session = '${media.removeAt(0)}\r\n';

    this.media = media;
    this.raw = session + media.join("");
    this.session = session;
  }

  getMediaSsrcMap() {
    Map mediaSSRCs = {};

    for (int mediaindex = 0; mediaindex < this.media!.length; mediaindex++) {
      String mid = SDPUtil.parseMID(
          SDPUtil.findLine(this.media?.asMap()[mediaindex], "a=mid:", null));
      Map media = {
        'mediaindex': mediaindex,
        'mid': mid,
        'ssrcs': {},
        'ssrcGroups': [],
      };

      mediaSSRCs[mediaindex] = media;

      SDPUtil.findLines(this.media!.asMap()[mediaindex]!, "a=ssrc:", null)
          .forEach((line) {
        String linessrc = line.substring(7).split(" ")[0];

        // allocate new ChannelSsrc

        if (!media['ssrcs'][linessrc]) {
          media['ssrcs'][linessrc] = {
            'ssrc': linessrc,
            'lines': [],
          };
        }
        media['ssrcs'][linessrc].lines.push(line);
      });
      SDPUtil.findLines(this.media![mediaindex], "a=ssrc-group:", null)
          .forEach((line) {
        int idx = line.indexOf(" ");
        String semantics = line.substring(0, idx).substring(13);
        List<String> ssrcs = line.substring(14 + semantics.length).split(" ");

        if (ssrcs.length > 0) {
          media['ssrcGroups'].push({
            semantics,
            ssrcs,
          });
        }
      });
    }

    return mediaSSRCs;
  }
}
