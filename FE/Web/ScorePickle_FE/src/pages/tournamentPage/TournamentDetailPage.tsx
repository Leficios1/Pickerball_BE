import {
  CalendarOutlined,
  CopyOutlined,
  LoginOutlined,
  TrophyOutlined,
} from '@ant-design/icons';
import { getPaymentUrl } from '@src/modules/Payment/hooks/useGetPaymentUrl';
import { useCheckJoinTournament } from '@src/modules/Tournament/hooks/useCheckJoinTournament';
import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';
import {
  TouramentregistrationStatus,
  Tournament,
} from '@src/modules/Tournament/models';
import { useCreateRegistration } from '@src/modules/TournamentRegistration/hooks/useCreateRegistration';
import { useGetTournamentTeamRequestByPlayerIdAndTournamentId } from '@src/modules/TournamentRegistration/hooks/useGetTournamentTeamRequestByTournamentAndPlayerId';
import { RootState } from '@src/redux/store';
import { Button, message, Spin, Tabs, Typography } from 'antd';
import 'bootstrap/dist/css/bootstrap.min.css';
import type React from 'react';
import { useState } from 'react';
import { useSelector } from 'react-redux';
import { useParams } from 'react-router-dom';
import Participants from './containers/Participants';
import { RegistrationFormModal } from './containers/RegistrationForm';
import TournamentInfo from './containers/TournamentInfo';
import TournamentMatches from './containers/TournamentMatchPage';
import './tournament-detail.css';
import { motion, AnimatePresence } from 'framer-motion';
import Rank from '@src/components/Rank';
import Donate from '../tournament/containers/Donate';
import { useGetRegistration } from '@src/modules/TournamentRegistration/hooks/useGetTournamenRegistration';

const { Title } = Typography;
const { TabPane } = Tabs;

// Animation variants
const pageVariants = {
  initial: { opacity: 0 },
  animate: {
    opacity: 1,
    transition: { duration: 0.6 },
  },
  exit: { opacity: 0 },
};

const headerVariants = {
  initial: { y: -50, opacity: 0 },
  animate: {
    y: 0,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 100,
      damping: 15,
      delay: 0.2,
    },
  },
};

const metaVariants = {
  initial: { opacity: 0 },
  animate: {
    opacity: 1,
    transition: {
      duration: 0.5,
      delay: 0.4,
      staggerChildren: 0.1,
    },
  },
};

const metaItemVariants = {
  initial: { y: 20, opacity: 0 },
  animate: {
    y: 0,
    opacity: 1,
    transition: { duration: 0.4 },
  },
};

const buttonVariants = {
  initial: { scale: 0.9, opacity: 0 },
  animate: {
    scale: 1,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 200,
      damping: 15,
      delay: 0.6,
    },
  },
  hover: {
    scale: 1.05,
    transition: { duration: 0.2 },
  },
  tap: {
    scale: 0.98,
    transition: { duration: 0.2 },
  },
};

const tabsContainerVariants = {
  initial: { y: 30, opacity: 0 },
  animate: {
    y: 0,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 100,
      damping: 15,
      delay: 0.8,
    },
  },
};

