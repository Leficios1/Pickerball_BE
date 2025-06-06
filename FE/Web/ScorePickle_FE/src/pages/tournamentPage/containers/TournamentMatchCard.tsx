import {
  CalendarOutlined,
  RightOutlined,
  TrophyOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  MatchFormat,
  MatchStatus,
  TournamentMatch,
} from '@src/modules/Match/models';
import { Avatar, Badge, Button, Typography } from 'antd';
import 'bootstrap/dist/css/bootstrap.min.css';
import { motion } from 'framer-motion';
import './tournament-match-card.css';
import { useNavigate } from 'react-router-dom';

const { Text, Title } = Typography;

interface TournamentMatchCardProps {
  value: TournamentMatch;
}

export default function TournamentMatchCard({
  value,
}: TournamentMatchCardProps) {
  const navigate = useNavigate();
  // Safe defaults for team responses
  const teams = value.teamResponse ?? [];
  const teamA = teams[0] ?? { members: [] };
  const teamB = teams[1] ?? { members: [] };

  // Animation variants
  const cardVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        type: 'spring',
        stiffness: 100,
        damping: 15,
        when: 'beforeChildren',
        staggerChildren: 0.1,
      },
    },
    hover: {
      y: -5,
      boxShadow: '0px 10px 20px rgba(13, 110, 253, 0.15)',
      transition: {
        type: 'spring',
        stiffness: 300,
        damping: 15,
      },
    },
  };

  const contentVariants = {
    hidden: { opacity: 0, y: 10 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.4 },
    },
  };

  const playerVariants = {
    hidden: { opacity: 0, scale: 0.8 },
    visible: {
      opacity: 1,
      scale: 1,
      transition: {
        type: 'spring',
        stiffness: 200,
        damping: 10,
      },
    },
    hover: {
      y: -5,
      transition: {
        type: 'spring',
        stiffness: 300,
        damping: 10,
      },
    },
  };

  const buttonVariants = {
    hidden: { opacity: 0, scale: 0.9 },
    visible: {
      opacity: 1,
      scale: 1,
      transition: {
        delay: 0.3,
        type: 'spring',
        stiffness: 300,
        damping: 10,
      },
    },
    hover: {
      scale: 1.05,
      backgroundColor: '#0a58ca',
      transition: { duration: 0.2 },
    },
    tap: {
      scale: 0.98,
      transition: { duration: 0.1 },
    },
  };

  const vsVariants = {
    initial: { scale: 0.8, opacity: 0 },
    animate: {
      scale: 1,
      opacity: 1,
      transition: {
        type: 'spring',
        stiffness: 300,
        damping: 10,
        delay: 0.2,
      },
    },
    hover: {
      scale: 1.2,
      color: '#0d6efd',
      transition: { duration: 0.3 },
    },
  };

  // Format date for better display
  const formatMatchDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      weekday: 'short',
      day: 'numeric',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  // Get status color based on match status
  const getStatusColor = (status) => {
    switch (status) {
      case 'Upcoming':
        return '#1890ff';
      case 'Live':
        return '#52c41a';
      case 'Completed':
        return '#722ed1';
      case 'Canceled':
        return '#f5222d';
      default:
        return '#1890ff';
    }
  };

  // Render up to first two players per team
  const renderPlayers = (team: {
    members: Array<{ id: number; playerId: number }>;
  }) =>
    team.members.slice(0, 2).map((member) => (
      <motion.div
        key={member.id}
        className="d-flex flex-column align-items-center mx-2"
        variants={playerVariants}
        whileHover="hover"
      >
        <Avatar
          src="https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg"
          size={70}
          className="player-avatar"
        />
        <Text strong className="mt-2 player-name">
          Player {member.playerId}
        </Text>
      </motion.div>
    ));

  return (
    <motion.div
      className="match-card border-0 rounded-4 mb-4 bg-white"
      style={{
        border: '1px solid rgba(13, 110, 253, 0.3)',
        padding: '20px',
        borderRadius: '16px',
        boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
      }}
      variants={cardVariants}
      initial="hidden"
      animate="visible"
      whileHover="hover"
    >
      <motion.div
        className="d-flex justify-content-between align-items-start mb-3"
        variants={contentVariants}
      >
        <div className="d-flex align-items-center">
          <CalendarOutlined
            className="me-2 text-primary"
            style={{ fontSize: '16px' }}
          />
          <Text className="text-secondary me-5 date-text">
            {formatMatchDate(value.matchDate)}
          </Text>
        </div>
        <Badge
          color={getStatusColor(MatchStatus[value.status])}
          text={MatchStatus[value.status]}
          className="status-badge"
          style={{
            padding: '2px 10px',
            borderRadius: '12px',
            fontWeight: '500',
          }}
        />
      </motion.div>

      <motion.div variants={contentVariants}>
        <Title level={4} className="mb-1 match-title">
          {value.title}
        </Title>
        <Text className="text-secondary d-block mb-3 match-description">
          {value.description}
        </Text>
      </motion.div>

      <motion.div
        className="match-info d-flex align-items-center mb-4"
        variants={contentVariants}
      >
        <div className="d-flex align-items-center me-3">
          <UserOutlined className="me-2 text-primary" />
          <Text strong>{MatchFormat[value.matchFormat]}</Text>
        </div>
        <Badge
          count={
            MatchFormat[value.matchFormat].toLowerCase().includes('single')
              ? '1 v 1'
              : '2 v 2'
          }
          className="format-badge me-3"
          style={{
            backgroundColor: 'rgba(13, 110, 253, 0.1)',
            color: '#0d6efd',
            padding: '0 8px',
          }}
        />
        <TrophyOutlined className="me-2 text-warning" />
      </motion.div>

      <motion.div
        className="teams-container d-flex align-items-center justify-content-between py-3 my-2"
        style={{
          background: 'rgba(13, 110, 253, 0.03)',
          borderRadius: '12px',
          padding: '16px',
        }}
        variants={contentVariants}
      >
        <div className="team d-flex">
          {/* Team A players */}
          {renderPlayers(teamA)}
        </div>

        <motion.div
          className="vs-container"
          variants={vsVariants}
          initial="initial"
          animate="animate"
          whileHover="hover"
        >
          <Text
            className="vs-text"
            style={{
              fontSize: '24px',
              fontWeight: 'bold',
              background: 'rgba(13, 110, 253, 0.1)',
              width: '50px',
              height: '50px',
              borderRadius: '50%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#0d6efd',
            }}
          >
            VS
          </Text>
        </motion.div>

        <div className="team d-flex">
          {/* Team B players */}
          {renderPlayers(teamB)}
        </div>
      </motion.div>

      <motion.div
        className="d-flex justify-content-end mt-4"
        variants={buttonVariants}
        whileHover="hover"
        whileTap="tap"
        style={{
          borderRadius: '12px',
        }}
      >
        <Button
          type="primary"
          style={{
            padding: '10px 20px',
            borderRadius: '12px',
            width: '100%',
            height: 'auto',
            fontWeight: '600',
            fontSize: '15px',
          }}
          onClick={() => navigate(`/match-detail/${value.id}`)}
        >
          View Details{' '}
          <RightOutlined style={{ fontSize: '12px', marginLeft: '5px' }} />
        </Button>
      </motion.div>
    </motion.div>
  );
}
