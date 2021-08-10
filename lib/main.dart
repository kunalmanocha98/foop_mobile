import 'dart:async';
import 'dart:io';

import 'package:oho_works_app/home/home.dart';
import 'package:oho_works_app/messenger_module/screens/chat_history_page.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyListModels.dart';
import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/regisration_module/classes_section_provider.dart';
import 'package:oho_works_app/regisration_module/department_notifier.dart';
import 'package:oho_works_app/regisration_module/programnotifier.dart';
import 'package:oho_works_app/regisration_module/select_business_page.dart';
import 'package:oho_works_app/regisration_module/select_language.dart';
import 'package:oho_works_app/regisration_module/subjectProvider.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/services/deeplinking_service.dart';
import 'package:oho_works_app/services/navigation_service.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/ui/BuddyApproval/approvalDetailsPage.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/basic_institute_detail.dart';
import 'package:oho_works_app/ui/RoomModule/room_detail_page.dart';
import 'package:oho_works_app/ui/camera_module/photo_preview_screen.dart';
import 'package:oho_works_app/ui/campus_talk/campus_talk_list.dart';
import 'package:oho_works_app/ui/campus_talk/participant_notifier.dart';
import 'package:oho_works_app/ui/postcardDetail.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/locator.dart';
import 'login_signup_module/login.dart';
import 'login_signup_module/new_password.dart';
import 'login_signup_module/recover_password.dart';
import 'login_signup_module/signup.dart';
import 'login_signup_module/splash.dart';
import 'login_signup_module/verificationOtp.dart';
import 'messenger_module/screens/chat_list_page.dart';
import 'messenger_module/screens/conversationPageNotifier.dart';
import 'messenger_module/screens/data_notifier.dart';
import 'messenger_module/screens/ios_change_provider.dart';
import 'models/RegisterUserAs.dart';

GetIt getIt = GetIt.instance;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  FlutterError.onError=FirebaseCrashlytics.instance.recordFlutterError;
  // ignore: deprecated_member_use
  FirebaseCrashlytics.instance;
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  // await FlutterDownloader.initialize(debug: true);

  runApp(MultiProvider(
    providers: [

      ChangeNotifierProvider(
        create: (context) =>ParticipantNotifier(),

      ),
      ChangeNotifierProvider(
        create: (context) =>IosNotifier(),

      ),

      ChangeNotifierProvider(
        create: (context) =>ConversationNotifier(),

      ),


      ChangeNotifierProvider(
        create: (context) =>ProgramNotifier(),

      ),
      ChangeNotifierProvider(
        create: (context) =>DisciplineNotifier(),

      ),
      ChangeNotifierProvider(
        create: (context) =>SubjectsProvider(),

      ),

      ChangeNotifierProvider(
        create: (context) =>ClassesAndSectionsProvider(),

      ),
      ChangeNotifierProvider(
        create: (context) =>ChatNotifier(null,null,null,null),

      ),
      ChangeNotifierProvider(
        create: (context) =>IosNotifier(),

      ),

      ChangeNotifierProvider(
        create: (context) =>ConversationNotifier(),

      ),
    ],
    child: MainApp(),
  ));;


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

const simpleTaskKey = "simpleTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

Map<int, Color> color = {
  50: Color.fromRGBO(246, 102, 102, .1),
  100: Color.fromRGBO(246, 102, 102, .2),
  200: Color.fromRGBO(246, 102, 102, .3),
  300: Color.fromRGBO(246, 102, 102, .4),
  400: Color.fromRGBO(246, 102, 102, .5),
  500: Color.fromRGBO(246, 102, 102, .6),
  600: Color.fromRGBO(246, 102, 102, .7),
  700: Color.fromRGBO(246, 102, 102, .8),
  800: Color.fromRGBO(246, 102, 102, .9),
  900: Color.fromRGBO(246, 102, 102, 1),
};

Map<int, Color> textColor = {
  500:  HexColor(AppColors.appColorBlack85),
  400:  HexColor(AppColors.appColorBlack65),
  300:  HexColor(AppColors.appColorBlack35),
  200:  HexColor(AppColors.appColorBlack10),
  100:  HexColor(AppColors.appColorWhite),
};

Map<int, Color> appColor = {
  500: HexColor(AppColors.appMainColor),
  400: HexColor(AppColors.appMainColor65),
  300: HexColor(AppColors.appMainColor35),
  200: HexColor(AppColors.appMainColor10),
  100: HexColor(AppColors.appColorWhite),
};

