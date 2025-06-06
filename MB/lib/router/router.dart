import 'package:auto_route/auto_route.dart';
import 'package:pickleball_app/core/constants/router_path.dart';
import 'package:pickleball_app/features/payment/screens/select_payment_method_screen.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'package:pickleball_app/features/quick_match/screens/quick_match_screen.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: OnboardingRoute.page,
          initial: true,
          path: RouterPath.onboarding,
          guards: [],
        ),
        CustomRoute(
            page: MainNavigation.page,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            durationInMilliseconds: 400,
            path: RouterPath.mainNavigation,
            children: [
              AutoRoute(page: HomeRoute.page, path: RouterPath.homeScreen),
              AutoRoute(page: RankRoute.page, path: RouterPath.rankScreen),
              AutoRoute(
                  page: MatchesRoute.page, path: RouterPath.tournamentScreen),
              AutoRoute(
                  page: TournamentManageRoute.page,
                  path: RouterPath.tournamentManageScreen),
              AutoRoute(
                  page: SettingRoute.page, path: RouterPath.settingScreen),
            ]),
        AutoRoute(
            page: AuthenticationRoute.page,
            path: RouterPath.authenticationScreen),
        AutoRoute(page: ContactUsRoute.page, path: RouterPath.contactUsPage),
        AutoRoute(page: ProfileRoute.page, path: RouterPath.profilePage),
        AutoRoute(
            page: BlogCategoriesRoute.page, path: RouterPath.blogCategory),
        AutoRoute(page: RuleDetailRoute.page, path: RouterPath.blogRuleDetail),
        AutoRoute(page: FriendRoute.page, path: RouterPath.friendPage),
        AutoRoute(
            page: PrivacyPolicyRoute.page, path: RouterPath.privacyPolicyPage),
        AutoRoute(
            page: TermsOfServiceRoute.page, path: RouterPath.termsOfService),
        AutoRoute(
            page: NotificationRoute.page, path: RouterPath.notificationPage),
        AutoRoute(
            page: RegisterRoleRoute.page, path: RouterPath.registerRolePage),
        AutoRoute(
            page: DetailMatchRoute.page, path: RouterPath.matchDetailScreen),
        AutoRoute(
            page: CreateMatchRoute.page, path: RouterPath.createMatchScreen),
        AutoRoute(
            page: QuickMatchRoute.page, path: '/quick-match-screen'),
        AutoRoute(
            page: SponnerPendingRoute.page,
            path: RouterPath.tournamentPendingScreen),
        AutoRoute(
            page: DetailTournamentRoute.page,
            path: RouterPath.tournamentDetailPage),
        AutoRoute(
            page: CreateTournamentRoute.page,
            path: RouterPath.tournamentCreatePage),
        AutoRoute(
            page: PolicyTournamentRoute.page,
            path: RouterPath.tournamentPolicyPage),
        AutoRoute(
            page: JoinTournamentRoute.page,
            path: RouterPath.tournamentJoinPage),
        AutoRoute(page: PaymentRoute.page, path: RouterPath.paymentPage),
        AutoRoute(
            page: PaymentSuccessRoute.page,
            path: RouterPath.paymentSuccessPage),
        AutoRoute(page: EndMatchRoute.page, path: RouterPath.endMatchPage),
        AutoRoute(page: SelectPaymentMethodRoute.page, path: RouterPath.selectPaymentMethod),
        AutoRoute(page: UserProfileRoute.page, path: '/user-profile/:userId'),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
