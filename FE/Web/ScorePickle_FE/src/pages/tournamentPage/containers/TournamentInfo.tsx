import {
  BranchesOutlined,
  CalendarOutlined,
  ClockCircleOutlined,
  DollarOutlined,
  EnvironmentOutlined,
  FileTextOutlined,
  TeamOutlined,
  TrophyOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';
import { Tournament } from '@src/modules/Tournament/models';
import { Button, Card, Col, Modal, Row, Skeleton, Tag, Typography } from 'antd';
import React, { useState } from 'react';
import styles from './TournamentInfoCard.module.css';
import { motion } from 'framer-motion';

const { Text, Title } = Typography;

// Motion variants for animations
const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      when: 'beforeChildren',
      staggerChildren: 0.1,
      duration: 0.6,
    },
  },
};

const cardVariants = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 100,
      damping: 12,
      duration: 0.5,
    },
  },
  hover: {
    y: -5,
    transition: { duration: 0.3 },
  },
};

const tagVariants = {
  hidden: { scale: 0.8, opacity: 0 },
  visible: {
    scale: 1,
    opacity: 1,
    transition: { type: 'spring', stiffness: 300, damping: 15 },
  },
};

const infoItemVariants = {
  hidden: { x: -10, opacity: 0 },
  visible: {
    x: 0,
    opacity: 1,
    transition: { type: 'spring', stiffness: 100, damping: 10 },
  },
};

interface TournamentInfoProps {
  id: number;
}

const TournamentInfo: React.FC<TournamentInfoProps> = ({ id }) => {
  const { data, isLoading } = useGetTournamentById(id);
  const [rulesModalVisible, setRulesModalVisible] = useState(false);

  if (isLoading || !data)
    return (
      <Card className={styles.loadingCard}>
        <Skeleton active avatar paragraph={{ rows: 6 }} />
      </Card>
    );

  const tournament = data as Tournament;

  const formatDate = (date: string) =>
    new Date(date).toLocaleString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });

  // Determine tournament status
  const now = new Date();
  const startDate = new Date(tournament.startDate);
  const endDate = new Date(tournament.endDate);

  let status = 'Scheduled';
  let statusColor = 'blue';

  if (now > endDate) {
    status = 'Completed';
    statusColor = 'purple';
  } else if (now >= startDate) {
    status = 'Ongoing';
    statusColor = 'green';
  }

  return (
    <motion.div
      className={styles.tournamentInfoContainer}
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      style={{
        padding: '16px',
        backgroundColor: '#fff',
        borderRadius: '8px',
      }}
    >
      {/* Tournament Overview Card */}
      <motion.div className={styles.overviewCard} variants={cardVariants}>
        <div className={styles.overviewHeader}>
          <div>
            <motion.div
              variants={tagVariants}
              initial="hidden"
              animate="visible"
              style={{ display: 'inline-block', marginRight: '8px' }}
            >
              <Tag color={statusColor} className={styles.statusTag}>
                {status}
              </Tag>
            </motion.div>
            <motion.div
              variants={tagVariants}
              initial="hidden"
              animate="visible"
              style={{ display: 'inline-block' }}
            >
              <Tag color="blue" className={styles.typeTag}>
                {tournament.type}
              </Tag>
            </motion.div>
          </div>
        </div>
        {/* Description Section */}
        <motion.div
          className={styles.descriptionCard}
          variants={cardVariants}
          initial="hidden"
          animate="visible"
        >
          <Card>
            <div className={styles.sectionHeader}>
              <FileTextOutlined className={styles.sectionIcon} />
              <Title level={4}>About This Tournament</Title>
            </div>

            <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
              <Button
                type="primary"
                icon={<FileTextOutlined />}
                onClick={() => setRulesModalVisible(true)}
                className={styles.rulesButton}
              >
                View Tournament Rules
              </Button>
            </motion.div>
          </Card>
        </motion.div>
        <Row gutter={[24, 16]} className={styles.infoGrid}>
          <Col xs={24} md={8}>
            <motion.div variants={cardVariants} whileHover="hover">
              <Card className={styles.infoCard} title="Tournament Details">
                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <UserOutlined className={styles.icon} />
                  <Text>
                    <strong>Players:</strong>{' '}
                    {tournament.registrationDetails.length}/
                    {tournament.maxPlayer}
                  </Text>
                </motion.div>

                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <BranchesOutlined className={styles.icon} />
                  <Text>
                    <strong>Ranking:</strong> Level {tournament.isMinRanking} -
                    Level {tournament.isMaxRanking}
                  </Text>
                </motion.div>

                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <TeamOutlined className={styles.icon} />
                  <Text>
                    <strong>Format:</strong> {tournament.type}
                  </Text>
                </motion.div>
              </Card>
            </motion.div>
          </Col>

          <Col xs={24} md={8}>
            <motion.div variants={cardVariants} whileHover="hover">
              <Card className={styles.infoCard} title="Prizes & Fees">
                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <DollarOutlined className={styles.icon} />
                  <Text>
                    <strong>Entry Fee:</strong>{' '}
                    {!tournament.isFree
                      ? 'Free'
                      : `${tournament.entryFee.toLocaleString('vi-VN')} ₫`}
                  </Text>
                </motion.div>

                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <TrophyOutlined className={styles.icon} />
                  <Text>
                    <strong>Prize Pool:</strong>{' '}
                    {tournament.totalPrize.toLocaleString('vi-VN')} ₫
                  </Text>
                </motion.div>
              </Card>
            </motion.div>
          </Col>

          <Col xs={24} md={8}>
            <motion.div variants={cardVariants} whileHover="hover">
              <Card className={styles.infoCard} title="Schedule & Location">
                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <CalendarOutlined className={styles.icon} />
                  <Text>
                    <strong>Start Date:</strong>{' '}
                    {formatDate(tournament.startDate)}
                  </Text>
                </motion.div>

                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <ClockCircleOutlined className={styles.icon} />
                  <Text>
                    <strong>End Date:</strong> {formatDate(tournament.endDate)}
                  </Text>
                </motion.div>

                <motion.div
                  className={styles.infoItem}
                  variants={infoItemVariants}
                >
                  <EnvironmentOutlined className={styles.icon} />
                  <Text>
                    <strong>Location:</strong> {tournament.location}
                  </Text>
                </motion.div>
              </Card>
            </motion.div>
          </Col>
        </Row>
      </motion.div>

      {/* Rules Modal */}
      <Modal
        title="Tournament Rules & Guidelines"
        open={rulesModalVisible}
        onCancel={() => setRulesModalVisible(false)}
        footer={[
          <Button
            key="close"
            type="primary"
            onClick={() => setRulesModalVisible(false)}
          >
            Close
          </Button>,
        ]}
        width={700}
      >
        <motion.div
          className={styles.rulesContent}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <div
            dangerouslySetInnerHTML={{
              __html:
                tournament.note ||
                '<p>No rules provided for this tournament.</p>',
            }}
          ></div>
        </motion.div>
      </Modal>
    </motion.div>
  );
};

export default TournamentInfo;