MaterialColor primarySwatch = MaterialColor(0xFFFF2A4B, color);
const HomeRoute = '/';
const PostDetailPage = '/postDetailPage';
const buddyApproval = '/BuddyApproval';
const roomDetail ='/room_detail';
const selectBusiness ='/selectBusiness';
const eventDetail = '/event_detail';
const LoginSignUP = '/loginSignUpPage';
const LoginRoute = '/login';
const UserRoute = '/users';
const SignUp = '/signup';
const RecoverPassword = '/recover_password';
const OTPRecoverPassword = '/otp_recover_password';
const NewPasswords = '/new_password';
const ConversationScreen = '/chatList';
const WelcomeScreen = '/welcomePage';
const OtpVerification = '/otp';
const Conversation = '/conversationPage';
const PplProfile = '/pplprofile';
const RegistrationVerifications = '/registration_verification';
const GetImage = '/getImage';
const SelectInstitutes = '/selectInstitute';
const SelectClasses = '/selectClass';
const SelectLanguages = '/selectLanguage';
const Profile = '/profile';
const chatHistoryPage='/ChatHistoryPage';
final dbHelper = DatabaseHelper.instance;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MainApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    MyApp state = context.findAncestorStateOfType<MyApp>()!;
    state.setLocale(locale);
  }

  MyApp createState() => MyApp();
}

