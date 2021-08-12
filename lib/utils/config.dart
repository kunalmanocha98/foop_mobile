import 'package:oho_works_app/utils/base_urls.dart';

class Config {

  static String BASE_URL = BaseUrls.BASE_URL;
  static String BASE_URL_WITHOUT_HTTP = BaseUrls.BASE_URL_WITHOUT_HTTP;
  static String BASE_URL_MESSENGER = BaseUrls.BASE_URL_MESSENGER;
  static String BASE_URL_AUDIO = BaseUrls.BASE_URL_AUDIO;
  static String BASE_URL_MAIL = BaseUrls.BASE_URL_MAIL;


  static String LOGIN_API = BASE_URL + '/api/v1/rl/login/';
  static String LOGOUT_API = BASE_URL + '/api/v1/rl/logout/';
  static String REGISTER_USER = BASE_URL + '/api/v1/rl/register/';
  static String ACTIVATE_REGISTRATION = BASE_URL +
      '/api/v1/rl/activate/';
  static String RECOVER_PASSWORD =
      BASE_URL + '/api/v1/rl/forgot-password/';
  static String RECOVER_PASSWORD_OTP =
      BASE_URL + '/api/v1/rl/forgot-password-otp/';
  static String RESET_PASSWORD = BASE_URL +
      '/api/v1/rl/password-reset/';
  static String ROLES_LIST = BASE_URL + '/api/v1/standard/role/list';
  static String SUBJECT_LIST =
      BASE_URL + '/api/v1/business/subject/list';
  static String CLASSES_LIST =
      BASE_URL + '/api/v1/business/class/list';
  static String SUBJECTS_CATEGORIES =
      BASE_URL + '/api/v1/standard/subjectcategories/list';
  static String COURSE_LIST = BASE_URL + '/api/v1/standard/course/list';
  static String PERSONAL_PROFILE = BASE_URL + '/api/v1/user/profile/';
  static String INSTITUTE_DETAILS = BASE_URL +
      '/api/v1/business/details';
  static String INSTITUTE_CLASSES =
      BASE_URL + '/api/v1/business/class/list';
  static String PERSON_LIST =
      BASE_URL + '/api/v1/standard/persontype/list';
  static String REGISTER_USER_AS =
      BASE_URL + '/api/v1/business/user/register';

  static String LANGUAGE_LIST =
      BASE_URL + '/api/v1/standard/applanguage/list';

  static String DATEFORMATLIST =
      BASE_URL + '/api/v1/standard/dateformat/list';

  static String CURRENCYFORMATLIST =
      BASE_URL + '/api/v1/standard/currency/list';

  static String INSTITUTE_LIST = BASE_URL + '/api/v1/business/list';

  static String ALREADY_EXIST_USER_CHECK =
      BASE_URL + '/api/v1/rl/social/login/';

  static String SETTINGSVIEW =
      BASE_URL + '/api/v1/utility/account/settings/view';

  static String DICTIONARYLIST = BASE_URL +
      '/api/v1/standard/dictionary/list';

  static String ROOM_TYPE_LIST = BASE_URL + '/api/v1/rooms/types/list';

  static String UPDATEACCOUNTSETTING =
      BASE_URL + '/api/v1/utility/account/settings/update';

  static String UPDATEPRIVACYSETTINGS =
      BASE_URL + '/api/v1/utility/privacy/settings/update';

  static String PRIVACYSETTINGSVIEW =
      BASE_URL + '/api/v1/utility/privacy/settings/view';

  static String CHANGEPASSWORD = BASE_URL +
      '/api/v1/rl/change-password/';
  static String FOLLOW_UNFOLLOW_BLOCK = BASE_URL +
      '/api/v1/network/follow';
  static String FOLLOWERS_COUNT =
      BASE_URL + '/api/v1/network/get-follower-count';
  static String FOLLOWERS_List =
      BASE_URL + '/api/v1/network/get-followers-list';
  static String FOLLOWING_LIST =
      BASE_URL + '/api/v1/network/get-following-list';
  static String CREATE_COMMENT_REVIEW_FEEDBACK =
      BASE_URL + '/api/v1/rr/notes/create';
  static String UPDATE_COMMENT_REVIEW =
      BASE_URL + '/api/v1/rr/notes/update';
  static String COMMENTS_LIST = BASE_URL + '/api/v1/rr/notes/list';
  static String CREATE_RATINGS = BASE_URL + '/api/v1/rr/ratings/create';
  static String RESEND_OTP = BASE_URL + '/api/v1/rl/resend-otp/';
  static String USER_LIST = BASE_URL + '/api/v1/business/user/list';
  static String ACMC_API =
      BASE_URL + '/api/v1/standard/academicyear/list';
  static String PROFILEEDIT = BASE_URL + '/api/v1/user/profile/edit';
  static String IMAGEUPDATE = BASE_URL + '/api/v1/file/update/';
  static String CREATEABUSE = BASE_URL + '/api/v1/bi/reports/create';
  static String ALLUSERLIST = BASE_URL + '/api/v1/user/list';
  static String SYNC_CONTACT =
      BASE_URL + '/api/v1/network/contact/synccontactdetail';
  static String SEND_FCM_TOKEN = BASE_URL +
      '/api/v1/network/contact/setfcmid';
  static String USER_PROFILE = BASE_URL + '/api/v1/business/profile';
  static String ADD_EDIT_EDUCATION_WORK =
      BASE_URL + '/api/v1/user/edit_education';

