import React, { useMemo } from 'react';
import { Avatar, Card, Col, Row, Table, Tag, Typography } from 'antd';
import { TrophyOutlined } from '@ant-design/icons';
import { motion } from 'framer-motion';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useGetTopPlayer } from '@src/modules/Ranking/hooks/useGetLeaderBoard';
import { TopPlayer } from '@src/modules/Ranking/models';

const { Title, Text } = Typography;

const getMedalColor = (rank: number) => {
  switch (rank) {
    case 1:
      return '#FFD700';
    case 2:
      return '#C0C0C0';
    case 3:
      return '#CD7F32';
    default:
      return '#8c8c8c';
  }
};

const getMedalIcon = (rank: number) => {
  switch (rank) {
    case 1:
      return '🥇';
    case 2:
      return '🥈';
    case 3:
      return '🥉';
    default:
      return '';
  }
};

const RankingPage: React.FC = () => {
  const { data: leaderboard = [] } = useGetTopPlayer();
  const userId = useSelector((state: RootState) => state.auth.user?.id);

  const topThreePlayers = useMemo(() => leaderboard.slice(0, 3), [leaderboard]);
  const currentUserRank = useMemo(() => {
    const index = leaderboard.findIndex((p) => p.userId === userId);
    return index >= 0 ? { player: leaderboard[index], rank: index + 1 } : null;
  }, [leaderboard, userId]);

  const columns = [
    {
      title: 'Rank',
      key: 'rank',
      render: (_: any, __: any, index: number) => (
        <Tag color="#108ee9">#{index + 1}</Tag>
      ),
    },
    {
      title: 'Player',
      dataIndex: 'fullName',
      key: 'fullName',
      render: (text: string, record: TopPlayer) => (
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <Avatar src={record.avatar} style={{ marginRight: 8 }} />
          <Text
            strong
            style={{ color: record.userId === userId ? '#1677ff' : 'inherit' }}
          >
            {text} {record.userId === userId && '(You)'}
          </Text>
        </div>
      ),
    },
    {
      title: 'Wins',
      dataIndex: 'totalWins',
      key: 'totalWins',
      render: (wins: number) => <Tag color="green">{wins}</Tag>,
    },
    {
      title: 'Points',
      dataIndex: 'rankingPoint',
      key: 'rankingPoint',
      render: (points: number) => <Text strong>{points}</Text>,
    },
  ];

  return (
    <motion.div
      style={{
        background:
          'linear-gradient(to right, rgb(30, 58, 138), rgb(59, 130, 246))',
        minHeight: '100vh',
        padding: '80px 20px',
        borderRadius: 6,
        transition: '0.25s',
        maxWidth: 1600,
        margin: '0 auto',
      }}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
    >
      <Title
        level={2}
        style={{ textAlign: 'center', color: 'white', marginBottom: 40 }}
      >
        <TrophyOutlined style={{ color: '#FFD700', marginRight: 10 }} />
        Top Players
      </Title>

      <Row gutter={[16, 32]} justify="center">
        {topThreePlayers.map((player, index) => (
          <Col xs={24} sm={12} md={8} key={player.userId}>
            <motion.div whileHover={{ scale: 1.05 }}>
              <Card
                bordered={false}
                style={{
                  background: 'rgba(255,255,255,0.05)',
                  border: `2px solid ${getMedalColor(index + 1)}`,
                  borderRadius: 12,
                  textAlign: 'center',
                  padding: 24,
                  boxShadow: `0 0 12px ${getMedalColor(index + 1)}44`,
                }}
              >
                <Avatar
                  size={96}
                  src={player.avatar}
                  style={{
                    border: `4px solid ${getMedalColor(index + 1)}`,
                    marginBottom: 12,
                  }}
                />
                <Title level={4} style={{ color: 'white', marginBottom: 8 }}>
                  {getMedalIcon(index + 1)} {player.fullName}
                </Title>
                <Text style={{ color: 'white' }}>
                  {player.totalWins} wins - {player.rankingPoint} pts
                </Text>
              </Card>
            </motion.div>
          </Col>
        ))}
      </Row>

      {currentUserRank && (
        <Card
          style={{
            marginTop: 48,
            background: 'rgba(255,255,255,0.08)',
            border: '1px solid #1677ff',
            borderRadius: 12,
            color: 'white',
            padding: 24,
          }}
        >
          <Title level={4} style={{ color: '#0ff' }}>
            Your Rank: #{currentUserRank.rank}
          </Title>
          <Row gutter={24} align="middle">
            <Col>
              <Avatar size={64} src={currentUserRank.player.avatar} />
            </Col>
            <Col>
              <Text strong style={{ fontSize: 18, color: 'white' }}>
                {currentUserRank.player.fullName}
              </Text>
              <br />
              <Tag color="green">{currentUserRank.player.totalWins} Wins</Tag>
              <Tag color="blue">
                {currentUserRank.player.rankingPoint} Points
              </Tag>
            </Col>
          </Row>
        </Card>
      )}

      <Table
        columns={columns}
        dataSource={leaderboard}
        rowKey="userId"
        pagination={false}
        style={{
          marginTop: 48,
          background: '#fff',
          borderRadius: 12,
          overflow: 'hidden',
        }}
        scroll={{ y: 600 }}
      />
    </motion.div>
  );
};

export default RankingPage;
