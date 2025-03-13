import 'package:event_planner/screens/login/personal_info_screen.dart';
import 'package:event_planner/screens/login/restore_pass_screen.dart';
import 'package:event_planner/screens/login/signup_screen.dart';
import 'package:event_planner/screens/login/welcome_screen.dart';
import 'package:event_planner/screens/more/edit_profile_screen.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/screens/splash/splash_screen.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/';
  static String login = '/login';
  static String welcome = '/welcome';
  static String personalInfo = '/personalInfo';
  static String signup = '/signup';
  static String restorePass = '/restorePass';
  static String navBar = '/navBar';
  static String editProfile = '/editProfile';

  static final Handler _splashHandler = Handler(handlerFunc: (context, parameters) => SplashScreen());
  static final Handler _loginHandler = Handler(handlerFunc: (context, parameters) => LoginScreen());
  static final Handler _welcomeHandler = Handler(handlerFunc: (context, parameters) => WelcomeScreen());
  static final Handler _signupHandler = Handler(handlerFunc: (context, parameters) => SignUpScreen());
  static final Handler _restorePassHandler =
      Handler(handlerFunc: (context, parameters) => RestorePasswordScreen());
  static final Handler _personalInfoHandler =
      Handler(handlerFunc: (context, parameters) => PersonalInfoScreen());
  static final Handler _navBarHandler = Handler(handlerFunc: (context, parameters) => NavBarScreen());
  static final Handler _editHandler = Handler(handlerFunc: (context, parameters) => EditProfileScreen());

  static void setupRouter() {
    router.define(splash, handler: _splashHandler, transitionType: TransitionType.none);
    router.define(login,
        handler: _loginHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(welcome,
        handler: _welcomeHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(personalInfo,
        handler: _personalInfoHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(signup,
        handler: _signupHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(restorePass,
        handler: _restorePassHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(navBar,
        handler: _navBarHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(editProfile,
        handler: _editHandler,
        transitionType: TransitionType.none,
        transitionDuration: const Duration(milliseconds: 200));
  }
}
