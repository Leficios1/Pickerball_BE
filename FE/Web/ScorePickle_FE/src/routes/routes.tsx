import { createBrowserRouter, useLocation } from 'react-router-dom';
import {
  AccountDeactivePage,
  BiddingDashboardPage,
  CorporateAboutPage,
  CorporateContactPage,
  CorporateFaqPage,
  CorporateLicensePage,
  CorporatePricingPage,
  CorporateTeamPage,
  DefaultDashboardPage,
  EcommerceDashboardPage,
  Error400Page,
  Error403Page,
  Error404Page,
  Error500Page,
  Error503Page,
  ErrorPage,
  HomePage,
  MarketingDashboardPage,
  PasswordResetPage,
  ProjectsDashboardPage,
  SignInPage,
  SignUpPage,
  SitemapPage,
  SocialDashboardPage,
  UserProfileActionsPage,
  UserProfileActivityPage,
  UserProfileDetailsPage,
  UserProfileFeedbackPage,
  UserProfileHelpPage,
  UserProfileInformationPage,
  UserProfilePreferencesPage,
  UserProfileSecurityPage,
  VerifyEmailPage,
  WelcomePage,
  LearningDashboardPage,
  LogisticsDashboardPage,
  // Import the OverviewPage component, New Page
  OverviewPage,
  // Import the user management component
  RefereePage,
  UserPage,
  SponsorPage,
  PlayerPage,
  OrganizerPage,
  StaffPage,
  // Import the (player view)
  TournamentPage,
  RulePage,
  ContentPage,
  // Admin pages
  PaymentAdmin,
  // Sponsor pages
  PaymentSponsor,
  OverviewAdminPage,
  VenueAdminPage,
  RefereesAdminPage,
  RegisterEmail,
} from '../pages';
import {
  CorporateLayout,
  DashboardLayout,
  GuestLayout,
  UserAccountLayout,
} from '../layouts';
import React, { ReactNode, useEffect } from 'react';
import { AboutPage } from '../pages/About.tsx';
import { TournamentLayout } from '@src/layouts/tournament/index.tsx';
import { ContentLayout } from '@src/layouts/content/index.tsx';
import { UserLayout } from '@src/layouts/user/index.tsx';
import { PaymentAdminLayout } from '@src/layouts/payment/index.admin.tsx';
import { TournamentAdminLayout } from '@src/layouts/tournament/index.admin.tsx';
import { UserAdminLayout } from '@src/layouts/user/index.admin.tsx';
import ManageSponsor from '@src/pages/user/ManageSponsor.tsx';
import BlockUser from '@src/pages/user/BlockUser.tsx';
import TournamentDetailPage from '@src/pages/tournamentPage/TournamentDetailPage.tsx';
import MatchCalendar from '@src/pages/tournamentPage/MatchCalendar.tsx';
import { PaymentLayout } from '@src/layouts/payment/index.tsx';
import PaymentReturn from '@src/pages/tournamentPage/PaymentReturn.tsx';
import { TournamentPlayerPage } from '@src/pages/tournamentPage/TournamentPlayerPage.tsx';
import EditProfile from '@src/pages/profilePage/ProfilePage.tsx';
import { PlayersPage } from '@src/pages/playerPage/PlayerPage.tsx';
import FriendPage from '@src/pages/friend/FriendPage.tsx';
import UpdatePassword from '@src/pages/authentication/UpdatePassword.tsx';
import AddMatches from '@src/pages/matchPage/AddMatch.tsx';
import HomePagee from '@src/pages/Homee.tsx';
import MyProfile from '@src/pages/profilePage/MyProfile.tsx';
import PlayerMatchesPage from '@src/pages/matchPage/PlayerMatches.tsx';
import MatchDetail from '@src/pages/matchPage/MatchDetail.tsx';
import MatchesPage from '@src/pages/matchPage/MatchPage.tsx';
import MatchDetailToJoin from '@src/pages/matchPage/components/MatchDetailToJoin.tsx';
import Transaction from '@src/pages/transaction/index.tsx';
import Announcement from '@src/pages/announcement/index.tsx';
import { VenuePage } from '@src/pages/tournament/VenusPage.tsx';
import RefereesPage from '@src/pages/tournament/RefereesPage.tsx';
import { RefereeLayout } from '@src/layouts/referee/index.tsx';
import RefereeDashboard from '@src/pages/referee/RefereeDashboard.tsx';
import RefereeDetail from '@src/pages/referee/RefereeDetail.tsx';
import SponsorProfile from '@src/pages/sponsor/SponsorProfile.tsx';
import SponsorPassword from '@src/pages/sponsor/SponsorPassword.tsx';
import TournamentList from '@src/pages/tournament/TournamentList.tsx';
import SponsorshipReturn from '@src/pages/tournament/SponsorshipReturn.tsx';
import { useSelector } from 'react-redux';
import CompetitiveLayout from '@src/layouts/competitive/index.tsx';
import { RootState } from '@src/redux/store.ts';
import RankingPage from '@src/pages/rankingPage/RankingPage.tsx';
import { VerifyOtp } from '@src/pages/authentication/VerifyOtp.tsx';
import { SelectRole } from '@src/pages/authentication/SelectRole.tsx';
import SponsorForm from '@src/pages/authentication/SponsorForm.tsx';
import PlayerForm from '@src/pages/authentication/PlayerForm.tsx';
import TournamentDetail from '@src/pages/tournament/DetailPage.tsx';

