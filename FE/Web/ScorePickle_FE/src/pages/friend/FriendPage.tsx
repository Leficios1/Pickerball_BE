import React, { useState, useEffect } from 'react';
import {
  Input,
  Card,
  Avatar,
  Button,
  Spin,
  Empty,
  Typography,
  Row,
  Col,
} from 'antd';
import { useInView } from 'react-intersection-observer';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import {
  LoadingOutlined,
  SearchOutlined,
  TeamOutlined,
  TrophyOutlined,
  ManOutlined,
  WomanOutlined,
  UserDeleteOutlined,
} from '@ant-design/icons';
import '../../pages/playerPage/player-page.css';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { useGetFriendByUserId } from '@src/modules/Friend/hooks/useGetFriendByUserId';
import { useRemoveFriend } from '@src/modules/Friend/hooks/useRemoveFriend';

const { Title, Text } = Typography;

const PlayerCard = ({
  fullName,
  avatarUrl,
  gender,
  level,
  checkUser,
  onAddFriendClick,
  index,
}) => {
  // Get gender icon
  const getGenderIcon = () => {
    if (!gender) return null;
    return gender.toLowerCase() === 'male' ? (
      <ManOutlined style={{ color: '#1677ff' }} />
    ) : (
      <WomanOutlined style={{ color: '#eb2f96' }} />
    );
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{
        duration: 0.4,
        delay: index * 0.05,
        ease: 'easeOut',
      }}
      whileHover={{
        y: -5,
        boxShadow: '0 10px 25px rgba(0,0,0,0.08)',
        transition: { duration: 0.2 },
      }}
      className="player-card-wrapper"
    >
      <Card
        className="player-card player-card-white"
        bordered={false}
        hoverable
      >
        <div className="player-card-content">
          <motion.div
            className="avatar-container"
            whileHover={{ scale: 1.05 }}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <Avatar size={70} src={avatarUrl} className="player-avatar-white">
              {!avatarUrl && fullName}
            </Avatar>
          </motion.div>

          <div className="player-info">
            <div className="player-name-row">
              <h3 className="player-name-white">{fullName}</h3>
              <motion.div
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className="player-level-badge"
              >
                <Button type="text" className="level-badge-white">
                  <TrophyOutlined style={{ color: '#faad14' }} /> Level{' '}
                  {level || '?'}
                </Button>
              </motion.div>
            </div>

            <div className="player-details-row">
              {gender && (
                <div className="detail-item">
                  {getGenderIcon()}
                  <span>{gender}</span>
                </div>
              )}
            </div>

            <div className="player-actions">
              {checkUser && (
                <motion.div
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.9 }}
                  className="add-friend-btn-wrapper"
                >
                  <Button
                    className="add-friend-btn-white"
                    onClick={onAddFriendClick}
                    icon={<UserDeleteOutlined />}
                    shape="circle"
                    title="Add Friend"
                  />
                </motion.div>
              )}
            </div>
          </div>
        </div>
      </Card>
    </motion.div>
  );
};