  static String CREATE_ROOM = BASE_URL + "/api/v1/rooms/create";

  static String UPDATEROOM = BASE_URL + "/api/v1/rooms/update";

  static String ROOMS_LIST = BASE_URL + "/api/v1/rooms/list";

  static String MEMBER_ADD = BASE_URL + '/api/v1/rooms/member/add';

  static String MEMBERSLIST =
      BASE_URL + '/api/v1/rooms/member/select/list';

  static String ROOMMEMBERLIST = BASE_URL + '/api/v1/rooms/member/list';

  static String MEMBERSHIP_STATUS_UPDATE =
      BASE_URL + '/api/v1/rooms/membershipstatus/update';

  static String MEMBERSHIP_ROLE_UPDATE =
      BASE_URL + '/api/v1/rooms/memberrole/update';

  static String ALLCOUPONLIST = BASE_URL + '/api/v1/reward/couponlist';

  static String MYCOUPONLIST = BASE_URL + '/api/v1/reward/mycouponlist';

  static String COUPONBALANCE =
      BASE_URL + '/api/v1/reward/balancedetails';

  static String COUPON_LEDGER_LIST =
      BASE_URL + '/api/v1/reward/ledgerlist';
  static String COUPON_DETAIL =
      BASE_URL + '/api/v1/reward/coupondetails';
  static String COUPON_PURCHASE =
      BASE_URL + '/api/v1/reward/purchasecoupons';
  static String ADD_WORK_EDUCATION =
      BASE_URL + '/api/v1/user/add_education_work';
  static String EDUCATIONS =
      BASE_URL +
          '/api/v1/utility/see_more/education_card_see_more_api';
  static String WORK_EXP =
      BASE_URL + '/api/v1/utility/see_more/work_card_see_more_api';
  static String DROP_DOWN_GLOBAL =
      BASE_URL + '/api/v1/utility/see_more/dictonary_list';

  static String DETAIL_CLASSES =
      BASE_URL + '/api/v1/utility/see_more/class_card_see_more_api';
  static String DETAILS_SUBJECTS =
      BASE_URL + '/api/v1/utility/see_more/subject_card_see_more_api';

  static String GLOBAL_CATEGORY_LIST =
      BASE_URL + '/api/v1/user/expertise/standard_category_abilities';

  static String ADD_CLASS = BASE_URL +
      '/api/v1/user/expertise/add_class';
  static String ADD_SUBJECT =
      BASE_URL + '/api/v1/user/expertise/add_subject';
  static String EDIT_CLASS = BASE_URL +
      '/api/v1/user/expertise/edit_class';

  static String GLOBAL_GOAL_LIST = BASE_URL +
      '/api/v1/user/expertise/standard_expertise_category_goals_list';

  static String DELETE_CLASS_SUBJECT =
      BASE_URL + '/api/v1/user/expertise/delete_class_subject';

  static String EXPERTISE_API =
      BASE_URL + '/api/v1/user/expertise/expertise_list';

  static String ADD_LANGUAGE_SKILLS =
      BASE_URL + '/api/v1/user/expertise/set_expertise';

