import { Avatar, Button, Card, Table, Typography, Empty } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useState } from 'react';
import { RegistrationDetail } from '@src/modules/Tournament/models';
import { useSelector } from 'react-redux';
import { motion } from 'framer-motion';
import './participants.css';
import { RootState } from '@src/redux/store';
import { TouramentregistrationStatus } from '@src/modules/TournamentRegistration/models';

const { Title, Text } = Typography;

type PlayersTableProps = {
  tournamentId: number;
  tournamentName?: string; // Optional tournament name for display
  registrations: RegistrationDetail[];
  refetch: () => void;
};

const PlayerCard = ({
  firstName,
  secondName,
  lastName,
  avatarUrl,
  email,
  ranking,
}) => (
  <motion.div
    initial={{ opacity: 0, y: 10 }}
    animate={{ opacity: 1, y: 0 }}
    transition={{ duration: 0.4 }}
  >
    <Card
      className="profile-card border rounded mb-2 card player-card"
      hoverable
    >
      <div className="d-flex align-items-center">
        <div className="avatar-container">
          <motion.div
            whileHover={{ scale: 1.1 }}
            transition={{ type: 'spring', stiffness: 300, damping: 10 }}
          >
            <Avatar
              style={{ marginLeft: '10px' }}
              size={50}
              src={
                avatarUrl ??
                'https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg'
              }
              className="bg-primary"
            />
          </motion.div>
        </div>
        <div className="ms-3 user-info">
          <Text strong className="player-name">
            {firstName} {secondName} {lastName}
          </Text>
          <Text type="secondary" className="player-email">
            {email}
          </Text>
        </div>
        <motion.div
          className="position-absolute end-0 translate-middle-y me-3"
          whileHover={{ scale: 1.05 }}
        >
          <Button
            className="d-flex justify-content-center align-items-center ranking-btn"
            style={{
              top: '50%',
              transform: 'translateY(-50%)',
              background:
                ranking >= 7
                  ? 'rgba(22, 119, 255, 0.1)'
                  : ranking >= 4
                    ? 'rgba(82, 196, 26, 0.1)'
                    : 'rgba(250, 173, 20, 0.1)',
              color:
                ranking >= 7 ? '#1677ff' : ranking >= 4 ? '#52c41a' : '#faad14',
              border: 'none',
              fontWeight: '600',
            }}
          >
            Level {ranking}
          </Button>
        </motion.div>
      </div>
    </Card>
  </motion.div>
);

export const Participants = ({ registrations = [] }: PlayersTableProps) => {
  const [filteredRegistrations] = useState<RegistrationDetail[]>(registrations);

  const user = useSelector((state: RootState) => state.auth.user);

  // Animation variants for container
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        when: 'beforeChildren',
        staggerChildren: 0.1,
      },
    },
  };

  // Animation variants for table rows
  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        type: 'spring',
        stiffness: 100,
        damping: 12,
      },
    },
  };

  // 1. Kiểm tra xem có bản ghi nào có partner không
  const hasPartner = registrations.some((item) => !!item.partnerId);

  // 2. Định nghĩa các cột chung
  const baseColumns: ColumnsType<RegistrationDetail> = [
    {
      title: hasPartner ? 'Player 1' : 'Player',
      dataIndex: ['playerDetails', 'avatarUrl'],
      key: 'avatarUrl',
      render: (_: string, record) => {
        return (
          <PlayerCard
            firstName={record.playerDetails.firstName}
            secondName={record.playerDetails.secondName}
            lastName={record.playerDetails.lastName}
            avatarUrl={record.playerDetails.avatarUrl}
            email={record.playerDetails.email}
            ranking={record.playerDetails.ranking}
          />
        );
      },
    },
  ];

  // 3. Nếu có partner thì thêm cột này
  const partnerColumns: ColumnsType<RegistrationDetail> = [
    {
      title: 'Player 2',
      dataIndex: ['partnerDetails', 'avatarUrl'],
      key: 'avatarUrl',
      render: (_: string, record) => {
        return (
          <PlayerCard
            firstName={record.partnerDetails.firstName}
            secondName={record.partnerDetails.secondName}
            lastName={record.partnerDetails.lastName}
            avatarUrl={record.partnerDetails.avatarUrl}
            email={record.partnerDetails.email}
            ranking={record.partnerDetails.ranking}
          />
        );
      },
    },
  ];

  // 4. Kết hợp columns trước khi render <Table>
  const columns: ColumnsType<RegistrationDetail> = [
    ...baseColumns,
    ...(hasPartner ? partnerColumns : []),
  ];

  const rowClassName = (record: RegistrationDetail) => {
    // Check if the player's id or the partner's id matches the user id and highlight the row
    if (record.playerId === user?.id || record.partnerId === user?.id) {
      return 'highlight-row';
    }
    return '';
  };

  return (
    <motion.div
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      className="participants-container"
    >
      <motion.div variants={itemVariants}>
        <div className="participants-header">
          <Title level={4} className="mb-3">
            {registrations.length > 0 ? (
              <>
                Tournament Participants
                <span className="participant-count">
                  {registrations.length}
                </span>
              </>
            ) : (
              'No Participants Yet'
            )}
          </Title>
        </div>
      </motion.div>

      <style>
        {`
          .highlight-row {
            background-color: rgba(250, 173, 20, 0.15) !important;
            border-left: 3px solid #faad14;
          }
          
          .highlight-row:hover td {
            background-color: rgba(250, 173, 20, 0.25) !important;
          }
        `}
      </style>

      {registrations.length > 0 ? (
        <motion.div variants={itemVariants}>
          <Table
            columns={columns}
            dataSource={filteredRegistrations}
            rowKey="id"
            className="participants-table"
            pagination={{
              pageSize: 10,
              showSizeChanger: false,
              position: ['bottomCenter'],
              className: 'custom-pagination',
            }}
            rowClassName={rowClassName}
          />
        </motion.div>
      ) : (
        <motion.div variants={itemVariants} className="empty-state">
          <Empty
            description="No participants have registered yet"
            image={Empty.PRESENTED_IMAGE_SIMPLE}
          />
        </motion.div>
      )}
    </motion.div>
  );
};

export default Participants;
