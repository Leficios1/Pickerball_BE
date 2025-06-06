import React, { useEffect, useState } from 'react';
import {
  Avatar,
  Tag,
  Input,
  Select,
  Card,
  Spin,
  Modal,
  Row,
  Col,
  Divider,
  message,
  Button,
  Typography,
  Statistic,
  Badge,
} from 'antd';
import {
  LikeOutlined,
  DislikeOutlined,
  StockOutlined,
  FireOutlined,
  PlusCircleOutlined,
  UserAddOutlined,
  TrophyOutlined,
  EnvironmentOutlined,
  CalendarOutlined,
} from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';
import './profile-page.css';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { MatchCategory, MatchFormat } from '@src/modules/Match/models';
import { useGetListMatchAndScore } from '@src/modules/Match/hooks/useGetListMatchesAndScore';
import { useParams } from 'react-router-dom';
import { useGetUserById } from '@src/modules/User/hooks/useGetUserById';
import { useAddFriend } from '@src/modules/Friend/hooks/useAddFriend';
import { AddFriendRequest } from '@src/modules/Friend/models';
import { useJoinMatch } from '@src/modules/Match/hooks/useJoinMatch';
import { Link } from 'react-router-dom';
import Achievement from '@src/components/Achievement';

const { Option } = Select;
const { Search } = Input;
const { Title, Text } = Typography;