  static String LANGUAGE_SKILLS_SEE_MORE =
      BASE_URL + '/api/v1/user/expertise/get_user_expertise_list';
  static String EDIT_SUBJECT =
      BASE_URL + '/api/v1/user/expertise/edit_subject';
  static String SUBJECT_EXPERTIES =
      BASE_URL + '/api/v1/user/expertise/expertise_subject_list';
  static String CLASSES_EXPERTISE =
      BASE_URL + '/api/v1/user/expertise/expertise_class_list';
  static String UPDATE_RATINGS = BASE_URL + '/api/v1/rr/ratings/update';
  static String MEDIUM_SEE_MORE =
      BASE_URL +
          '/api/v1/utility/see_more/medium_of_education_see_more_api';
  static String COURSES_SEE_MORE =
      BASE_URL + '/api/v1/utility/see_more/course_see_more_api';
  static String CLUBS_SEE_MORE =
      BASE_URL +
          '/api/v1/utility/see_more/club_and_society_see_more_api';
  static String SPORTS_SEE_MORE =
      BASE_URL + '/api/v1/utility/see_more/sport_see_more_api';

  static String DROP_DOWN_FACILITIES_TYPE =
      BASE_URL + '/api/v1/standard/facilitytype/list';
  static String CREATE_FACILITY =
      BASE_URL + '/api/v1/business/facilities/create';

  static String POSTLIST = BASE_URL + '/api/v1/post/list';

  static String CREATE_POST = BASE_URL + '/api/v1/post/create';

  static String UPDATE_POST = BASE_URL + '/api/v1/post/update';

  static String UPDATE_RECIPIENT_LIST =
      BASE_URL + '/api/v1/post/recipient/update';

  static String POST_RECEIVER_LIST =
      BASE_URL + '/api/v1/utility/recipienttype/list';
  static String CAMPUS_FACILITIES_SEE_MORE =
      BASE_URL +
          '/api/v1/utility/see_more/campus_and_facility_see_more_api';

  static String RATINGS_LIST = BASE_URL + '/api/v1/rr/ratings/list';

  static String KEYWORDS_LIST =
      BASE_URL + '/api/v1/standard/keyword/list';

  static String COLOR_LIST = BASE_URL + '/api/v1/standard/color/list';

  static String SUGGESTIONS_LIST =
      BASE_URL + '/api/v1/utility/suggestions/list';

  static String REFRESH_LIST = BASE_URL + '/api/v1/post/refresh';

  static String POST_SUBTYPE_LIST = BASE_URL +
      '/api/v1/standard/postsubtype/list';
  static String OTHER_POST_LIST = BASE_URL + '/api/v1/post/others/list';
  static String CODE_VERIFICATION =
      BASE_URL + '/api/v1/invitation/check/code';
  static String DYNAMIC_IMAGE_URL = '/api/v1/file/media/read';

  static String MEDIA_FILES = BASE_URL + '/api/v1/file/media/list';
  static String BLOCKED_USERS_LIST = BASE_URL +
      '/api/v1/network/get_block_list';
  static String GLOBAL_SEARCH = BASE_URL + '/api/v1/global/search';
  static String GLOBAL_SEARCH_HISTORY = BASE_URL +
      '/api/v1/global/search/history';
  static String GETBELLNOTIFICATIONS = BASE_URL +
      '/tricyclenotifications/getbellnotification';
  static String ANSWER_CREATE = BASE_URL + '/api/v1/post/answer/create';
  static String ANSWER_UPDATE = BASE_URL + '/api/v1/post/answer/update';

  static String ANSWER_LIST = BASE_URL + '/api/v1/post/answer/list';
  static String SHARE_URL = BASE_URL +
      '/api/v1/utility/share/share_url';
  static String POST_VIEW = BASE_URL + '/api/v1/post/view';
  static String INVITATION_LINK = BASE_URL + '/api/v1/invitation/link';
  static String SAVE_DEEP_LINK_RESPONSE = BASE_URL +
      '/api/v1/utility/share/set_share_responses';
  static String INVITATION_CREATE = BASE_URL +
      '/api/v1/invitation/create';
  static String INVITE_USERS = BASE_URL + '/api/v1/invitation/create';
  static String NOTIFICATION_COUNT = BASE_URL +
      '/tricyclenotifications/getbellnotificationcount';
  static String UPDATE_COUNT = BASE_URL +
      '/tricyclenotifications/updatebellnotificationcount';
  static String MENTIONS_LIST = BASE_URL +
      '/api/v1/utility/mention/list';

  static String HOME_PAGE_CARDS = BASE_URL + '/api/v1/utility/home/';
  static String CALL_BACK = BASE_URL +
      '/api/v1/bi/call_back/create_mktg_all_enquiries';

  static String ROOM_DETAILS = BASE_URL + '/api/v1/rooms/view';

