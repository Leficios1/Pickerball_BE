// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:flutter/material.dart' as _i32;
import 'package:pickleball_app/core/constants/app_enums.dart' as _i34;
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart'
    as _i33;
import 'package:pickleball_app/features/authentication/screens/authentication_screen.dart'
    as _i1;
import 'package:pickleball_app/features/authentication/screens/register_role_screen.dart'
    as _i23;
import 'package:pickleball_app/features/home/screens/home_screen.dart' as _i10;
import 'package:pickleball_app/features/match/screens/create_match_screen.dart'
    as _i4;
import 'package:pickleball_app/features/match/screens/detail_match_screen.dart'
    as _i6;
import 'package:pickleball_app/features/match/screens/end_match_page.dart'
    as _i8;
import 'package:pickleball_app/features/matches/screens/matches_screen.dart'
    as _i13;
import 'package:pickleball_app/features/navigation.dart' as _i12;
import 'package:pickleball_app/features/onboarding/screens/onboarding_screen.dart'
    as _i15;
import 'package:pickleball_app/features/onboarding/screens/sponner_pending_screen.dart'
    as _i27;
import 'package:pickleball_app/features/payment/screens/payment_screen.dart'
    as _i16;
import 'package:pickleball_app/features/payment/screens/payment_success_screen.dart'
    as _i17;
import 'package:pickleball_app/features/payment/screens/select_payment_method_screen.dart'
    as _i25;
import 'package:pickleball_app/features/quick_match/screens/quick_match_screen.dart'
    as _i21;
import 'package:pickleball_app/features/ranks/screens/rank_screen.dart' as _i22;
import 'package:pickleball_app/features/setting/screens/pages/blog_categories_page.dart'
    as _i2;
import 'package:pickleball_app/features/setting/screens/pages/contact_us_page.dart'
    as _i3;
import 'package:pickleball_app/features/setting/screens/pages/friend_page.dart'
    as _i9;
import 'package:pickleball_app/features/setting/screens/pages/notification_page.dart'
    as _i14;
import 'package:pickleball_app/features/setting/screens/pages/privacy_policy_page.dart'
    as _i19;
import 'package:pickleball_app/features/setting/screens/pages/profile_page.dart'
    as _i20;
import 'package:pickleball_app/features/setting/screens/pages/rule_detail_page.dart'
    as _i24;
import 'package:pickleball_app/features/setting/screens/pages/terms_of_service_page.dart'
    as _i28;
import 'package:pickleball_app/features/setting/screens/pages/user_profile_page.dart'
    as _i30;
import 'package:pickleball_app/features/setting/screens/setting_screen.dart'
    as _i26;
import 'package:pickleball_app/features/tournament_manage/screens/pages/create_tournament_page.dart'
    as _i5;
import 'package:pickleball_app/features/tournament_manage/screens/pages/detail_tournament_page.dart'
    as _i7;
import 'package:pickleball_app/features/tournament_manage/screens/pages/join_tournament_page.dart'
    as _i11;
import 'package:pickleball_app/features/tournament_manage/screens/pages/policy_tournament_page.dart'
    as _i18;
import 'package:pickleball_app/features/tournament_manage/screens/tournament_manage_screen.dart'
    as _i29;

/// generated route for
/// [_i1.AuthenticationScreen]
class AuthenticationRoute extends _i31.PageRouteInfo<void> {
  const AuthenticationRoute({List<_i31.PageRouteInfo>? children})
    : super(AuthenticationRoute.name, initialChildren: children);

  static const String name = 'AuthenticationRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthenticationScreen();
    },
  );
}

/// generated route for
/// [_i2.BlogCategoriesPage]
class BlogCategoriesRoute extends _i31.PageRouteInfo<void> {
  const BlogCategoriesRoute({List<_i31.PageRouteInfo>? children})
    : super(BlogCategoriesRoute.name, initialChildren: children);

  static const String name = 'BlogCategoriesRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i2.BlogCategoriesPage();
    },
  );
}

/// generated route for
/// [_i3.ContactUsPage]
class ContactUsRoute extends _i31.PageRouteInfo<void> {
  const ContactUsRoute({List<_i31.PageRouteInfo>? children})
    : super(ContactUsRoute.name, initialChildren: children);

