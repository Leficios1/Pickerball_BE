import {
  CalendarOutlined,
  RightOutlined,
  TeamOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Matches, MatchFormat, MatchStatus } from '@src/modules/Match/models';
import { Badge, Button, Typography } from 'antd';
import 'bootstrap/dist/css/bootstrap.min.css';
import { motion } from 'framer-motion';
import './match-list-card.css';

const { Text, Title } = Typography;

interface MatchCardProps {
  value: Matches;
}

export default function MatchListCard({ value }: MatchCardProps) {
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

  // const playerVariants = {
  //   hidden: { opacity: 0, scale: 0.8 },
  //   visible: {
  //     opacity: 1,
  //     scale: 1,
  //     transition: {
  //       type: 'spring',
  //       stiffness: 200,
  //       damping: 10,
  //     },
  //   },
  //   hover: {
  //     y: -5,
  //     transition: {
  //       type: 'spring',
  //       stiffness: 300,
  //       damping: 10,
  //     },
  //   },
  // };

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
          {MatchFormat[value.matchFormat].toLowerCase().includes('single') ? (
            <UserOutlined className="me-2 text-primary" />
          ) : (
            <TeamOutlined className="me-2 text-primary" />
          )}
          <Text strong>{MatchFormat[value.matchFormat]}</Text>
        </div>
        <div className="d-flex align-items-center me-3">
          {MatchFormat[value.matchFormat].toLowerCase().includes('single') ? (
            <UserOutlined className="me-2 text-primary" />
          ) : (
            <TeamOutlined className="me-2 text-primary" />
          )}
          <Text strong>
            Players:{' '}
            {value.teams[0].members.length + value.teams[1].members.length}/
            {MatchFormat[value.matchFormat].toLowerCase().includes('single')
              ? 2
              : 4}
          </Text>
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
        >
          View Details{' '}
          <RightOutlined style={{ fontSize: '12px', marginLeft: '5px' }} />
        </Button>
      </motion.div>
    </motion.div>
  );
}