  static String TERM_CONDITIONS = BASE_URL +
      '/api/v1/pageutility/page/view';
  static String SUGGESTIONS = BASE_URL +
      '/api/v1/utility/suggestions/list';
  static String RATERS_LIST = BASE_URL +
      '/api/v1/rr/ratings/rated/list';
  static String POLL_RESPOND = BASE_URL + '/api/v1/post/poll/respond';
  static String POLL_VOTES_LIST = BASE_URL +
      '/api/v1/post/poll/responses/list';
  static String REFFERRAL_INSTITUTE = BASE_URL +
      '/api/v1/utility/banner/create_referral';
  static String INSTITUTION_STAFFLIST = BASE_URL +
      '/api/v1/utility/institution_staff_list';
  static String PROGRAM_LIST = BASE_URL +
      '/api/v1/business/program/list';
  static String DEPARTMENT_LIST = BASE_URL +
      '/api/v1/business/department/list';
  static String SECTIONS_LIST = BASE_URL +
      '/api/v1/business/section/list';
  static String COUNTRIES = BASE_URL + '/api/v1/rl/countries/';
  static String STATES = BASE_URL + '/api/v1/rl/states/';
  static String BASIC_INSTITUTE_REGISTER = BASE_URL +
      '/api/v1/business/basic/register';
  static String INSTITUTE_CONTACT = BASE_URL +
      '/api/v1/business/contact/register/';
  static String INSTITUTE_ADDRESS = BASE_URL +
      '/api/v1/business/location/register/';
  static String CARD_ALLOCATE = BASE_URL +
      '/api/v1/scratch/card/allocate';
  static String CARD_SCRATCHED = BASE_URL + '/api/v1/scratch/card/open';
  static String GET_REFERRAL_DETAILS = BASE_URL +
      '/api/v1/utility/banner/referral_detail';
  static String CREATE_REF = BASE_URL +
      '/api/v1/utility/banner/create_referral';
  static String ADD_DOMAIN_INSTITUTE = BASE_URL +
      '/api/v1/business/domain/create';
  static String REQUEST_LIST = BASE_URL +
      '/api/v1/business/request/list';
  static String QUESTIONNAIRE_LIST = BASE_URL +
      '/api/v1/utility/buddy/set/questionarrie';
  static String VERIFY_RESPONSE = BASE_URL +
      '/api/v1/utility/buddy/verify/response';
  static String REQUEST_UPDATE = BASE_URL +
      '/api/v1/business/request/update';
  static String BUDDY_SERVICE_LIST = BASE_URL +
      '/api/v1/utility/buddy/menu/list';
  static String CHILD_DETAIL_CREATE = BASE_URL +
      '/api/v1/business/child_details/create';
  static String COMMON_NEW_ENTRY = BASE_URL +
      '/api/v1/utility/master/common_insertion';
  static String OTHERS_NAME_SCHOOL = BASE_URL +
      '/api/v1/business/othernames/list';
  static String CALENDERS_EVENT_LIST = BASE_URL +
      '/api/v1/calendar/event/list';
  static String CHAT_MESSAGES_UNREAD_COUNT = BASE_URL_MESSENGER +
      '/api/v1/messenger/conversations/getTotalUnreadCount';

  //===================================================Messengers Apis
  static String GET_CONNECTIONS = BASE_URL_MESSENGER +
      '/api/v1/messenger/connections/listConnections';
  static String CREATE_CONVERSATION = BASE_URL_MESSENGER +
      '/api/v1/messenger/conversations/createConversation';
  static String LIST_CONVERSATION = BASE_URL_MESSENGER +
      '/api/v1/messenger/conversations/listConversations';
  static String LIST_MESSAGES = BASE_URL_MESSENGER +
      '/api/v1/messenger/conversations/listConversationMessages';
  static String DELETE_MESSAGE = BASE_URL_MESSENGER +
      '/api/v1/messenger/conversations/deleteConversationMessage';