  static const String name = 'ContactUsRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i3.ContactUsPage();
    },
  );
}

/// generated route for
/// [_i4.CreateMatchScreen]
class CreateMatchRoute extends _i31.PageRouteInfo<CreateMatchRouteArgs> {
  CreateMatchRoute({
    _i32.Key? key,
    required int type,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         CreateMatchRoute.name,
         args: CreateMatchRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'CreateMatchRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateMatchRouteArgs>();
      return _i4.CreateMatchScreen(key: args.key, type: args.type);
    },
  );
}

class CreateMatchRouteArgs {
  const CreateMatchRouteArgs({this.key, required this.type});

  final _i32.Key? key;

  final int type;

  @override
  String toString() {
    return 'CreateMatchRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [_i5.CreateTournamentPage]
class CreateTournamentRoute extends _i31.PageRouteInfo<void> {
  const CreateTournamentRoute({List<_i31.PageRouteInfo>? children})
    : super(CreateTournamentRoute.name, initialChildren: children);

  static const String name = 'CreateTournamentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i5.CreateTournamentPage();
    },
  );
}

/// generated route for
/// [_i6.DetailMatchScreen]
class DetailMatchRoute extends _i31.PageRouteInfo<void> {
  const DetailMatchRoute({List<_i31.PageRouteInfo>? children})
    : super(DetailMatchRoute.name, initialChildren: children);

  static const String name = 'DetailMatchRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i6.DetailMatchScreen();
    },
  );
}

/// generated route for
/// [_i7.DetailTournamentPage]
class DetailTournamentRoute extends _i31.PageRouteInfo<void> {
  const DetailTournamentRoute({List<_i31.PageRouteInfo>? children})
    : super(DetailTournamentRoute.name, initialChildren: children);

  static const String name = 'DetailTournamentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i7.DetailTournamentPage();
    },
  );
}

/// generated route for
/// [_i8.EndMatchPage]
class EndMatchRoute extends _i31.PageRouteInfo<EndMatchRouteArgs> {
  EndMatchRoute({
    _i32.Key? key,
    required int team1Score,
    required int team2Score,
    required int matchId,
    required String title,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         EndMatchRoute.name,
         args: EndMatchRouteArgs(
           key: key,
           team1Score: team1Score,
           team2Score: team2Score,
           matchId: matchId,
           title: title,
         ),
         initialChildren: children,
       );

  static const String name = 'EndMatchRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EndMatchRouteArgs>();
      return _i8.EndMatchPage(
        key: args.key,
        team1Score: args.team1Score,
        team2Score: args.team2Score,
        matchId: args.matchId,
        title: args.title,
      );
    },
  );
}

class EndMatchRouteArgs {
  const EndMatchRouteArgs({
    this.key,
    required this.team1Score,
    required this.team2Score,
    required this.matchId,
    required this.title,
  });

  final _i32.Key? key;

  final int team1Score;

  final int team2Score;

  final int matchId;

  final String title;

  @override
  String toString() {
    return 'EndMatchRouteArgs{key: $key, team1Score: $team1Score, team2Score: $team2Score, matchId: $matchId, title: $title}';
  }
}

/// generated route for
/// [_i9.FriendPage]
class FriendRoute extends _i31.PageRouteInfo<void> {
  const FriendRoute({List<_i31.PageRouteInfo>? children})
    : super(FriendRoute.name, initialChildren: children);

  static const String name = 'FriendRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i9.FriendPage();
    },
  );
}

/// generated route for
/// [_i10.HomeScreen]
class HomeRoute extends _i31.PageRouteInfo<void> {
  const HomeRoute({List<_i31.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i10.HomeScreen();
    },
  );
}

/// generated route for
/// [_i11.JoinTournamentPage]
class JoinTournamentRoute extends _i31.PageRouteInfo<void> {
  const JoinTournamentRoute({List<_i31.PageRouteInfo>? children})
    : super(JoinTournamentRoute.name, initialChildren: children);

  static const String name = 'JoinTournamentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i11.JoinTournamentPage();
    },
  );
}