// Custom scroll restoration function
export const ScrollToTop: React.FC = () => {
  const { pathname } = useLocation();

  useEffect(() => {
    window.scrollTo({
      top: 0,
      left: 0,
      behavior: 'smooth',
    }); // Scroll to the top when the location changes
  }, [pathname]);

  return null; // This component doesn't render anything
};

type PageProps = {
  children: ReactNode;
};

// Create an HOC to wrap your route components with ScrollToTop
const PageWrapper = ({ children }: PageProps) => {
  const user = useSelector((state: RootState) => state.auth?.user);

  // Only show the competitive matchmaking component if user is logged in and is a player (roleId === 1)
  const showCompetitive = !!user?.id && user?.roleId === 1;

  return (
    <>
      <ScrollToTop />
      {children}
      {showCompetitive && (
        <CompetitiveLayout
          userId={user.id}
          gender={user.gender || 'unknown'}
          city={user.userDetails?.city || 'unknown'}
          ranking={user.userDetails?.experienceLevel || 1}
        />
      )}
    </>
  );
};

// Create the router
const router = createBrowserRouter([
  {
    path: '/',
    element: <PageWrapper children={<GuestLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: '',
        element: <HomePage />,
      },
      {
        index: true,
        path: 'tournament-page',
        element: <TournamentPage />,
      },
      {
        index: true,
        path: 'ranking-page',
        element: <RankingPage />,
      },
      {
        index: true,
        path: 'rule-page',
        element: <RulePage />,
      },
      {
        index: true,
        path: 'tournament-detail/:id',
        element: <TournamentDetailPage />,
      },
      {
        index: true,
        path: 'match-calendar',
        element: <MatchCalendar />,
      },
      {
        index: true,
        path: 'payment-return',
        element: <PaymentReturn />,
      },
      {
        index: true,
        path: 'my-tournament',
        element: <TournamentPlayerPage />,
      },
      {
        index: true,
        path: 'edit-profile',
        element: <EditProfile />,
      },
      {
        index: true,
        path: 'player-page',
        element: <PlayersPage />,
      },
      {
        index: true,
        path: 'my-friend',
        element: <FriendPage />,
      },
      {
        index: true,
        path: 'update-password',
        element: <UpdatePassword />,
      },
      {
        index: true,
        path: 'add-match',
        element: <AddMatches />,
      },
      {
        index: true,
        path: 'home',
        element: <HomePagee />,
      },
      {
        index: true,
        path: 'profile/:id',
        element: <MyProfile />,
      },
      {
        index: true,
        path: 'my-matches',
        element: <PlayerMatchesPage />,
      },
      {
        index: true,
        path: 'match-detail/:id',
        element: <MatchDetail />,
      },
      {
        index: true,
        path: 'match-page',
        element: <MatchesPage />,
      },
      {
        index: true,
        path: 'join-match/:id',
        element: <MatchDetailToJoin />,
      },
      {
        index: true,
        path: 'transaction',
        element: <Transaction />,
      },
      {
        index: true,
        path: 'announcement',
        element: <Announcement />,
      },
    ],
  },
  {
    path: '/sponsor',
    element: <PageWrapper children={<PaymentLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'payment',
        element: <PaymentSponsor />,
      },
      {
        index: true,
        path: 'profile',
        element: <SponsorProfile />,
      },
      {
        index: true,
        path: 'update-password',
        element: <SponsorPassword />,
      },
      {
        index: true,
        path: 'sponsorship-return',
        element: <SponsorshipReturn />,
      },
    ],
  },
  {
    path: '/admin/',
    element: <PageWrapper children={<PaymentAdminLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <PaymentAdmin />,
      },
    ],
  },
  {
    path: '/admin/payment',
    element: <PageWrapper children={<PaymentAdminLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <PaymentAdmin />,
      },
    ],
  },
  {
    path: '/admin/tournament',
    element: <PageWrapper children={<TournamentAdminLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'overview',
        element: <OverviewAdminPage />,
      },
      {
        index: true,
        path: 'venues',
        element: <VenueAdminPage />,
      },
      {
        index: true,
        path: 'referees',
        element: <RefereesAdminPage />,
      },
      {
        index: true,
        path: ':id',
        element: <TournamentDetail />,
      },
    ],
  },
  {
    path: '/user',
    element: <PageWrapper children={<UserAdminLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'manage-sponsor',
        element: <ManageSponsor />,
      },
      {
        index: true,
        path: 'block-user',
        element: <BlockUser />,
      },
    ],
  },
  {
    path: '/referee',
    element: <PageWrapper children={<RefereeLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'dashboard',
        element: <RefereeDashboard />,
      },
      {
        path: ':id',
        element: <RefereeDetail />,
      },
    ],
  },
  {
    path: '/content',
    element: <PageWrapper children={<ContentLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <ContentPage />,
      },
    ],
  },
  {
    path: '/tournament',
    element: <PageWrapper children={<TournamentLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'list',
        element: <TournamentList />,
      },
      {
        index: true,
        path: 'overview',
        element: <OverviewPage />,
      },
      {
        path: ':id',
        element: <TournamentDetail />,
      },
      {
        path: 'venues',
        element: <VenuePage />,
      },
      {
        path: 'referees',
        element: <RefereesPage />,
      },
    ],
  },
  {
    path: '/user',
    element: <PageWrapper children={<UserLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'referees',
        element: <RefereePage />,
      },
      {
        index: true,
        path: 'users',
        element: <UserPage />,
      },
      {
        index: true,
        path: 'sponsors',
        element: <SponsorPage />,
      },
      {
        index: true,
        path: 'players',
        element: <PlayerPage />,
      },
      {
        index: true,
        path: 'organizers',
        element: <OrganizerPage />,
      },
      {
        index: true,
        path: 'staffs',
        element: <StaffPage />,
      },
    ],
  },
  {
    path: '/dashboards',
    element: <PageWrapper children={<DashboardLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'default',
        element: <DefaultDashboardPage />,
      },
      {
        path: 'projects',
        element: <ProjectsDashboardPage />,
      },
      {
        path: 'ecommerce',
        element: <EcommerceDashboardPage />,
      },
      {
        path: 'marketing',
        element: <MarketingDashboardPage />,
      },
      {
        path: 'social',
        element: <SocialDashboardPage />,
      },
      {
        path: 'bidding',
        element: <BiddingDashboardPage />,
      },
      {
        path: 'learning',
        element: <LearningDashboardPage />,
      },
      {
        path: 'logistics',
        element: <LogisticsDashboardPage />,
      },
      {
        path: 'admin',
        element: <PaymentAdmin />,
      },
      {
        path: 'sponsor',
        element: <PaymentSponsor />,
      },
    ],
  },
  {
    path: '/sitemap',
    element: <PageWrapper children={<DashboardLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: '',
        element: <SitemapPage />,
      },
    ],
  },
  {
    path: '/corporate',
    element: <PageWrapper children={<CorporateLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'about',
        element: <CorporateAboutPage />,
      },
      {
        path: 'team',
        element: <CorporateTeamPage />,
      },
      {
        path: 'faqs',
        element: <CorporateFaqPage />,
      },
      {
        path: 'contact',
        element: <CorporateContactPage />,
      },
      {
        path: 'pricing',
        element: <CorporatePricingPage />,
      },
      {
        path: 'license',
        element: <CorporateLicensePage />,
      },
    ],
  },
  {
    path: '/user-profile',
    element: <PageWrapper children={<UserAccountLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: 'details',
        element: <UserProfileDetailsPage />,
      },
      {
        path: 'preferences',
        element: <UserProfilePreferencesPage />,
      },
      {
        path: 'information',
        element: <UserProfileInformationPage />,
      },
      {
        path: 'security',
        element: <UserProfileSecurityPage />,
      },
      {
        path: 'activity',
        element: <UserProfileActivityPage />,
      },
      {
        path: 'actions',
        element: <UserProfileActionsPage />,
      },
      {
        path: 'help',
        element: <UserProfileHelpPage />,
      },
      {
        path: 'feedback',
        element: <UserProfileFeedbackPage />,
      },
    ],
  },
  {
    path: '/auth',
    errorElement: <ErrorPage />,
    children: [
      {
        path: 'signup',
        element: <SignUpPage />,
      },
      {
        path: 'signin',
        element: <SignInPage />,
      },
      {
        path: 'welcome',
        element: <WelcomePage />,
      },
      {
        path: 'verify-email',
        element: <VerifyEmailPage />,
      },
      {
        path: 'password-reset',
        element: <PasswordResetPage />,
      },
      {
        path: 'account-delete',
        element: <AccountDeactivePage />,
      },
      {
        path: 'register-account',
        element: <RegisterEmail />,
      },
      {
        path: 'verify-otp',
        element: <VerifyOtp />,
      },
      {
        path: 'select-role',
        element: <SelectRole />,
      },
      {
        path: 'sponsor-form',
        element: <SponsorForm />,
      },
      {
        path: 'player-form',
        element: <PlayerForm />,
      },
    ],
  },
  {
    path: 'errors',
    errorElement: <ErrorPage />,
    children: [
      {
        path: '400',
        element: <Error400Page />,
      },
      {
        path: '403',
        element: <Error403Page />,
      },
      {
        path: '404',
        element: <Error404Page />,
      },
      {
        path: '500',
        element: <Error500Page />,
      },
      {
        path: '503',
        element: <Error503Page />,
      },
    ],
  },
  {
    path: '/about',
    element: <PageWrapper children={<DashboardLayout />} />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        path: '',
        element: <AboutPage />,
      },
    ],
  },
]);

export default router;
