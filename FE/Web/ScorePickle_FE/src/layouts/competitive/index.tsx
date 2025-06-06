import { useState } from 'react';
import {
  Card,
  Button,
  Typography,
  Badge,
  Avatar,
  Spin,
  notification,
  Tooltip,
  Divider,
  Modal,
} from 'antd';
import {
  SearchOutlined,
  CheckOutlined,
  CloseOutlined,
  TrophyOutlined,
  LoadingOutlined,
  ReloadOutlined,
  ExclamationCircleOutlined,
  FireOutlined,
  TeamOutlined,
} from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import {
  MatchRequest,
  useMatchHub,
} from '@src/modules/SignalR/hooks/useMatchHub';
import './styles.css';

const { Text, Title, Paragraph } = Typography;
const { confirm } = Modal;

interface CompetitiveProps {
  userId: number;
  gender: string;
  city: string;
  ranking: number;
  matchFormat?: number;
  userName?: string;
  userAvatar?: string;
}

const CompetitiveLayout = ({
  userId,
  gender,
  city,
  ranking,
  matchFormat = 1,
  userName = 'Player',
  userAvatar,
}: CompetitiveProps) => {
  const navigate = useNavigate();
  const [isMinimized, setIsMinimized] = useState(false);
  const [status, setStatus] = useState<string>('Idle');
  const [rival, setRival] = useState<any>(null);
  const [roomId, setRoomId] = useState<number | null>(null);
  const [confirmedPlayers, setConfirmedPlayers] = useState<number[]>([]);
  const [, setScoreConfirmed] = useState(false);
  const [, setReadyForNewMatch] = useState(false);

  const { isConnected, findMatch, confirmScore } = useMatchHub({
    onMatchFound: (rival) => {
      setRival(rival);
      setStatus('🎯 Match Found');
      setReadyForNewMatch(false);
      notification.success({
        message: 'Match Found!',
        description: `You've been matched with ${
          rival.fullName || `Player ${rival.userId}`
        }`,
        placement: 'bottomRight',
      });
    },
    onRoomCreated: (id) => {
      setRoomId(id);
      setStatus(`✅ Room Created (ID: ${id})`);
      setReadyForNewMatch(false);
    },
    onRoomCreationFailed: (msg) => {
      setStatus(`❌ Room Creation Failed: ${msg}`);
      setReadyForNewMatch(true);
      notification.error({
        message: 'Room Creation Failed',
        description: msg,
        placement: 'bottomRight',
      });
    },
    onWaiting: () => {
      setStatus('⏳ Waiting for opponent...');
      setReadyForNewMatch(false);
    },
    onPlayerConfirmed: (userId) => {
      setConfirmedPlayers((prev) => [...prev, userId]);
    },
    onScoreConfirmed: () => {
      setScoreConfirmed(true);
      setStatus('🏁 Score confirmed by both players');
      // After 3 seconds, allow player to find a new match
      setTimeout(() => {
        setReadyForNewMatch(true);
      }, 3000);
    },
  });

  // Reset match state for new match
  const resetMatchState = () => {
    setRival(null);
    setRoomId(null);
    setConfirmedPlayers([]);
    setScoreConfirmed(false);
    setStatus('Idle');
  };

  const handleFindMatch = () => {
    resetMatchState();
    const req: MatchRequest = {
      userId,
      gender,
      city,
      ranking,
      matchFormat,
    };
    findMatch(req);
  };

  const handleConfirmScore = () => {
    if (roomId) {
      confirmScore(roomId, userId);
    }
  };

  const handleGoToMatch = () => {
    if (roomId) {
      navigate(`/match-detail/${roomId}`);
    }
  };

  const handleCancelSearch = () => {
    // Here you would add logic to cancel the search via SignalR
    setStatus('Idle');
    notification.info({
      message: 'Search Cancelled',
      description: 'You have cancelled the matchmaking search.',
      placement: 'bottomRight',
    });
  };

  // New function to handle finding a new match when one already exists
  const handleFindNewMatch = () => {
    confirm({
      title: 'Find New Match',
      icon: <ExclamationCircleOutlined />,
      content:
        'Are you sure you want to abandon the current match and find a new one?',
      okText: 'Yes, Find New Match',
      okType: 'primary',
      cancelText: 'No, Stay Here',
      onOk() {
        // Add logic here to cancel existing match if needed
        notification.info({
          message: 'Looking for a new match',
          description: 'Leaving current match to find a new opponent.',
          placement: 'bottomRight',
        });
        handleFindMatch();
      },
    });
  };

  // Matchmaking floating widget
  const renderMatchmakingWidget = () => {
    const renderWidgetContent = () => {
      if (!isConnected) {
        return (
          <div className="matchmaking-connecting">
            <Spin
              indicator={<LoadingOutlined style={{ fontSize: 24 }} spin />}
            />
            <Text type="secondary">Connecting to matchmaking server...</Text>
          </div>
        );
      }

      if (
        status.includes('Waiting') ||
        status === '⏳ Waiting for opponent...'
      ) {
        return (
          <div className="matchmaking-searching">
            <Spin
              indicator={<LoadingOutlined style={{ fontSize: 24 }} spin />}
            />
            <Paragraph>
              <Text strong>Searching for opponents...</Text>
              <br />
              <Text type="secondary">
                Looking for players in {city} with similar ranking
              </Text>
            </Paragraph>
            <Button
              danger
              icon={<CloseOutlined />}
              onClick={handleCancelSearch}
              size="middle"
              className="action-button"
            >
              Cancel Search
            </Button>
          </div>
        );
      }

      if (status.includes('Match Found') || status === '🎯 Match Found') {
        return (
          <div className="matchmaking-found">
            <div className="match-found-icon">
              <TeamOutlined />
            </div>
            <div className="match-players">
              <div className="player">
                <Avatar src={userAvatar} size="large">
                  {userName.charAt(0)}
                </Avatar>
                <Text strong>{userName}</Text>
                <Text type="secondary">Ranking: {ranking}</Text>
              </div>
              <div className="versus-container">
                <Text type="secondary" className="versus-text">
                  VS
                </Text>
              </div>
              <div className="player">
                <Avatar size="large">
                  {(rival?.fullName || 'R').charAt(0)}
                </Avatar>
                <Text strong>
                  {rival?.fullName || `Player ${rival?.userId}`}
                </Text>
                <Text type="secondary">Ranking: {rival?.ranking || '?'}</Text>
              </div>
            </div>
            <Text type="secondary" className="status-text">
              <Spin size="small" /> Preparing match room...
            </Text>

            {/* New Match button */}
            <Button
              onClick={handleFindNewMatch}
              icon={<ReloadOutlined />}
              size="middle"
              className="find-new-match-button"
            >
              Find Different Opponent
            </Button>
          </div>
        );
      }

      if (
        roomId &&
        (status.includes('Room Created') || status.includes('✅ Room Created'))
      ) {
        return (
          <div className="matchmaking-room">
            <Badge.Ribbon text="Room Ready" color="green">
              <div className="room-details">
                <Title level={5}>
                  <TrophyOutlined /> Match Room #{roomId}
                </Title>
                <Divider className="room-divider" />
                <div className="confirmation-section">
                  <Text strong>Match Score Confirmation:</Text>
                  <div className="confirmation-status">
                    <div className="player-confirmation">
                      <Badge
                        status={
                          confirmedPlayers.includes(userId)
                            ? 'success'
                            : 'processing'
                        }
                        text={
                          <Tooltip
                            title={
                              confirmedPlayers.includes(userId)
                                ? "You've confirmed the score"
                                : 'Waiting for your confirmation'
                            }
                          >
                            <Text>{`You ${
                              confirmedPlayers.includes(userId)
                                ? '(Confirmed)'
                                : '(Pending)'
                            }`}</Text>
                          </Tooltip>
                        }
                      />
                    </div>
                    <div className="player-confirmation">
                      <Badge
                        status={
                          rival && confirmedPlayers.includes(rival.userId)
                            ? 'success'
                            : 'processing'
                        }
                        text={
                          <Tooltip
                            title={
                              rival && confirmedPlayers.includes(rival.userId)
                                ? 'Opponent has confirmed'
                                : "Waiting for opponent's confirmation"
                            }
                          >
                            <Text>{`Opponent ${
                              rival && confirmedPlayers.includes(rival.userId)
                                ? '(Confirmed)'
                                : '(Pending)'
                            }`}</Text>
                          </Tooltip>
                        }
                      />
                    </div>
                  </div>
                </div>
                <Divider className="room-divider" />
                <div className="action-buttons">
                  <Button
                    type="primary"
                    onClick={handleGoToMatch}
                    icon={<TrophyOutlined />}
                    block
                    className="action-button"
                  >
                    View Match Details
                  </Button>
                  {/* <Button
                    onClick={handleConfirmScore}
                    icon={<CheckOutlined />}
                    disabled={confirmedPlayers.includes(userId)}
                    block
                    type={
                      confirmedPlayers.includes(userId) ? 'default' : 'primary'
                    }
                    className="action-button"
                  >
                    {confirmedPlayers.includes(userId)
                      ? 'Score Confirmed'
                      : 'Confirm Match Score'}
                  </Button> */}

                  {/* New Find Match button */}
                  {/* <Button
                    onClick={handleFindNewMatch}
                    icon={<FireOutlined />}
                    type="default"
                    block
                    className="find-new-match-button action-button"
                  >
                    Find New Match
                  </Button> */}
                </div>
              </div>
            </Badge.Ribbon>
          </div>
        );
      }

      if (
        status.includes('Score confirmed') ||
        status === '🏁 Score confirmed by both players'
      ) {
        return (
          <div className="matchmaking-score-confirmed">
            <div className="success-icon">✅</div>
            <Text strong style={{ color: 'green' }}>
              Score confirmed by both players!
            </Text>

            <div className="action-buttons-stack">
              <Button
                type="primary"
                onClick={handleGoToMatch}
                icon={<TrophyOutlined />}
                block
                className="action-button"
              >
                View Match Results
              </Button>

              {/* <Button
                onClick={handleFindMatch}
                icon={<SearchOutlined />}
                type="default"
                block
                className="find-new-match-button action-button"
              >
                Find New Match
              </Button> */}
            </div>
          </div>
        );
      }

      // Default idle state
      return (
        <div className="matchmaking-idle">
          <div className="idle-content">
            <TrophyOutlined className="large-trophy-icon" />
            <Text>Ready to play a competitive match?</Text>
          </div>
          <Button
            type="primary"
            icon={<SearchOutlined />}
            onClick={handleFindMatch}
            size="large"
            block
            className="action-button"
          >
            Find Match
          </Button>
        </div>
      );
    };

    return (
      <div className={`matchmaking-widget ${isMinimized ? 'minimized' : ''}`}>
        <Card
          className="matchmaking-card"
          title={
            <div className="card-header">
              <div className="title-section">
                <TrophyOutlined className="trophy-icon" />
                <span>Matchmaking</span>
              </div>
              <div className="header-actions">
                <Button
                  type="text"
                  size="small"
                  onClick={() => setIsMinimized(!isMinimized)}
                  icon={isMinimized ? <SearchOutlined /> : <CloseOutlined />}
                />
              </div>
            </div>
          }
          bordered={true}
        >
          {!isMinimized && (
            <div className="matchmaking-content">{renderWidgetContent()}</div>
          )}
        </Card>
      </div>
    );
  };

  return (
    <>
      {/* Main content */}
      {/* {renderMainContent()} */}

      {/* Floating matchmaking widget */}
      {renderMatchmakingWidget()}
    </>
  );
};

export default CompetitiveLayout;