/// generated route for
/// [_i12.MainNavigation]
class MainNavigation extends _i31.PageRouteInfo<void> {
  const MainNavigation({List<_i31.PageRouteInfo>? children})
    : super(MainNavigation.name, initialChildren: children);

  static const String name = 'MainNavigation';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i12.MainNavigation();
    },
  );
}

/// generated route for
/// [_i13.MatchesScreen]
class MatchesRoute extends _i31.PageRouteInfo<void> {
  const MatchesRoute({List<_i31.PageRouteInfo>? children})
    : super(MatchesRoute.name, initialChildren: children);

  static const String name = 'MatchesRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i13.MatchesScreen();
    },
  );
}

/// generated route for
/// [_i14.NotificationPage]
class NotificationRoute extends _i31.PageRouteInfo<void> {
  const NotificationRoute({List<_i31.PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i14.NotificationPage();
    },
  );
}

/// generated route for
/// [_i15.OnboardingScreen]
class OnboardingRoute extends _i31.PageRouteInfo<void> {
  const OnboardingRoute({List<_i31.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i15.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i16.PaymentScreen]
class PaymentRoute extends _i31.PageRouteInfo<void> {
  const PaymentRoute({List<_i31.PageRouteInfo>? children})
    : super(PaymentRoute.name, initialChildren: children);

  static const String name = 'PaymentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i16.PaymentScreen();
    },
  );
}

/// generated route for
/// [_i17.PaymentSuccessScreen]
class PaymentSuccessRoute extends _i31.PageRouteInfo<void> {
  const PaymentSuccessRoute({List<_i31.PageRouteInfo>? children})
    : super(PaymentSuccessRoute.name, initialChildren: children);

  static const String name = 'PaymentSuccessRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i17.PaymentSuccessScreen();
    },
  );
}

/// generated route for
/// [_i18.PolicyTournamentPage]
class PolicyTournamentRoute
    extends _i31.PageRouteInfo<PolicyTournamentRouteArgs> {
  PolicyTournamentRoute({
    _i32.Key? key,
    required _i33.CreateTournamentRequest createTournamentRequest,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         PolicyTournamentRoute.name,
         args: PolicyTournamentRouteArgs(
           key: key,
           createTournamentRequest: createTournamentRequest,
         ),
         initialChildren: children,
       );

  static const String name = 'PolicyTournamentRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PolicyTournamentRouteArgs>();
      return _i18.PolicyTournamentPage(
        key: args.key,
        createTournamentRequest: args.createTournamentRequest,
      );
    },
  );
}

class PolicyTournamentRouteArgs {
  const PolicyTournamentRouteArgs({
    this.key,
    required this.createTournamentRequest,
  });

  final _i32.Key? key;

  final _i33.CreateTournamentRequest createTournamentRequest;

  @override
  String toString() {
    return 'PolicyTournamentRouteArgs{key: $key, createTournamentRequest: $createTournamentRequest}';
  }
}

/// generated route for
/// [_i19.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i31.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i31.PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i19.PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [_i20.ProfilePage]
class ProfileRoute extends _i31.PageRouteInfo<void> {
  const ProfileRoute({List<_i31.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i20.ProfilePage();
    },
  );
}

/// generated route for
/// [_i21.QuickMatchScreen]
class QuickMatchRoute extends _i31.PageRouteInfo<void> {
  const QuickMatchRoute({List<_i31.PageRouteInfo>? children})
    : super(QuickMatchRoute.name, initialChildren: children);

  static const String name = 'QuickMatchRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i21.QuickMatchScreen();
    },
  );
}

/// generated route for
/// [_i22.RankScreen]
class RankRoute extends _i31.PageRouteInfo<void> {
  const RankRoute({List<_i31.PageRouteInfo>? children})
    : super(RankRoute.name, initialChildren: children);

  static const String name = 'RankRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i22.RankScreen();
    },
  );
}

/// generated route for
/// [_i23.RegisterRoleScreen]
class RegisterRoleRoute extends _i31.PageRouteInfo<void> {
  const RegisterRoleRoute({List<_i31.PageRouteInfo>? children})
    : super(RegisterRoleRoute.name, initialChildren: children);

  static const String name = 'RegisterRoleRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i23.RegisterRoleScreen();
    },
  );
}

