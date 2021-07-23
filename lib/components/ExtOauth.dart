import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

import 'commonComponents.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ExtOauth extends StatelessWidget {
  ExtOauth({
    this.icon,
    this.text,
    Key? key,
  }) : super(key: key);
  final IconData? icon;
  final String? text;
  late TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return Stack(
      children: <Widget>[
        Container(
          width: 260.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color:  HexColor(AppColors.appColorWhite),
            boxShadow: [CommonComponents().getShadowforBox()],
          ),
        ),
        Transform.translate(
          offset: Offset(58.26, 11.84),
          child: Text(
            this.text!,
            style:styleElements.bodyText2ThemeScalable(context),
            textAlign: TextAlign.left,
          ),
        ),
        Transform.translate(
          offset: Offset(30.4, 13.01),
          child: Stack(
            children: <Widget>[
              // Adobe XD layer: 'search' (group)
              Stack(
                children: <Widget>[
                  // Image
                  Icon(this.icon)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// const String _svg_ucsdwu =
// '<svg viewBox="0.0 0.0 15.1 15.1" ><path transform="translate(0.0, -134.2)" d="M 3.339129447937012 143.3042144775391 L 2.814674139022827 145.2620849609375 L 0.8978012204170227 145.3026275634766 C 0.3249375820159912 144.2400817871094 0 143.0244140625 0 141.7325439453125 C 0 140.4833221435547 0.303808718919754 139.3052978515625 0.8423306345939636 138.2680053710938 L 0.8427425622940063 138.2680053710938 L 2.54929780960083 138.5808868408203 L 3.296871900558472 140.2771606445312 C 3.140406370162964 140.7333374023438 3.055125713348389 141.2230224609375 3.055125713348389 141.7325439453125 C 3.055184364318848 142.2855529785156 3.155355215072632 142.8153991699219 3.339129447937012 143.3042144775391 Z" fill="#fbbb00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-253.93, -202.05)" d="M 268.8641357421875 208.1759796142578 C 268.95068359375 208.6316986083984 268.9957885742188 209.1023254394531 268.9957885742188 209.5832977294922 C 268.9957885742188 210.1226501464844 268.9390869140625 210.6487426757812 268.8310546875 211.1562194824219 C 268.4642944335938 212.8831329345703 267.5060729980469 214.3910369873047 266.1786804199219 215.4581298828125 L 266.1782531738281 215.4577331542969 L 264.0287475585938 215.3480529785156 L 263.7245178222656 213.4489440917969 C 264.6053466796875 212.9323883056641 265.293701171875 212.1239776611328 265.6562805175781 211.1562194824219 L 261.6279907226562 211.1562194824219 L 261.6279907226562 208.1759796142578 L 265.7150573730469 208.1759796142578 L 268.8641357421875 208.1759796142578 L 268.8641357421875 208.1759796142578 Z" fill="#518ef8" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-29.61, -300.3)" d="M 41.86045455932617 313.7117614746094 L 41.86086654663086 313.712158203125 C 40.56985473632812 314.7498474121094 38.92986679077148 315.3706970214844 37.14462280273438 315.3706970214844 C 34.27571105957031 315.3706970214844 31.78141593933105 313.7672119140625 30.50900077819824 311.4074096679688 L 32.9503288269043 309.4089965820312 C 33.58652114868164 311.1069030761719 35.22442626953125 312.3155822753906 37.14462280273438 312.3155822753906 C 37.96997451782227 312.3155822753906 38.74320983886719 312.0924377441406 39.40670776367188 311.7029418945312 L 41.86045455932617 313.7117614746094 Z" fill="#28b446" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-27.78, 0.0)" d="M 40.12364959716797 1.734334707260132 L 37.68314361572266 3.732338905334473 C 36.99645614624023 3.303110599517822 36.18472671508789 3.055154800415039 35.31509017944336 3.055154800415039 C 33.35142517089844 3.055154800415039 31.68288993835449 4.319269180297852 31.07856941223145 6.078057765960693 L 28.62441062927246 4.068871021270752 L 28.62399864196777 4.068871021270752 C 29.87778663635254 1.651555299758911 32.40354156494141 0 35.31509017944336 0 C 37.14297103881836 0 38.81895446777344 0.6511111259460449 40.12364959716797 1.734334707260132 Z" fill="#f14336" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';