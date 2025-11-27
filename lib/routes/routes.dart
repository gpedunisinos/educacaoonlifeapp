import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/middlewares/route_middleware.dart';
import 'package:unisinos_usp_app/screens/screens.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/routes/routes.dart';

List<GetPage> appRoutes() => [
      ...widgetsSpoRoutes,
      GetPage(name: '/splash', page: () => SplashScreen()),
      GetPage(name: '/login', page: () => LoginScreen()),
      GetPage(name: '/create_account', page: () => CreateAccountScreen()),
      GetPage(name: '/recover_password', page: () => RecoverPasswordScreen()),
      GetPage(name: '/code_confirmation', page: () => CodeConfirmationScreen()),
      GetPage(name: '/create_password', page: () => CreatePasswordScreen()),
      GetPage(
        name: '/student_home',
        page: () => StudentHomeLayout(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
          Get.put<NotificationController>(NotificationController(), permanent: true);
          Get.lazyPut<TrailController>(() => TrailController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isStudent)],
      ),
      GetPage(
        name: '/teacher_home',
        page: () => TeacherHomeLayout(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
          Get.put<NotificationController>(NotificationController(), permanent: true);
          Get.lazyPut<TrailController>(() => TrailController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isTeacher)],
      ),
      GetPage(
        name: '/admin_home',
        page: () => AdminHomeLayout(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
          Get.put<NotificationController>(NotificationController(), permanent: true);
          Get.lazyPut<TrailController>(() => TrailController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
          name: '/users_list',
          page: () => UsersListScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<UsersListController>(() => UsersListController(), fenix: true);
          })),
      GetPage(name: '/users_list_filter', page: () => UsersListFilterScreen()),
      GetPage(
          name: '/user_editor/:id',
          page: () => UserEditorScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<UserEditorController>(() => UserEditorController(), fenix: true);
          })),
      GetPage(name: '/search', page: () => SearchScreen()),
      GetPage(
          name: '/categories_manager',
          page: () => CategoriesManagerScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<CategoryManagerController>(() => CategoryManagerController());
          })),
      GetPage(
        name: '/category_editor',
        page: () => CategoryEditorScreen(),
        binding: BindingsBuilder(() {
          final args = Get.arguments;

          Get.lazyPut<CategoryEditorController>(() => CategoryEditorController(
                category: args != null ? (args as Map)['category'] : null,
              ));
          Get.lazyPut<TrailManagerController>(() => TrailManagerController(
                categoryId: args != null ? (args as Map)['category_id'] : null,
              ));
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
        name: '/trails_manager',
        page: () => TrailsManagerScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<TrailManagerController>(() => TrailManagerController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
        name: '/trail_editor',
        page: () => TrailEditorScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<TrailEditorController>(() => TrailEditorController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
          name: '/trails/:category_id',
          page: () => TrailsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<TrailListController>(() => TrailListController());
          })),
      GetPage(
          name: '/notifications',
          page: () => NotificationsScreen(),
          binding: BindingsBuilder(() {
            Get.put(NotificationController(), tag: 'newNotifications');
          })),
      GetPage(
          name: '/my_trails',
          page: () => MyTrailsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AssessmentConcludedController>(() => AssessmentConcludedController());
          })),
      GetPage(
          name: '/trail_details/:id',
          page: () => TrailDetailsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<TrailDetailsController>(() => TrailDetailsController());
            Get.lazyPut<AssessmentConcludedController>(() => AssessmentConcludedController(), fenix: true);
          })),
      GetPage(
        name: '/classes_manager',
        page: () => ClassesManagerScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ClassesManagerController>(() => ClassesManagerController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
        name: '/class_editor',
        page: () => ClassEditorScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ClassEditorController>(() => ClassEditorController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
        name: '/class_details/:id',
        page: () => ClassDetailsScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ClassController>(() => ClassController(), fenix: true);
        }),
      ),
      GetPage(
        name: '/class_list_offline',
        page: () => ClassListOfflineScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ClassOfflineController>(() => ClassOfflineController(), fenix: true);
        }),
      ),
      GetPage(name: '/class_details_offline/:id', page: () => ClassDetailsOfflineScreen()),
      GetPage(
        name: '/assessment_editor/:id',
        page: () => AssessmentEditorScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AssessmentEditorController>(() => AssessmentEditorController());
          Get.lazyPut<AssessmentQuestionController>(() => AssessmentQuestionController());
          Get.lazyPut<AssessmentAvailableAnswerController>(() => AssessmentAvailableAnswerController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(
        name: '/pending_assessments',
        page: () => PendingAssessmentsScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AssessmentPendingController>(() => AssessmentPendingController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isTeacher)],
      ),
      GetPage(
        name: '/concluded_assessments',
        page: () => ConcludedAssessmentsScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AssessmentConcludedController>(() => AssessmentConcludedController());
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isTeacher || auth.isStudent)],
      ),
      GetPage(
        name: '/review_assessment/:id',
        page: () => ReviewAssessmentScreen(),
        binding: BindingsBuilder(() => Get.lazyPut<AssessmentReviewController>(() => AssessmentReviewController(), fenix: true)),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isTeacher || auth.isStudent)],
      ),
      GetPage(
        name: '/class_assessment/:id',
        page: () => ClassAssessmentScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AssessmentController>(() => AssessmentController(), fenix: true);
          Get.lazyPut<AssessmentConcludedController>(() => AssessmentConcludedController(), fenix: true);
        }),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isStudent)],
      ),
      GetPage(
          name: '/certificates',
          page: () => CertificatesScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<CertificateController>(() => CertificateController(), fenix: true);
          })),
      GetPage(
        name: '/assessment_performance',
        page: () => AssessmentPerformanceScreen(),
        binding: BindingsBuilder(() => Get.lazyPut<AssessmentPerformanceController>(() => AssessmentPerformanceController(), fenix: true)),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isTeacher)],
      ),
      GetPage(
        name: '/send_files/:id',
        page: () => SendFilesScreen(),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isStudent)],
      ),
      GetPage(name: '/profile_update', page: () => ProfileUpdateScreen()),
      GetPage(name: '/profile_password_change', page: () => ProfilePasswordChangeScreen()),
      GetPage(
          name: '/about',
          page: () => AboutScreen(),
          binding: BindingsBuilder(() => Get.lazyPut<ConfigurationController>(() => ConfigurationController(), fenix: true))),
      GetPage(
          name: '/help',
          page: () => HelpScreen(),
          binding: BindingsBuilder(() => Get.lazyPut<ConfigurationController>(() => ConfigurationController(), fenix: true))),
      GetPage(
        name: '/report',
        page: () => ReportScreen(),
        binding: BindingsBuilder(
          () => Get.lazyPut<ReportController>(() => ReportController(), fenix: true),
        ),
        middlewares: [RouteMiddleware(accessChecker: (auth) => auth.isAdmin)],
      ),
      GetPage(name: '/preferences', page: () => PreferencesScreen()),
      GetPage(
          name: '/configurations',
          page: () => ConfigurationsScreen(),
          binding: BindingsBuilder(() => Get.lazyPut<ConfigurationController>(() => ConfigurationController(), fenix: true))),
    ];