/// generated route for
/// [_i24.RuleDetailPage]
class RuleDetailRoute extends _i31.PageRouteInfo<void> {
  const RuleDetailRoute({List<_i31.PageRouteInfo>? children})
    : super(RuleDetailRoute.name, initialChildren: children);

  static const String name = 'RuleDetailRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i24.RuleDetailPage();
    },
  );
}

/// generated route for
/// [_i25.SelectPaymentMethodScreen]
class SelectPaymentMethodRoute
    extends _i31.PageRouteInfo<SelectPaymentMethodRouteArgs> {
  SelectPaymentMethodRoute({
    _i32.Key? key,
    int? amount,
    int? registrationId,
    int? tournamentId,
    required dynamic Function(_i34.PaymentMethod) onPaymentSelected,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         SelectPaymentMethodRoute.name,
         args: SelectPaymentMethodRouteArgs(
           key: key,
           amount: amount,
           registrationId: registrationId,
           tournamentId: tournamentId,
           onPaymentSelected: onPaymentSelected,
         ),
         initialChildren: children,
       );

  static const String name = 'SelectPaymentMethodRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectPaymentMethodRouteArgs>();
      return _i25.SelectPaymentMethodScreen(
        key: args.key,
        amount: args.amount,
        registrationId: args.registrationId,
        tournamentId: args.tournamentId,
        onPaymentSelected: args.onPaymentSelected,
      );
    },
  );
}

class SelectPaymentMethodRouteArgs {
  const SelectPaymentMethodRouteArgs({
    this.key,
    this.amount,
    this.registrationId,
    this.tournamentId,
    required this.onPaymentSelected,
  });

  final _i32.Key? key;

  final int? amount;

  final int? registrationId;

  final int? tournamentId;

  final dynamic Function(_i34.PaymentMethod) onPaymentSelected;

  @override
  String toString() {
    return 'SelectPaymentMethodRouteArgs{key: $key, amount: $amount, registrationId: $registrationId, tournamentId: $tournamentId, onPaymentSelected: $onPaymentSelected}';
  }
}

/// generated route for
/// [_i26.SettingScreen]
class SettingRoute extends _i31.PageRouteInfo<void> {
  const SettingRoute({List<_i31.PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i26.SettingScreen();
    },
  );
}

/// generated route for
/// [_i27.SponnerPendingScreen]
class SponnerPendingRoute extends _i31.PageRouteInfo<void> {
  const SponnerPendingRoute({List<_i31.PageRouteInfo>? children})
    : super(SponnerPendingRoute.name, initialChildren: children);

  static const String name = 'SponnerPendingRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i27.SponnerPendingScreen();
    },
  );
}

/// generated route for
/// [_i28.TermsOfServicePage]
class TermsOfServiceRoute extends _i31.PageRouteInfo<void> {
  const TermsOfServiceRoute({List<_i31.PageRouteInfo>? children})
    : super(TermsOfServiceRoute.name, initialChildren: children);

  static const String name = 'TermsOfServiceRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i28.TermsOfServicePage();
    },
  );
}

/// generated route for
/// [_i29.TournamentManageScreen]
class TournamentManageRoute extends _i31.PageRouteInfo<void> {
  const TournamentManageRoute({List<_i31.PageRouteInfo>? children})
    : super(TournamentManageRoute.name, initialChildren: children);

  static const String name = 'TournamentManageRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i29.TournamentManageScreen();
    },
  );
}

/// generated route for
/// [_i30.UserProfilePage]
class UserProfileRoute extends _i31.PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    _i32.Key? key,
    required int userId,
    List<_i31.PageRouteInfo>? children,
  }) : super(
         UserProfileRoute.name,
         args: UserProfileRouteArgs(key: key, userId: userId),
         rawPathParams: {'userId': userId},
         initialChildren: children,
       );

  static const String name = 'UserProfileRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserProfileRouteArgs>(
        orElse: () => UserProfileRouteArgs(userId: pathParams.getInt('userId')),
      );
      return _i30.UserProfilePage(key: args.key, userId: args.userId);
    },
  );
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final int userId;

  @override
  String toString() {
    return 'UserProfileRouteArgs{key: $key, userId: $userId}';
  }
}