export const TournamentDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const user = useSelector((state: RootState) => state.auth.user);
  const {
    data: tournamentData,
    isLoading,
    error: notFoundTournament,
  } = useGetTournamentById(Number(id || 0));

  const { data: isTeamRegistered } =
    useGetTournamentTeamRequestByPlayerIdAndTournamentId(
      user?.id ?? 0,
      Number(id || 0)
    );
  const { data: isRegistered } = useCheckJoinTournament(
    user?.id ?? 0,
    Number(id || 0)
  );
  const { data: registration } = useGetRegistration(
    user?.id ?? 0,
    Number(id || 0)
  );
  const { mutate: createRegistration } = useCreateRegistration();

  const [isModalVisible, setIsModalVisible] = useState(false);
  const [activeKey, setActiveKey] = useState('details');

  // If data is still loading or there's an error, render appropriate messages
  if (isLoading)
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="d-flex justify-content-center align-items-center"
        style={{ height: '100vh' }}
      >
        <motion.div
          animate={{
            rotate: 360,
            transition: { duration: 1, repeat: Infinity, ease: 'linear' },
          }}
        >
          <Spin size="large" />
        </motion.div>
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="ms-3"
        >
          Loading tournament details...
        </motion.p>
      </motion.div>
    );

  if (notFoundTournament)
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="container mt-5 text-center"
      >
        <motion.h2
          initial={{ y: -20 }}
          animate={{ y: 0 }}
          transition={{ duration: 0.5 }}
        >
          Error loading tournament details
        </motion.h2>
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          The tournament you're looking for could not be found.
        </motion.p>
      </motion.div>
    );

  const tournament: Tournament = tournamentData as Tournament;

  const formatDates = (date: string) => {
    const newDate = new Date(date);

    const options: Intl.DateTimeFormatOptions = {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    };

    const formattedDate = newDate.toLocaleDateString('en-US', options);

    return `${formattedDate}`;
  };

  const handlePayment = async (registrationId) => {
    const userId = user?.id || 0;
    const paymentUrl = await getPaymentUrl(userId, registrationId);
    window.location.href = paymentUrl;
  };

  const handleJoinSingleTournament = async () => {
    const payload = {
      tournamentId: tournament.id,
      playerId: user?.id || 0,
      partnerId: null,
    };
    createRegistration(payload, {
      onSuccess: async (data) => {
        // data.id chính là id mới
        if (data.id) {
          const userId = user?.id ?? 0;
          const paymentUrl = await getPaymentUrl(userId, data.id);
          if (paymentUrl) {
            window.location.href = paymentUrl;
          }
        }
      },
      onError: (error) => {
        message.error(
          'Failed to register for the tournament. Please try again.'
        );
        console.error(error);
      },
    });
  };

  const showButton = () => {
    if (user?.userDetails?.experienceLevel === undefined) {
      return (
        <motion.div
          variants={buttonVariants}
          initial="initial"
          animate="animate"
          whileHover="hover"
          whileTap="tap"
        >
          <Button
            type="primary"
            icon={<LoginOutlined />}
            size="large"
            className="login-now-btn"
            onClick={() => {
              message.info('You have to login to join this tournament');
              window.location.href = '/auth/signin';
            }}
          >
            Login Now
          </Button>
        </motion.div>
      );
    }

    if (!tournament.status.toLowerCase().includes('schedule')) {
      return (
        <motion.div
          variants={buttonVariants}
          initial="initial"
          animate="animate"
        >
          <Button
            type="primary"
            size="large"
            style={{ width: '100%' }}
            disabled={true}
          >
            Closed tournament
          </Button>
        </motion.div>
      );
    }

    if (
      ((user?.userDetails?.experienceLevel ?? 0) >= tournament.isMinRanking &&
        (user?.userDetails?.experienceLevel ?? 0) <= tournament.isMaxRanking &&
        tournament.type
          .toLocaleLowerCase()
          .includes(user?.gender?.toLocaleLowerCase() ?? '')) ||
      tournament.type.toLocaleLowerCase().includes('mix')
    ) {
      if (tournament.type.toLocaleLowerCase().includes('single')) {
        if (isRegistered) {
          if (isRegistered.status === TouramentregistrationStatus.Pending) {
            return (
              <motion.div
                variants={buttonVariants}
                initial="initial"
                animate="animate"
              >
                <Button
                  type="primary"
                  size="large"
                  style={{ width: '100%' }}
                  onClick={() => {
                    if (
                      tournament.registrationDetails.some(
                        (r: { id: number }) => r.id === registration?.id
                      )
                    ) {
                      handlePayment(registration?.id);
                    }
                  }}
                >
                  Pay Registration
                </Button>
              </motion.div>
            );
          }
          if (isRegistered.status === TouramentregistrationStatus.Rejected) {
            return (
              <motion.div
                variants={buttonVariants}
                initial="initial"
                animate="animate"
              >
                <Button
                  type="primary"
                  size="large"
                  disabled={true}
                  style={{ width: '100%' }}
                >
                  Registration Rejected
                </Button>
              </motion.div>
            );
          }
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
            >
              <Button
                type="primary"
                size="large"
                disabled={true}
                style={{ width: '100%' }}
              >
                Registered
              </Button>
            </motion.div>
          );
        } else {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
              whileHover="hover"
              whileTap="tap"
            >
              <Button
                type="primary"
                size="large"
                disabled={
                  !tournament.isAccept ||
                  tournament.registrationDetails.length === tournament.maxPlayer
                }
                onClick={() => {
                  if (
                    tournament.registrationDetails.length < tournament.maxPlayer
                  ) {
                    handleJoinSingleTournament();
                  }
                }}
                style={{ width: '100%' }}
              >
                {tournament.registrationDetails.length < tournament.maxPlayer
                  ? 'Register Now'
                  : 'Full registration'}
              </Button>
            </motion.div>
          );
        }
      }

      if (tournament.type.toLocaleLowerCase().includes('double')) {
        if (isTeamRegistered === undefined) {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
              whileHover="hover"
              whileTap="tap"
            >
              <Button
                type="primary"
                size="large"
                disabled={
                  !tournament.isAccept ||
                  tournament.registrationDetails.length === tournament.maxPlayer
                }
                onClick={() => setIsModalVisible(true)}
                style={{ width: '100%' }}
              >
                {tournament.registrationDetails.length < tournament.maxPlayer
                  ? 'Register Now'
                  : 'Full registration'}
              </Button>
            </motion.div>
          );
        } else if (
          isTeamRegistered?.playerId === user?.id &&
          isTeamRegistered?.isApproved === 1
        ) {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
              whileHover="hover"
              whileTap="tap"
            >
              <Button
                type="primary"
                size="large"
                onClick={() => handlePayment(isTeamRegistered.id)}
                style={{ width: '100%' }}
              >
                Pay Registration Fee
              </Button>
            </motion.div>
          );
        } else if (
          isTeamRegistered?.playerId === user?.id &&
          isTeamRegistered?.isApproved === 2
        ) {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
            >
              <Button
                type="primary"
                size="large"
                disabled={true}
                style={{ width: '100%' }}
              >
                Paid
              </Button>
            </motion.div>
          );
        } else if (
          isTeamRegistered?.partnerId === user?.id &&
          isTeamRegistered?.isApproved === 2
        ) {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
            >
              <Button
                type="primary"
                size="large"
                className="me-3"
                disabled={true}
                style={{ width: '100%' }}
              >
                Paid
              </Button>
            </motion.div>
          );
        } else {
          return (
            <motion.div
              variants={buttonVariants}
              initial="initial"
              animate="animate"
            >
              <Button
                type="primary"
                size="large"
                disabled={true}
                style={{ width: '100%' }}
              >
                Registered
              </Button>
            </motion.div>
          );
        }
      }
    } else {
      return (
        <motion.div
          variants={buttonVariants}
          initial="initial"
          animate="animate"
        >
          <Button
            type="primary"
            size="large"
            style={{
              width: '100%',
              border: '2px solid red',
              color: 'red',
              backgroundColor: 'white',
            }}
            disabled={true}
          >
            You are not eligible to participate in this tournament
          </Button>
        </motion.div>
      );
    }
  };

  return (
    <motion.div
      variants={pageVariants}
      initial="initial"
      animate="animate"
      exit="exit"
    >
      <div className="container mt-4 mb-5">
        <motion.div
          className="tournament-hero-section"
          initial={{ opacity: 0, scale: 1.05 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8 }}
          style={{
            backgroundImage: `url(${tournament.banner})`,
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            color: 'white',
            padding: '40px 24px',
            borderRadius: '16px',
            marginBottom: '30px',
            position: 'relative',
            minHeight: '30vh',
            marginTop: '5vh',
          }}
        >
          <motion.div
            className="banner-overlay"
            initial={{ opacity: 0 }}
            animate={{ opacity: 0.6 }}
            transition={{ duration: 1 }}
          />
        </motion.div>

        {/* Tournament Header */}
        <motion.div
          className="row mb-3 mt-3"
          variants={headerVariants}
          initial="initial"
          animate="animate"
        >
          <div className="col-md-8">
            <div
              className="d-flex align-items-center"
              style={{ fontWeight: 'bold' }}
            >
              <Title level={2} className="mb-0 me-2 text-white">
                {tournament.name}
              </Title>
            </div>

            <motion.div
              className="tournament-meta mt-2 text-white"
              style={{ fontSize: '20px' }}
              variants={metaVariants}
              initial="initial"
              animate="animate"
            >
              <motion.span className="meta-item" variants={metaItemVariants}>
                <CalendarOutlined /> {formatDates(tournament.startDate)} -{' '}
                {formatDates(tournament.endDate)}
              </motion.span>
              <motion.span className="meta-item" variants={metaItemVariants}>
                <CopyOutlined /> {tournament.location}
              </motion.span>
              <motion.span className="meta-item" variants={metaItemVariants}>
                <TrophyOutlined /> {tournament.type}
              </motion.span>
            </motion.div>
          </div>

          <div className="col-md-4 d-flex justify-content-end align-items-start mt-2">
            {showButton()}
          </div>
        </motion.div>

        {/* Navigation Tabs */}
        <motion.div
          className="container_bar"
          variants={tabsContainerVariants}
          initial="initial"
          animate="animate"
        >
          <Tabs
            defaultActiveKey="details"
            className="tournament-tabs"
            activeKey={activeKey}
            onChange={(key) => setActiveKey(key)}
          >
            <TabPane tab="Details" key="details">
              <AnimatePresence mode="wait">
                {activeKey === 'details' && (
                  <motion.div
                    key="details"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                  >
                    <TournamentInfo id={tournament.id} />
                  </motion.div>
                )}
              </AnimatePresence>
            </TabPane>

            <TabPane tab="Schedule" key="schedule">
              <AnimatePresence mode="wait">
                {activeKey === 'schedule' && (
                  <motion.div
                    key="schedule"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                  >
                    <TournamentMatches id={tournament.id} />
                  </motion.div>
                )}
              </AnimatePresence>
            </TabPane>

            <TabPane tab="Participants" key="participants">
              <AnimatePresence mode="wait">
                {activeKey === 'participants' && (
                  <motion.div
                    key="participants"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                  >
                    <Participants
                      registrations={tournament.registrationDetails.filter(
                        (registration) =>
                          [
                            TouramentregistrationStatus.Approved,
                            TouramentregistrationStatus.Eliminated,
                            TouramentregistrationStatus.Winner,
                          ].includes(registration.isApproved)
                      )}
                      tournamentId={tournament.id}
                      refetch={() => {
                        console.log('Refetching tournament data...');
                      }}
                    />
                  </motion.div>
                )}
              </AnimatePresence>
            </TabPane>

            {/* <TabPane tab="Results" key="results">
              <AnimatePresence mode="wait">
                {activeKey === 'results' && (
                  <motion.div
                    key="results"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                  >
                    <Card>
                      <Paragraph>
                        Results information will be displayed here.
                      </Paragraph>
                    </Card>
                  </motion.div>
                )}
              </AnimatePresence>
            </TabPane> */}
            <TabPane tab="Sponsor" key="donate">
              <AnimatePresence mode="wait">
                {activeKey === 'donate' && (
                  <motion.div
                    key="donate"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                  >
                    <Donate tournamentId={tournament.id} />
                  </motion.div>
                )}
              </AnimatePresence>
            </TabPane>
            {tournamentData?.status === 'Completed' && (
              <TabPane tab="Rank" key="rank">
                <AnimatePresence mode="wait">
                  {activeKey === 'rank' && (
                    <motion.div
                      key="rank"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -20 }}
                      transition={{ duration: 0.3 }}
                    >
                      <Rank tournamentId={tournament.id} />
                    </motion.div>
                  )}
                </AnimatePresence>
              </TabPane>
            )}
          </Tabs>
        </motion.div>
      </div>
      {/* Donate Tab */}

      <RegistrationFormModal
        tournamentId={tournament.id}
        visible={isModalVisible}
        onClose={() => setIsModalVisible(false)}
      />
    </motion.div>
  );
};

export default TournamentDetailPage;