  static String RATING_SUMMARY = BASE_URL +
      '/api/v1/rr/ratings/summary';
  static String ROOM_PRIVACY_TYPE_LIST = BASE_URL +
      '/api/v1/standard/roomprivacytype/list';
  static String ROOM_TOPIC_LIST = BASE_URL +
      '/api/v1/standard/roomtopic/list';
  static String ROOM_VIEW = BASE_URL + '/api/v1/rooms/view';
  static String EVENT_MEMBERS_LIST = BASE_URL +
      '/api/v1/calendar/event/member/list';
  static String EVENT_MEMBER_SELECT_LIST = BASE_URL +
      '/api/v1/calendar/event/member/select/list';
  static String EVENT_INVITEE_SELECT_LIST = BASE_URL +
      '/api/v1/utility/event/select/invitee/list';
  static String CREATE_EVENT = BASE_URL +
      '/api/v1/calendar/event/create';
  static String EVENT_TYPE_LIST = BASE_URL +
      '/api/v1/calendar/eventtype/list';
  static String TALK_EVENT_LIST = BASE_URL +
      '/api/v1/calendar/event/talk/list';
  static String TALK_EVENT_VIEW = BASE_URL +
      '/api/v1/calendar/event/view';
  static String COUNTRY_CODES = BASE_URL +
      '/api/v1/rl/countrymobile/list/';
  static String TALK_EVENT_INVITEE_ADD = BASE_URL +
      '/api/v1/calendar/event/invitee/add';
  static String CLASSES_SECTIONS = BASE_URL +
      '/api/v1/business/class/section/list';
  static String EVENT_HOST_LIST = BASE_URL +
      '/api/v1/calendar/event/host/select';
  static String GET_PROFILE_PROGRESS = BASE_URL +
      '/api/v1/utility/get/profile/progress';
  static String INSTITUTION_DELETE_ROLE = BASE_URL +'/api/v1/business/user/role/delete';
  static String ADD_NEW_CONTACTS = BASE_URL +
      '/api/v1/rl/contact/add';
  static String MAKE_CONTACT_PRIMARY = BASE_URL +
      '/api/v1/rl/contact/primary';

  static String DELETE_CONTACT = BASE_URL +
      '/api/v1/rl/contact/delete';

  static String SEND_OTP_FOR_EMAIL_PHONE_VERIFICATION = BASE_URL +
      '/api/v1/rl/contact/send/otp';

  static String EMAIL_PHONE_VERIFICATION_CODE = BASE_URL +
      '/api/v1/rl/contact/verify';

  static String APP_UPDATE = BASE_URL +
      '/api/v1/utility/app/version/settings';

  static String CHAT_CALL_ALLOWED = BASE_URL +
      '/api/v1/utility/user/call/allowed';

  static String SUBJECT_MASTERLIST = BASE_URL+'/api/v1/standard/subject/list';
  static String CLASS_MASTERLIST = BASE_URL+'/api/v1/standard/class/list';
  static String EDUFLUENCER_REGISTER = BASE_URL+'/api/v1/utility/edufluencer/register';
  static String EDUFLUENCER_REQUEST = BASE_URL+'/api/v1/utility/edufluencer/student/request';
  static String EDUFLUENCER_REQUESTED_PERSON_DETAILS = BASE_URL+'/api/v1/utility/edufluencer/student/request/details';
  static String EDUFLUENCER_REQUESTED_ACCEPT_REJECT = BASE_URL+'/api/v1/utility/edufluencer/student/request/update';
  static String EDUFLUENCER_TUTOR_LIST = BASE_URL +'/api/v1/utility/edufluencer/list';
  static String EDUFLUENCER_TUTOR_STUDENT_LIST = BASE_URL + '/api/v1/utility/edufluencer/student/list';
  static String EDUFLUENCER_TUTOR_STATUS = BASE_URL + '/api/v1/utility/edufluencer/get/status';
  static String ADMIN_STAFF_LIST = BASE_URL + '/api/v1/business/admin/staff_list';
  static String ADMIN_ASSIGN_ROLE= BASE_URL + '/api/v1/business/admin/assign_role_admin';
  static String ADMIN_LIST = BASE_URL +'/api/v1/business/admin/institute_admin_list';
  static String ADMIN_REMOVE = BASE_URL+'/api/v1/business/admin/delete_role_admin';
  static String DETAIL_PAGE_PAGINATION = BASE_URL+'/api/v1/post/scroll/list';

  static String CHAPTERS_LIST = BASE_URL+'/api/v1/standard/chapter/list';
  static String LESSON_LIST = BASE_URL+'/api/v1/standard/lesson/list';
  static String TOPIC_TYPE_LIST = BASE_URL+'/api/v1/standard/topic/list';
  static String LEARNER_TYPE_LIST = BASE_URL+'/api/v1/standard/learner/category/list';
  static String CREATE_CHAPTER = BASE_URL+'/api/v1/standard/chapter/create';
  static String CREATE_LESSON = BASE_URL+'/api/v1/standard/lesson/create';