export const FriendPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [visiblePlayers, setVisiblePlayers] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const user = useSelector((state: RootState) => state.auth.user);
  const { data, isLoading } = useGetFriendByUserId(user?.id ?? 0);
  const navigate = useNavigate();
  const { mutate: removeFriend } = useRemoveFriend();

  const { ref, inView } = useInView({
    triggerOnce: false,
    threshold: 0.5,
    rootMargin: '0px 0px 200px 0px',
  });

  // Load more players when scrolling
  const loadMore = () => {
    if (loading || !data || visiblePlayers.length >= data.length) return;

    setLoading(true);
    setTimeout(() => {
      setVisiblePlayers((prevPlayers) => [
        ...prevPlayers,
        ...data.slice(prevPlayers.length, prevPlayers.length + 10),
      ]);
      setLoading(false);
    }, 300);
  };

  // Initial load
  useEffect(() => {
    if (data && data.length > 0) {
      setVisiblePlayers(data.slice(0, 10));
    }
  }, [data]);

  // Load more when scrolling to bottom
  useEffect(() => {
    if (inView) {
      loadMore();
    }
  }, [inView]);

  // Add friend handler
  const handleCancelFriend = (id: number) => {
    if (user?.id !== undefined) {
      removeFriend({ data: { user1Id: user.id, user2Id: id } });
    }
  };

  // Search handler
  const handleSearch = (e) => {
    const term = e.target.value;
    setSearchTerm(term);

    if (!data) return;

    // If search is empty, reset to first 10 players
    if (!term.trim()) {
      setVisiblePlayers(data.slice(0, 10));
      return;
    }

    // Filter players by name
    const filtered = data.filter((player) => {
      const fullName = player.userFriendName?.toLowerCase() ?? '';
      return fullName.includes(term.toLowerCase());
    });

    setVisiblePlayers(filtered);
  };

  // Navigate to profile page
  const goToProfile = (id: string) => {
    navigate(`/profile/${id}`);
  };

  // Filter players based on search term
  const filteredPlayers = visiblePlayers.filter((player) => {
    const fullName = `${player.firstName || ''} ${player.secondName || ''} ${
      player.lastName || ''
    }`.toLowerCase();
    return fullName.includes(searchTerm.toLowerCase());
  });

  return (
    <motion.div
      className="players-page-container"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <div className="content-container">
        <div className="header-container">
          <motion.div
            className="page-header"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
          >
            <Title level={2} className="page-title">
              <TeamOutlined className="title-icon" />
              Find Friends
            </Title>
          </motion.div>

          <motion.div
            className="search-container"
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: 0.3 }}
          >
            <Input
              prefix={<SearchOutlined className="search-icon" />}
              placeholder="Search players by name..."
              value={searchTerm}
              onChange={handleSearch}
              className="search-input"
              allowClear
            />
          </motion.div>
        </div>

        <AnimatePresence>
          {isLoading ? (
            <motion.div
              className="loading-container"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              <Spin
                indicator={<LoadingOutlined style={{ fontSize: 48 }} spin />}
                tip="Loading players..."
              />
            </motion.div>
          ) : filteredPlayers.length > 0 ? (
            <motion.div
              className="players-grid-container"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.5, delay: 0.4 }}
            >
              <Row gutter={[16, 16]} className="players-grid">
                {filteredPlayers.map((player, index) => (
                  <Col xs={24} sm={12} md={8} lg={8} key={player.id}>
                    <div
                      onClick={() => goToProfile(player.userFriendId)}
                      className="player-item"
                    >
                      <PlayerCard
                        fullName={player.userFriendName}
                        avatarUrl={player.userFriendAvatar}
                        gender={player.gender}
                        level={player.exeprienceLevel}
                        checkUser={user?.id}
                        index={index}
                        onAddFriendClick={(e) => {
                          e.stopPropagation();
                          handleCancelFriend(player.id);
                        }}
                      />
                    </div>
                  </Col>
                ))}
              </Row>

              {/* Load more trigger */}
              {!loading && visiblePlayers.length < (data?.length ?? 0) && (
                <div ref={ref} className="load-trigger">
                  {/* This element will trigger loading more when it comes into view */}
                </div>
              )}

              {/* Loading indicator at bottom */}
              {loading && (
                <motion.div
                  className="loading-more"
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0 }}
                >
                  <LoadingOutlined /> Loading more players...
                </motion.div>
              )}
            </motion.div>
          ) : (
            <motion.div
              className="empty-state"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.4 }}
            >
              <Empty
                description={
                  <Text style={{ color: '#595959' }}>
                    {searchTerm
                      ? 'No players found matching your search'
                      : 'No players available'}
                  </Text>
                }
                image={Empty.PRESENTED_IMAGE_SIMPLE}
              />
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </motion.div>
  );
};

export default FriendPage;