// ignore: must_be_immutable
class MyApp extends State<MainApp> {
  SharedPreferences? prefs;
  late BuildContext context;
  Locale? _locale;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final DynamicLinkService? dynamicLinkService = locator<DynamicLinkService>();
  @override
  // ignore: missing_return
   initState() {
    super.initState();
    setSharedPreferences();
    if(Platform.isIOS) {
      initPlatformState();
    }
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE
        ),
        _onBackgroundFetch)
        .then((int status) {
      print("Hey Pawan Background fetch is successful");
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    print("[Background Fetch status ]"+status.toString());
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // BackgroundFetch.scheduleTask(TaskConfig(
    //     taskId: "com.tricycle.life",
    //     delay: 5000  // <-- milliseconds
    // ));

    if (!mounted) return;
  }

  // _timeOut(String taskId) {
  //   print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //   BackgroundFetch.finish(taskId);
  // }

  void _onBackgroundFetch(String taskId) async {
    if(taskId == 'com.tricycle.life'){
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received----------------------------------------------------------------------------------'+ taskId);
    }else{
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received'+ taskId);
      // Persist fetch events in SharedPreferences

      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }
  }
  GlobalKey<ChatHistoryPageState> ch = GlobalKey();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    // debugPaintSizeEnabled = true;
    //  Firebase.initializeApp();
    GlobalKey<ChatHistoryPageState> ch = GlobalKey();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: HexColor(AppColors.appColorTransparent),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    // ScreenUtil.init(context,designSize: Size(375,812),allowFontScaling: true);

    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(
          color: HexColor(AppColors.appColorBackground),
        ),
      ),
      onGenerateRoute: _routes(),
      navigatorKey: locator<NavigationService>().navigatorKey,
      locale: _locale,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: appColor[500],
        accentColor: appColor[500],
        primaryColorDark: appColor[500],
        primaryColorLight: appColor[300],
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              shape: StadiumBorder(side: BorderSide(color: appColor[500]!)),
              primary: HexColor(AppColors.appMainColor),
            )
        ),
        elevatedButtonTheme:  ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape:StadiumBorder(side: BorderSide(color: appColor[500]!)),
              primary: HexColor(AppColors.appMainColor),
            )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape:StadiumBorder(side: BorderSide(color: appColor[500]!)),
              primary: HexColor(AppColors.appMainColor),
            )
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: HexColor(AppColors.appColorTransparent),
        ),
        fontFamily: 'Source Sans Pro',
        backgroundColor: HexColor(AppColors.appColorBackground),
        scaffoldBackgroundColor: HexColor(AppColors.appColorBackground),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: textColor[500],
          ),
          headline2: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w300,
            color: textColor[500],
          ),
          headline3: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.normal,
            color: textColor[500],
          ),
          headline4: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.normal,
            color: textColor[500],
          ),
          headline5: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor[500],
          ),
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor[500],
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor[500],
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor[400],
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: HexColor(AppColors.appColorBlack65),
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: HexColor(AppColors.appColorBlack65),
          ),
          button: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textColor[400],
              letterSpacing: 1.25),
          caption: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color:HexColor(AppColors.appColorBlack35),
              letterSpacing: 0.4),
          overline: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: HexColor(AppColors.appColorBlack35),
              letterSpacing: 1.5),
        ),
      ),

      supportedLocales: [
        const Locale("en", "US"),
        const Locale("hi", "IN"),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],

      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
    );
  }

  void handleProfilePageDeepLinking(
      List<String> list, SharedPreferences prefs, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    if (list.length > 3) deepLinkingPayload.userId = int.parse(list[3]);
    if (list.length > 1) deepLinkingPayload.userType = list[0];
    // _navigationService.navigateTo("/profile", deepLinkingPayload,context);
    locator<NavigationService>()
        .navigateTo("/profile", deepLinkingPayload, context);
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setSharedPreferences() async {

    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (_locale == null && prefs!.getString('language_code') != "" && prefs!.getString('country_code')!=null) {
        setLocale(Locale(prefs!.getString('language_code')!, prefs!.getString('country_code')));
      }
    }
  }

  RouteFactory _routes() {
    return (settings) {
      // final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;


      DeepLinkingPayload? deepLinkingPayload = settings.arguments as DeepLinkingPayload?;
      // if(deepLinkingPayload==null){
      //   return null;
      // }
      print("------------------------ ${settings.name}");
      switch (settings.name) {
        case HomeRoute:
          // screen = TestImageUpload();
          screen = SplashScreen();
          break;
        case LoginRoute:
          screen = LoginPage();
          break;

        case SignUp:
          screen = SignUpPage();
          break;
        case ConversationScreen:
          screen = ChatListsPage(conversationId: deepLinkingPayload!.id,);
          break;
        case OtpVerification:
          screen = Verification(
            email: "",
            mobileNo: "",
            isRecoverPassword: false,
          );
          break;
        case WelcomeScreen:
          screen = WelComeScreen();
          break;

        case RecoverPassword:
          screen = RecoverPasswords();
          break;

        case NewPasswords:
          screen = NewPassword(
            email: "",
          );
          break;
        case GetImage:
          screen = PhotoPreviewScreen(
            registerUserAs: null,
          );
          break;
        case SelectLanguages:
          screen = SelectLanguage(false);
          break;

        case chatHistoryPage:
          screen = ChatHistoryPage(key:ch,type:deepLinkingPayload!.type,personId: deepLinkingPayload.id,   isVisible: true,);
          break;
        case Profile:
          screen = UserProfileCards(
            type: "",
            currentPosition: 1,
            userId: prefs!.getInt("userId") != null &&
                    prefs!.getInt("userId") != deepLinkingPayload!.userId
                ? deepLinkingPayload.userId
                : null,
            userType: prefs!.getInt("userId") != null &&
                    prefs!.getInt("userId") != deepLinkingPayload!.userId
                ? (deepLinkingPayload.userType == "person"
                    ? "thirdPerson"
                    : deepLinkingPayload.userType)
                : prefs!.getString("ownerType"),
          );
          break;
        case PostDetailPage:
          screen = PostCardDetailPage(
            postId: deepLinkingPayload!=null?deepLinkingPayload.postId:0,
          );
          break;
        case buddyApproval:
          screen = ApprovalDetailsPage(
            data: RequestListItem(
              personId: deepLinkingPayload!.personId,
              profileImage: deepLinkingPayload.profileImage,
              institutionId: deepLinkingPayload.institutionId,
              institutionUserId: deepLinkingPayload.institutionUserId
            ),
          );
          break;
        case roomDetail:
          screen = RoomDetailPage(null,null,null,null,null,deepLinkingPayload!.postId,deepLinkingPayload.userType);
          break;




        case selectBusiness:

          screen=SelectBusiness(  type: "",
              id: 0,
              registerUserAs: RegisterUserAs(),
              isInstituteSelectedAlready:
              false,
              studentType: "",
              from: "welcome");
          break;
        case eventDetail:
          screen = CampusTalkListPage( eventId: deepLinkingPayload!.postId,);
          break;

        case LoginSignUP:
          screen = Home(
            deepLinkingPayload: deepLinkingPayload,
          );
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

}

Future<void> fcmMessageHandler(route, navigatorKey, context) async {
  await navigatorKey.currentState
      .push(MaterialPageRoute(builder: (context) => SelectLanguage(false)));
}

class MessageBean {
  MessageBean({this.itemId});

  final String? itemId;

  StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();

  Stream<MessageBean> get onChanged => _controller.stream;

  String? _status;

  String? get status => _status;

  set status(String? value) {
    _status = value;
    _controller.add(this);
  }
}