  static String ACADEMIC_ORGANISATION_LIST = BASE_URL + '/api/v1/standard/organization/list';
  static String ACADEMIC_PROGRAM_LIST = BASE_URL + '/api/v1/standard/program/list';
  static String ACADEMIC_CLASS_LIST = BASE_URL + '/api/v1/standard/class/list';
  static String ACADEMIC_SUBJECT_LIST = BASE_URL + '/api/v1/standard/subject/list';
  static String ACADEMIC_DISCIPLINE_LIST = BASE_URL + '/api/v1/standard/department/list';
  static String TOPIC_LIST = BASE_URL + "/api/v1/standard/topic/list";

  static String SAVE_HISTORY = BASE_URL+'/api/v1/global/save/history';

  static String SET_REMINDER_CALENDAR = BASE_URL + '/api/v1/calendar/event/set/reminder';
  static String NEXGE_TOKEN = BaseUrls.NEXGE_BASE_URL + '/api/v1/auth/login';



  static String EMAIL_INBOX = BASE_URL_MAIL + '/api/v1/email/list';
  static String EMAIL_LOGIN = BASE_URL_MAIL + '/api/v1/email/login';
  static String EMAIL_DETAIL = BASE_URL_MAIL + '/api/v1/email/get';
  static String EMAIL_COMPOSE = BASE_URL_MAIL + '/api/v1/email/send';
  static String EMAIL_DRAFT = BASE_URL_MAIL + '/api/v1/email/save/draft';
  static String EMAIL_REPLY = BASE_URL_MAIL + '/api/v1/email/reply';
  static String EMAIL_FORWARD = BASE_URL_MAIL + '/api/v1/email/forward';
  static String EMAIL_FLAG_SET = BASE_URL_MAIL + '/api/v1/email/flag/set';
  static String EMAIL_FLAG_REMOVE = BASE_URL_MAIL + '/api/v1/email/flag/remove';
  static String EMAIL_DOMAIN_CREATE = BASE_URL_MAIL + '/api/v1/email/domain/create';
  static String EMAIL_DOMAIN_LIST = BASE_URL_MAIL + '/api/v1/email/domain/list';
  static String EMAIL_USER_CREATE = BASE_URL_MAIL + '/api/v1/email/user/create';
  static String EMAIL_USER_EXIST = BASE_URL_MAIL + '/api/v1/email/user/exists';
  static String EMAIL_GLOBAL_USER_LIST = BASE_URL_MAIL + '/api/v1/email/user/global/list';
  static String EMAIL_USER_LISTING = BASE_URL_MAIL + '/api/v1/email/user/list';
  static String EMAIL_USER_DELETE = BASE_URL_MAIL + '/api/v1/email/user/delete';
  static String EMAIL_PASSWORD_UPDATE = BASE_URL_MAIL + '/api/v1/email/update/password';
  static String EMAIL_FOLDER_LIST =BASE_URL_MAIL + '/api/v1/email/folder/list';
  static String EMAIL_FOLDER_CREATE =BASE_URL_MAIL + '/api/v1/email/folder/create';
  static String EMAIL_FOLDER_DELETE =BASE_URL_MAIL + '/api/v1/email/folder/delete';
  static String EMAIL_FOLDER_RENAME =BASE_URL_MAIL + '/api/v1/email/folder/rename';
  static String EMAIL_FORGOT_PASSWORD =BASE_URL_MAIL + '/api/v1/email/forgot-password';
  static String EMAIL_FORGOT_PASSWORD_OTP = BASE_URL_MAIL + '/api/v1/email/forgot-password-otp';
  static String EMAIL_MOVE_FOLDER = BASE_URL_MAIL + '/api/v1/email/move';
  static String EMAIL_DELETE = BASE_URL_MAIL + '/api/v1/email/delete';
  static String BUSINESS_ACCOUNTING_REGISTER= BASE_URL_MAIL + '/api/v1/business/accounting/register';
  static String BUSINESS_ACCOUNTING_EDIT= BASE_URL_MAIL + '/api/v1/business/accounting/edit';
  static String BASIC_BUSINESS_EDIT=BASE_URL+'/api/v1/business/basic/edit';
  static String EDIT_DOMAIN=BASE_URL+'/api/v1/business/domain/update';
  static String EDIT_CONTACTS=BASE_URL+'/api/v1/business/contact/register/';
  static String EDIT_LOCATION=BASE_URL+'/api/v1/business/location/edit';
  static String LOCATION_DETAILS=BASE_URL+'/api/v1/business/location/detail';

  static String DEPARTMENT_CREATE =BASE_URL+ "/api/v1/business/department/create";







}
