import 'dart:convert';

import 'package:event_planner/data/model/image_model.dart';
import 'package:event_planner/data/model/post_model.dart';
import 'package:event_planner/screens/home/all_photo_Screen.dart';
import 'package:event_planner/screens/login/personal_info_screen.dart';
import 'package:event_planner/screens/login/restore_pass_screen.dart';
import 'package:event_planner/screens/login/signup_screen.dart';
import 'package:event_planner/screens/login/welcome_screen.dart';
import 'package:event_planner/screens/more/edit_profile_screen.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:event_planner/screens/post/post_details_screen.dart';
import 'package:event_planner/screens/post/post_screen.dart';
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
  static String post = '/post';
  static String postDetails = '/postDetails';
  static String allPhotos = '/allPhotos';
  
  static String getPostDetailRoute(PostModel post) {
    String encodedJson = Uri.encodeComponent(jsonEncode(post.toJson()));
    return "$postDetails?postJson=$encodedJson";
  }

  static String getAllPhotosRoute(List<String> images, List<ImageModel> imageModels) {
    String encodedImages = Uri.encodeComponent(jsonEncode(images));
    String encodedModels = Uri.encodeComponent(jsonEncode(imageModels.map((model) => model.toJson()).toList()));
    return "$allPhotos?images=$encodedImages&models=$encodedModels";
  }

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
  static final Handler _postHandler = Handler(handlerFunc: (context, parameters) => PostListScreen());

  static final Handler _postDetailsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) {
      String encodedJson = Uri.decodeComponent(params["postJson"]?.first ?? "{}");
      Map<String, dynamic> jsonMap = json.decode(encodedJson);
      PostModel post = PostModel.fromJson(jsonMap);
      return PostDetailScreen(post: post);
    },
  );

  static final Handler _allPhotosHandler = Handler(
    handlerFunc: (context, Map<String, List<String>> params) {
      // Decode query parameters from the URL
      String encodedImages = params["images"]?.first ?? "[]";
      String encodedModels = params["models"]?.first ?? "[]";

      List<String> images = List<String>.from(json.decode(Uri.decodeComponent(encodedImages)));
      List<dynamic> modelsJson = json.decode(Uri.decodeComponent(encodedModels));
      List<ImageModel> imageModels = modelsJson.map((json) => ImageModel.fromJson(json)).toList();

      return AllPhotosScreen(images: images, imageModels: imageModels);
    },
  );

  static void setupRouter() {
    router.define(splash, handler: _splashHandler, transitionType: TransitionType.none);
    router.define(login,
        handler: _loginHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(welcome,
        handler: _welcomeHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(personalInfo,
        handler: _personalInfoHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(signup,
        handler: _signupHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(restorePass,
        handler: _restorePassHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(navBar,
        handler: _navBarHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(editProfile,
        handler: _editHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(post,
        handler: _postHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: const Duration(milliseconds: 200));
    router.define(
      "/postDetails/:postJson",
      handler: _postDetailsHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      "/allPhotos",
      handler: _allPhotosHandler,
      transitionType: TransitionType.fadeIn,
    );
  }
}