const MyProfile: React.FC = () => {
  const currentUser = useSelector((state: RootState) => state.auth.user);
  const { id } = useParams<{ id: string }>();
  const { data: matchesData, isLoading } = useGetListMatchAndScore(
    Number(id || 0)
  );
  const { data: user } = useGetUserById(Number(id || 0));
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [selectedMatchId, setSelectedMatchId] = useState<number | null>(null);
  const { mutate: addFriend } = useAddFriend();
  const { mutate: joinMatch } = useJoinMatch();

  const MatchCategoryColors: Record<MatchCategory, string> = {
    [MatchCategory.Custom]: 'green',
    [MatchCategory.Tournament]: 'blue',
    [MatchCategory.Competitive]: 'orange',
  };

  const WLColors: Record<number, string> = {
    1: 'green',
    2: '#FF0000',
  };

  const [matches, setMatches] = useState(matchesData || []);
  const [matchType, setMatchType] = useState('any');

  useEffect(() => {
    if (Array.isArray(matchesData)) {
      setMatches(matchesData);
    }
  }, [matchesData]);

  if (!id) {
    return (
      <div className="d-flex justify-content-center align-items-center vh-100">
        <Spin size="large" />
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="d-flex justify-content-center align-items-center vh-100">
        <Spin size="large" />
      </div>
    );
  }

  const formattedDate = (d: any) => {
    const date = new Date(d);
    return date.toLocaleString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false,
    });
  };

  const handleShowModal = (matchId: number) => {
    setSelectedMatchId(matchId);
    setIsModalVisible(true);
  };

  const handleCancel = () => setIsModalVisible(false);

  const handleJoinMatch = () => {
    if (selectedMatchId && currentUser?.id) {
      const payload = {
        matchId: selectedMatchId,
        userJoinId: currentUser.id,
      };
      joinMatch({ data: payload });
      setIsModalVisible(false);
    }
  };

  function handleAddFriend() {
    const payload: AddFriendRequest = {
      user1Id: currentUser?.id ?? 0,
      user2Id: Number(id || 0),
    };
    if (currentUser?.id !== undefined) {
      addFriend({ data: payload });
      message.success('Friend request sent successfully!');
    } else {
      message.error(
        'You have no permission to use this. Please login to add friend.'
      );
    }
  }

  // Filter matches when user changes the value in Select
  const handleFilter = (value: string) => {
    setMatchType(value);

    let filteredMatches = matchesData || [];

    switch (value) {
      case 'tournament':
        filteredMatches = filteredMatches.filter(
          (m) => m.info.matchCategory === MatchCategory.Tournament
        );
        break;
      case 'custom':
        filteredMatches = filteredMatches.filter(
          (m) => m.info.matchCategory === MatchCategory.Custom
        );
        break;
      case 'competitive':
        filteredMatches = filteredMatches.filter(
          (m) => m.info.matchCategory === MatchCategory.Competitive
        );
        break;
      default:
        break;
    }

    setMatches(filteredMatches);
  };

  return (
    <div className="profile-container">
      {/* Header */}
      <Card className="profile-header-card">
        <Row gutter={[24, 24]} align="middle">
          <Col xs={24} md={16}>
            <div className="profile-header-content">
              <Badge dot={true} color="green" offset={[-5, 75]}>
                <Avatar
                  size={100}
                  src={
                    user?.avatarUrl ?? '/placeholder.svg?height=100&width=100'
                  }
                  className="profile-avatar"
                />
              </Badge>
              <div className="profile-info">
                <Title level={3} className="profile-name">
                  {user?.firstName} {user?.lastName}
                </Title>
                <div className="profile-details">
                  <Text type="secondary">
                    <EnvironmentOutlined className="detail-icon" />
                    {user?.userDetails?.province}, {user?.userDetails?.city}
                  </Text>
                  <Divider type="vertical" />
                  <Text type="secondary">
                    <CalendarOutlined className="detail-icon" />
                    {user?.dateOfBirth
                      ? `${Math.floor(
                          (Date.now() - new Date(user.dateOfBirth).getTime()) /
                            (1000 * 60 * 60 * 24 * 365.25)
                        )} years old`
                      : 'Age not provided'}
                  </Text>
                </div>
                {currentUser?.id !== Number(id) && (
                  <Button
                    type="primary"
                    onClick={handleAddFriend}
                    icon={<UserAddOutlined />}
                    className="add-friend-btn"
                  >
                    Add Friend
                  </Button>
                )}
              </div>
            </div>
          </Col>
          <Col xs={24} md={8} className="level-container">
            <Card className="level-card">
              <Statistic
                title="Player Level"
                value={user?.userDetails?.experienceLevel || 0}
                prefix={<TrophyOutlined />}
                valueStyle={{ color: '#1890ff' }}
              />
            </Card>
          </Col>
        </Row>
      </Card>
      <div className="profile-content">
        <Achievement userId={Number(id)} />
      </div>
      {/* Content */}
      <div className="profile-content">
        <Row gutter={[24, 24]}>
          {/* Stats */}
          <Col xs={24} lg={8}>
            <Card
              title={<span className="section-title">Player Stats</span>}
              className="stats-card"
              bordered={false}
            >
              <Row gutter={[16, 24]}>
                <Col span={12}>
                  <Card bordered={false} className="stat-box">
                    <Statistic
                      title="Level"
                      value={user?.userDetails?.experienceLevel || 0}
                      prefix={<StockOutlined />}
                      valueStyle={{ color: '#1890ff' }}
                    />
                  </Card>
                </Col>
                <Col span={12}>
                  <Card bordered={false} className="stat-box">
                    <Statistic
                      title="Points"
                      value={user?.userDetails?.rankingPoint || 0}
                      prefix={<FireOutlined />}
                      valueStyle={{ color: '#ff4d4f' }}
                    />
                  </Card>
                </Col>
                <Col span={12}>
                  <Card bordered={false} className="stat-box">
                    <Statistic
                      title="Wins"
                      value={user?.userDetails?.totalWins || 0}
                      prefix={<LikeOutlined />}
                      valueStyle={{ color: '#52c41a' }}
                    />
                  </Card>
                </Col>
                <Col span={12}>
                  <Card bordered={false} className="stat-box">
                    <Statistic
                      title="Losses"
                      value={
                        (user?.userDetails?.totalMatch || 0) -
                        (user?.userDetails?.totalWins || 0)
                      }
                      prefix={<DislikeOutlined />}
                      valueStyle={{ color: '#ff4d4f' }}
                    />
                  </Card>
                </Col>
              </Row>
            </Card>
          </Col>

          {/* Matches */}
          <Col xs={24} lg={16}>
            <Card
              title={<span className="section-title">Match History</span>}
              className="matches-card"
              bordered={false}
              extra={
                <div className="filter-controls">
                  <Select
                    value={matchType}
                    style={{ width: 140 }}
                    onChange={handleFilter}
                    size="middle"
                  >
                    <Option value="any">All Matches</Option>
                    <Option value="tournament">Tournament</Option>
                    <Option value="custom">Friendly</Option>
                    <Option value="competitive">Competitive</Option>
                  </Select>
                  <Search
                    placeholder="Search matches"
                    style={{ width: 200, marginLeft: 16 }}
                    size="middle"
                  />
                </div>
              }
            >
              {matches.length === 0 ? (
                <div className="empty-matches">
                  <Text type="secondary">No matches found</Text>
                </div>
              ) : (
                matches.map((match) => (
                  <Link
                    key={match.info.id}
                    to={`/match-detail/${match.info.id}`}
                    className="match-link"
                  >
                    <Card className="match-card" bordered={false}>
                      {/* Match Header */}
                      <div className="match-header">
                        <div>
                          <Tag
                            color={
                              MatchCategoryColors[match.info.matchCategory]
                            }
                            className="match-tag"
                          >
                            {MatchCategory[match.info.matchCategory]}
                          </Tag>
                          <Title level={5} className="match-title">
                            {match.info.title}
                          </Title>
                          <Text type="secondary" className="match-date">
                            <CalendarOutlined className="date-icon" />
                            {formattedDate(match.info.matchDate)}
                            {match.info.venueAddress && (
                              <>
                                <EnvironmentOutlined className="location-icon" />
                                {match.info.venueAddress}
                              </>
                            )}
                          </Text>
                        </div>

                        {/* Final Score Badge */}
                        <div className="final-score-badge">
                          <div className="score-container">
                            <div
                              className={`score-box ${
                                (match.info.team1Score ?? 0) >
                                (match.info.team2Score ?? 0)
                                  ? 'winner'
                                  : ''
                              }`}
                            >
                              {match.info.team1Score ?? 0}
                            </div>
                            <div className="score-divider">:</div>
                            <div
                              className={`score-box ${
                                (match.info.team2Score ?? 0) >
                                (match.info.team1Score ?? 0)
                                  ? 'winner'
                                  : ''
                              }`}
                            >
                              {match.info.team2Score ?? 0}
                            </div>
                          </div>
                          <Text type="secondary" className="final-score-label">
                            Final Score
                          </Text>
                        </div>
                      </div>

                      {/* Match Content */}
                      <div className="match-content">
                        <Row gutter={16}>
                          {/* Team 1 */}
                          <Col xs={24} md={11}>
                            <div className="team-section">
                              <div className="team-header">
                                <Text strong className="team-label">
                                  {MatchFormat[match.info.matchFormat]
                                    .toLowerCase()
                                    .includes('single')
                                    ? 'Player 1'
                                    : 'Team 1'}
                                </Text>
                                <Tag
                                  color={
                                    (match.info.team1Score ?? 0) >
                                    (match.info.team2Score ?? 0)
                                      ? 'green'
                                      : 'default'
                                  }
                                  className="team-score-tag"
                                >
                                  {(match.info.team1Score ?? 0) >
                                  (match.info.team2Score ?? 0)
                                    ? 'Winner'
                                    : 'Score: ' + (match.info.team1Score ?? 0)}
                                </Tag>
                              </div>

                              <div className="player-card">
                                <Avatar
                                  size={40}
                                  src={
                                    match.info.player1?.avatarUrl ||
                                    `/placeholder.svg?height=40&width=40`
                                  }
                                  className="player-avatar"
                                />
                                <div className="player-info">
                                  <Text strong className="player-name">
                                    {(match.info.player1?.firstName ?? '') +
                                      ' ' +
                                      (match.info.player1?.secondName ?? '') +
                                      ' ' +
                                      (match.info.player1?.lastName ?? '')}
                                  </Text>
                                </div>
                              </div>

                              {match.info.teams[0].members[1] ? (
                                <div className="player-card">
                                  <Avatar
                                    size={40}
                                    src={
                                      match.info.player2?.avatarUrl ||
                                      `/placeholder.svg?height=40&width=40`
                                    }
                                    className="player-avatar"
                                  />
                                  <div className="player-info">
                                    <Text strong className="player-name">
                                      {match.info.player2 &&
                                        (match.info.player2?.firstName ?? '') +
                                          ' ' +
                                          (match.info.player2?.secondName ??
                                            '') +
                                          ' ' +
                                          (match.info.player2?.lastName ?? '')}
                                    </Text>
                                  </div>
                                </div>
                              ) : (
                                <div className="player-card">
                                  {MatchFormat[match.info.matchFormat]
                                    .toLowerCase()
                                    .includes('double') && (
                                    <Button
                                      type="dashed"
                                      icon={<PlusCircleOutlined />}
                                      onClick={(e) => {
                                        e.preventDefault();
                                        handleShowModal(match.info.id);
                                      }}
                                      className="join-button"
                                    >
                                      Join as Player 2
                                    </Button>
                                  )}
                                </div>
                              )}
                            </div>
                          </Col>

                          <Divider type="vertical" className="team-divider" />

                          {/* Team 2 */}
                          <Col xs={24} md={11}>
                            <div className="team-section">
                              <div className="team-header">
                                <Text strong className="team-label">
                                  {MatchFormat[match.info.matchFormat]
                                    .toLowerCase()
                                    .includes('single')
                                    ? 'Player 2'
                                    : 'Team 2'}
                                </Text>
                                <Tag
                                  color={
                                    (match.info.team2Score ?? 0) >
                                    (match.info.team1Score ?? 0)
                                      ? 'green'
                                      : 'default'
                                  }
                                  className="team-score-tag"
                                >
                                  {(match.info.team2Score ?? 0) >
                                  (match.info.team1Score ?? 0)
                                    ? 'Winner'
                                    : 'Score: ' + (match.info.team2Score ?? 0)}
                                </Tag>
                              </div>

                              {match.info.teams[1].members[0] ? (
                                <div className="player-card">
                                  <Avatar
                                    size={40}
                                    src={
                                      match.info.player3?.avatarUrl ||
                                      `/placeholder.svg?height=40&width=40`
                                    }
                                    className="player-avatar"
                                  />
                                  <div className="player-info">
                                    <Text strong className="player-name">
                                      {match.info.player3 &&
                                        (match.info.player3?.firstName ?? '') +
                                          ' ' +
                                          (match.info.player3?.secondName ??
                                            '') +
                                          ' ' +
                                          (match.info.player3?.lastName ?? '')}
                                    </Text>
                                  </div>
                                </div>
                              ) : (
                                <div className="player-card">
                                  {currentUser?.id !== match.info.player1?.id &&
                                    currentUser?.id !==
                                      match.info.player2?.id &&
                                    currentUser?.id !==
                                      match.info.player3?.id &&
                                    currentUser?.id !==
                                      match.info.player4?.id && (
                                      <Button
                                        type="dashed"
                                        icon={<PlusCircleOutlined />}
                                        onClick={(e) => {
                                          e.preventDefault();
                                          handleShowModal(match.info.id);
                                        }}
                                        className="join-button"
                                      >
                                        Join as Player 3
                                      </Button>
                                    )}
                                </div>
                              )}

                              {match.info.teams[1].members[1] ? (
                                <div className="player-card">
                                  <Avatar
                                    size={40}
                                    src={
                                      match.info.player4?.avatarUrl ||
                                      `/placeholder.svg?height=40&width=40`
                                    }
                                    className="player-avatar"
                                  />
                                  <div className="player-info">
                                    <Text strong className="player-name">
                                      {match.info.player4 &&
                                        (match.info.player4?.firstName ?? '') +
                                          ' ' +
                                          (match.info.player4?.secondName ??
                                            '') +
                                          ' ' +
                                          (match.info.player4?.lastName ?? '')}
                                    </Text>
                                  </div>
                                </div>
                              ) : (
                                <div className="player-card">
                                  {MatchFormat[match.info.matchFormat]
                                    .toLowerCase()
                                    .includes('double') &&
                                    currentUser?.id !==
                                      match.info.player1?.id &&
                                    currentUser?.id !==
                                      match.info.player2?.id &&
                                    currentUser?.id !==
                                      match.info.player3?.id &&
                                    currentUser?.id !==
                                      match.info.player4?.id && (
                                      <Button
                                        type="dashed"
                                        icon={<PlusCircleOutlined />}
                                        onClick={(e) => {
                                          e.preventDefault();
                                          handleShowModal(match.info.id);
                                        }}
                                        className="join-button"
                                      >
                                        Join as Player 4
                                      </Button>
                                    )}
                                </div>
                              )}
                            </div>
                          </Col>
                        </Row>

                        {/* Match Score Details */}
                        {match.score && (
                          <div className="score-details">
                            <Divider>Match Score Details</Divider>
                            <table className="score-table">
                              <thead>
                                <tr>
                                  <th></th>
                                  <th>Half 1</th>
                                  <th>Half 2</th>
                                  <th>Half 3</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <td>
                                    {MatchFormat[match.info.matchFormat]
                                      .toLowerCase()
                                      .includes('single')
                                      ? 'Player 1'
                                      : 'Team 1'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[0]
                                      ?.team1Score || '-'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[1]
                                      ?.team1Score || '-'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[2]
                                      ?.team1Score || '-'}
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    {MatchFormat[match.info.matchFormat]
                                      .toLowerCase()
                                      .includes('single')
                                      ? 'Player 2'
                                      : 'Team 2'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[0]
                                      ?.team2Score || '-'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[1]
                                      ?.team2Score || '-'}
                                  </td>
                                  <td>
                                    {match.score.matchScoreDetails?.[2]
                                      ?.team2Score || '-'}
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        )}
                      </div>
                    </Card>
                  </Link>
                ))
              )}
            </Card>
          </Col>
        </Row>
      </div>

      {/* Join Match Modal */}
      <Modal
        title="Join Match"
        visible={isModalVisible}
        onCancel={handleCancel}
        centered
        footer={[
          <Button key="cancel" onClick={handleCancel}>
            Cancel
          </Button>,
          <Button key="join" type="primary" onClick={handleJoinMatch}>
            Join Match
          </Button>,
        ]}
      >
        <p>Do you want to join this match?</p>
      </Modal>
    </div>
  );
};

export default MyProfile;
