import {
  CalendarOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  EditOutlined,
  CopyOutlined,
  ExclamationCircleOutlined,
  InfoCircleOutlined,
  PlayCircleOutlined,
  PlusCircleOutlined,
  SaveOutlined,
  StopOutlined,
  TeamOutlined,
  TrophyOutlined,
  UserOutlined,
  EnvironmentOutlined,
} from '@ant-design/icons';
import { useGetMatchDetail } from '@src/modules/Match/hooks/useGetMatchDetail';
import { useJoinMatch } from '@src/modules/Match/hooks/useJoinMatch';
import {
  MatchCategory,
  MatchFormat,
  MatchStatus,
} from '@src/modules/Match/models';
import { RootState } from '@src/redux/store';
import {
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Divider,
  Empty,
  Form,
  Image,
  Input,
  message,
  Modal,
  notification,
  Row,
  Skeleton,
  Space,
  Tag,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { motion } from 'framer-motion';
import { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import { MatchScore } from './components/MatchScore';
import Paragraph from 'antd/es/typography/Paragraph';
import { useUpdateMatch } from '@src/modules/Match/hooks/useUpdateMatch';
import './styles/matchDetail.css';
import { MatchConfirmationModal } from './components/MatchConfirmationModal';
import { useVenueById } from '@src/modules/Venues/hooks/useGetVenueById';
import { CustomScoreSubmissionModal } from './components/CustomScoreSubmissionModal';

const { Text, Title } = Typography;
const { TextArea } = Input;

const MotionRow = motion(Row);
const MotionCard = motion(Card);
const MotionCol = motion(Col);

export default function MatchDetails() {
  const WLColors: Record<number, string> = {
    1: 'green',
    2: '#ff4d4f',
  };
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const [isScoreModalVisible, setIsScoreModalVisible] = useState(false);
  const [isCustomScoreModalVisible, setIsCustomScoreModalVisible] =
    useState(false);
  const matchId = Number(id || 0);
  const { data, isLoading, refetch } = useGetMatchDetail(matchId);
  const { data: venue } = useVenueById(data?.venueId ?? 0);
  const { mutate: joinMatch, isPending: isJoining } = useJoinMatch();
  const { mutate: updateMatchMutation, isPending: isUpdating } =
    useUpdateMatch();

  const [isModalVisible, setIsModalVisible] = useState(false);
  const [joiningPosition, setJoiningPosition] = useState<number>(0);
  const [isEditing, setIsEditing] = useState(false);
  const [form] = Form.useForm();

  const user = useSelector((state: RootState) => state.auth.user);
  const isCurrentUserRoomOwner = user?.id === data?.roomOwner ? true : false;

  // Initialize form with match data when available
  useEffect(() => {
    if (data) {
      form.setFieldsValue({
        description: data.description,
        status: data.status,
      });
    }
  }, [data, form]);

  if (isLoading) {
    return (
      <Card className="container mt-4 loading-card">
        <Skeleton active avatar paragraph={{ rows: 6 }} />
      </Card>
    );
  }

  if (!data) {
    return (
      <Card className="container mt-4">
        <Empty
          description="Match not found"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        />
      </Card>
    );
  }

  const isCompetitive = data.matchCategory === MatchCategory.Competitive;
  const isSingleMatch = MatchFormat[data.matchFormat]
    .toLowerCase()
    .includes('single');

  const statusColorMap: Record<
    number,
    'error' | 'processing' | 'success' | 'warning' | 'default'
  > = {
    0: 'processing', // Pending
    1: 'success', // Active
    2: 'warning', // In Progress
    3: 'error', // Cancelled
    4: 'default', // Completed
  };
  const statusColor:
    | 'error'
    | 'processing'
    | 'success'
    | 'warning'
    | 'default' = statusColorMap[data.status] || 'default';

  const handleOnClick = (position: number) => {
    if (user?.id === undefined) {
      message.info('You have to login to join this match');
      navigate('/auth/signin');
    }
    setJoiningPosition(position);
    setIsModalVisible(true);
  };

  const handleCancel = () => setIsModalVisible(false);

  const handleJoinMatch = () => {
    const payload = {
      matchId: matchId,
      userJoinId: user?.id ?? 0,
      position: joiningPosition,
    };

    joinMatch(
      { data: payload },
      {
        onSuccess: () => {
          notification.success({
            message: 'Joined Successfully',
            description: `You've been added to ${
              joiningPosition <= 2 ? 'Team 1' : 'Team 2'
            }, position ${joiningPosition % 2 === 0 ? 2 : 1}.`,
          });
          refetch();
        },
      }
    );

    setIsModalVisible(false);
  };

  const handleEdit = () => {
    setIsEditing(true);
  };

  const handleUpdateMatch = (values: any) => {
    // Only allow specific status transitions
    let canUpdateStatus = false;
    const currentStatus = data.status;
    const newStatus = parseInt(values.status);

    if (
      currentStatus === MatchStatus.Scheduled &&
      (newStatus === MatchStatus.Ongoing || newStatus === MatchStatus.Disabled)
    ) {
      canUpdateStatus = true;
    } else if (
      currentStatus === MatchStatus.Ongoing &&
      newStatus === MatchStatus.Completed
    ) {
      canUpdateStatus = true;
    }

    // If trying to update to an invalid status, show error
    if (currentStatus !== newStatus && !canUpdateStatus) {
      notification.error({
        message: 'Invalid Status Change',
        description: `Cannot change status from ${MatchStatus[currentStatus]} to ${MatchStatus[newStatus]}.`,
      });
      return;
    }

    // Prepare update payload
    const updatedData = {
      id: matchId,
      description: values.description,
      status: newStatus,
    };

    updateMatchMutation(
      {
        data: updatedData,
        id: data.id,
      },
      {
        onSuccess: () => {
          notification.success({
            message: 'Match Updated',
            description: 'Match details have been updated successfully.',
          });
          setIsEditing(false);
          refetch();
        },
        onError: (error) => {
          notification.error({
            message: 'Update Failed',
            description: error.message || 'Failed to update match details.',
          });
        },
      }
    );
  };

  const renderPlayer = (player: any, position: number) => {
    if (player) {
      return (
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.3 }}
          key={player.id}
          className="text-center mb-3"
        >
          <Badge.Ribbon
            text={
              <Space>
                <UserOutlined />
                <span>Player {position}</span>
              </Space>
            }
            color={position <= 2 ? '#1890ff' : '#f5222d'}
          >
            <Card bordered={false} className="player-card">
              <Avatar
                src={player.avatarUrl}
                size={64}
                icon={<UserOutlined />}
              />
              <div className="mt-3">
                <Text strong>{`${player.firstName} ${player.lastName}`}</Text>
                {player.rank && (
                  <div>
                    <Tag color="gold">{player.rank}</Tag>
                  </div>
                )}
              </div>
            </Card>
          </Badge.Ribbon>
        </motion.div>
      );
    } else {
      return (
        <motion.div
          whileHover={{ scale: 1.05 }}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.3 }}
          className="text-center mb-3"
        >
          <Card
            hoverable
            bordered={false}
            className={`empty-player-card ${position <= 2 ? 'team1' : 'team2'}`}
            onClick={() => handleOnClick(position)}
          >
            <PlusCircleOutlined style={{ fontSize: 64 }} />
            <div className="mt-2">
              <Text type="secondary">Join as Player</Text>
              <div className="join-tag">
                <Tag color={position <= 2 ? 'blue' : 'red'}>
                  Team {position <= 2 ? '1' : '2'}, Position{' '}
                  {position % 2 === 0 ? 2 : 1}
                </Tag>
              </div>
            </div>
          </Card>
        </motion.div>
      );
    }
  };

  const renderEditableInfo = () => {
    if (isEditing) {
      return (
        <Form
          form={form}
          layout="vertical"
          onFinish={handleUpdateMatch}
          className="edit-form"
        >
          <Form.Item
            name="description"
            label="Description"
            rules={[{ required: true, message: 'Please enter a description' }]}
          >
            <TextArea rows={3} placeholder="Enter match description" />
          </Form.Item>

          <div className="form-actions">
            <Button
              onClick={() => setIsEditing(false)}
              className="mr-2"
              icon={<CloseCircleOutlined />}
            >
              Cancel
            </Button>
            <Button
              type="primary"
              htmlType="submit"
              loading={isUpdating}
              icon={<SaveOutlined />}
            >
              Save Changes
            </Button>
          </div>
        </Form>
      );
    }

    return (
      <>
        <Row gutter={[16, 24]}>
          <Col xs={24} md={12}>
            <Space direction="vertical" size="middle" style={{ width: '100%' }}>
              <div className="info-item">
                <CopyOutlined className="info-icon" />
                <Text>{data.description || 'No description'}</Text>
              </div>

              <div className="info-item">
                <CalendarOutlined className="info-icon" />
                <Text>
                  {dayjs(data.matchDate).format('MMMM D, YYYY [at] h:mm A')}
                </Text>
              </div>
            </Space>
          </Col>

          <Col xs={24} md={12}>
            <Space direction="vertical" size="middle" style={{ width: '100%' }}>
              <div className="info-item">
                <TeamOutlined className="info-icon" />
                <Text>Format: {MatchFormat[data.matchFormat]}</Text>
              </div>

              <div className="info-item">
                <TrophyOutlined className="info-icon" />
                <Text>
                  Type:{' '}
                  {data.matchCategory === MatchCategory.Custom
                    ? 'Friendly'
                    : MatchCategory.Tournament
                      ? 'Tournament'
                      : 'Competitive'}
                </Text>
              </div>
            </Space>
          </Col>
        </Row>

        {isCurrentUserRoomOwner && (
          <div className="edit-action">
            <Button
              type="primary"
              icon={<EditOutlined />}
              onClick={handleEdit}
              className="edit-button"
            >
              Edit Details
            </Button>
          </div>
        )}

        {venue && (
          <>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.5 }}
            >
              <Divider orientation="left" className="section-divider">
                <Space>
                  <EnvironmentOutlined />
                  <span className="divider-title">Venue</span>
                </Space>
              </Divider>
            </motion.div>
            <Row justify="start">
              <Card style={{ width: '500px' }}>
                <Row>
                  <Col
                    xs={16}
                    md={12}
                    style={{ display: 'flex', justifyContent: 'end' }}
                  >
                    <Image src={venue?.urlImage} alt={venue?.name} />
                  </Col>
                  <Col
                    xs={8}
                    md={12}
                    style={{
                      display: 'flex',
                      justifyContent: 'start',
                      paddingLeft: '16px',
                      flexDirection: 'column',
                    }}
                  >
                    <Text style={{ color: 'cadetblue', fontWeight: 'bold' }}>
                      Venue name:
                    </Text>{' '}
                    • {venue.name}
                    <Text style={{ color: 'cadetblue', fontWeight: 'bold' }}>
                      Address:
                    </Text>{' '}
                    • {venue.address}
                  </Col>
                </Row>
              </Card>
            </Row>
          </>
        )}
      </>
    );
  };

  const renderActions = () => {
    // Return different buttons based on the match status
    switch (data.status) {
      case MatchStatus.Scheduled:
        return (
          <div
            className="status-action-buttons"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
            }}
          >
            <Button
              type="primary"
              icon={<PlayCircleOutlined />}
              onClick={() => handleStatusChange(MatchStatus.Ongoing)}
              className="action-button start-button"
              style={{ border: '1px solid rgb(86, 106, 159)' }}
            >
              Start Match
            </Button>
            {data.matchCategory !== MatchCategory.Tournament &&
              (data.player1?.id === user?.id ||
                data.player2?.id === user?.id ||
                data.player3?.id === user?.id ||
                data.player4?.id === user?.id) && (
                <Button
                  danger
                  icon={<StopOutlined />}
                  onClick={() => handleStatusChange(MatchStatus.Disabled)}
                  className="action-button disable-button"
                >
                  Disable Match
                </Button>
              )}
          </div>
        );

      case MatchStatus.Ongoing:
        // Don't show any actions for Tournament matches
        if (data.matchCategory === MatchCategory.Tournament) {
          return null;
        }

        // For Competitive matches use the MatchConfirmationModal
        if (data.matchCategory === MatchCategory.Competitive) {
          return (
            <div className="status-action-buttons">
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                  marginBottom: 16,
                }}
              >
                {isCurrentUserRoomOwner && (
                  <Button
                    type="primary"
                    icon={<TrophyOutlined />}
                    onClick={() => setIsScoreModalVisible(true)}
                  >
                    Manage Score
                  </Button>
                )}
              </div>
            </div>
          );
        }

        // For Custom matches use the new ScoreSubmissionModal
        return (
          <div className="status-action-buttons">
            <div
              style={{
                display: 'flex',
                justifyContent: 'end',
                marginBottom: 16,
              }}
            >
              {isCurrentUserRoomOwner && (
                <Button
                  type="primary"
                  icon={<TrophyOutlined />}
                  onClick={() => setIsCustomScoreModalVisible(true)}
                >
                  Submit Score
                </Button>
              )}
            </div>
          </div>
        );

      default:
        return null; // No actions for Completed or Disabled matches
    }
  };

  // Helper function to update match status
  const handleStatusChange = (newStatus: MatchStatus) => {
    const isSingleMatch = MatchFormat[data.matchFormat]
      .toLowerCase()
      .includes('single');

    // Validate player count before allowing status update to Ongoing
    if (newStatus === MatchStatus.Ongoing) {
      const requiredPlayers = isSingleMatch ? 2 : 4;
      const actualPlayers = [
        data.player1,
        data.player2,
        data.player3,
        data.player4,
      ].filter(Boolean).length;

      if (actualPlayers < requiredPlayers) {
        Modal.confirm({
          title: 'Not Enough Players',
          icon: <ExclamationCircleOutlined />,
          content: `This match requires at least ${requiredPlayers} players to start. Do you want to disable it instead?`,
          okText: 'Disable Match',
          cancelText: 'Cancel',
          onOk() {
            const disabledData = {
              id: matchId,
              description: data.description,
              status: MatchStatus.Disabled,
            };

            updateMatchMutation(
              { data: disabledData, id: data.id },
              {
                onSuccess: () => {
                  notification.success({
                    message: 'Match Disabled',
                    description:
                      'The match has been disabled due to insufficient players.',
                  });
                  refetch();
                },
                onError: (error) => {
                  notification.error({
                    message: 'Failed to Disable',
                    description:
                      error.message || 'Could not update match status.',
                  });
                },
              }
            );
          },
        });

        return;
      }
    }

    // Confirmation messages
    const statusMessages = {
      [MatchStatus.Ongoing]: {
        title: 'Start Match',
        content:
          'Are you sure you want to start this match? This will mark it as in progress.',
      },
      [MatchStatus.Disabled]: {
        title: 'Disable Match',
        content:
          'Are you sure you want to disable this match? This cannot be undone.',
      },
      [MatchStatus.Completed]: {
        title: 'Complete Match',
        content: 'Are you sure you want to mark this match as completed?',
      },
    };

    Modal.confirm({
      title: statusMessages[newStatus].title,
      content: statusMessages[newStatus].content,
      icon: <ExclamationCircleOutlined />,
      onOk() {
        const updatedData = {
          id: matchId,
          description: data.description,
          status: newStatus,
        };

        updateMatchMutation(
          { data: updatedData, id: data.id },
          {
            onSuccess: () => {
              notification.success({
                message: 'Status Updated',
                description: `Match status has been updated to ${MatchStatus[newStatus]}.`,
              });
              refetch();
            },
            onError: (error) => {
              notification.error({
                message: 'Status Update Failed',
                description: error.message || 'Failed to update match status.',
              });
            },
          }
        );
      },
      okText: 'Yes',
      cancelText: 'No',
    });
  };

  return (
    <>
      <MotionRow
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="container mt-4 "
        style={{
          display: 'flex',
          justifyContent: 'end',
        }}
      >
        {renderActions()}
      </MotionRow>

      <MotionRow
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="container mt-4"
      >
        <Col span={24}>
          <MotionCard
            title={
              <Row justify="space-between" align="middle">
                <Col>
                  <Title level={3} style={{ margin: 0 }}>
                    {data.title}
                  </Title>
                </Col>
                <Col>
                  <Badge status={statusColor} text={MatchStatus[data.status]} />
                </Col>
              </Row>
            }
            className="match-detail-card"
          >
            <Divider orientation="left" className="section-divider">
              <Space>
                <TeamOutlined />
                <span className="divider-title">Teams</span>
              </Space>
            </Divider>

            <Row
              gutter={16}
              justify="center"
              align="middle"
              style={{ marginBottom: '16px' }}
            >
              {/* Team 1 */}
              <MotionCol
                xs={24}
                md={11}
                initial={{ x: -50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ duration: 0.5, delay: 0.2 }}
              >
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                  }}
                >
                  <Card
                    title={
                      <div className="team-header team1-header">
                        <TeamOutlined className="team-icon" />
                        <Text strong>{data.teams[0]?.name || 'Team 1'}</Text>
                      </div>
                    }
                    className="team-card team1-card"
                    bordered={false}
                    style={{ background: '#fff', flex: 1 }}
                  >
                    {isSingleMatch ? (
                      renderPlayer(data.player1, 1)
                    ) : (
                      <>
                        {renderPlayer(data.player1, 1)}
                        {renderPlayer(data.player2, 2)}
                      </>
                    )}
                  </Card>
                  <Tag
                    color={
                      (data.team1Score ?? 0) > (data.team2Score ?? 0)
                        ? WLColors[1]
                        : WLColors[0]
                    }
                    style={{ fontSize: '30px', marginLeft: '8px' }}
                    className="match-type ms-2 p-2"
                  >
                    {data.team1Score ?? 0}
                  </Tag>
                </div>
              </MotionCol>

              {/* VS */}
              <Col xs={24} md={2} className="text-center">
                <motion.div
                  initial={{ scale: 0, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  transition={{
                    duration: 0.5,
                    delay: 0.4,
                    type: 'spring',
                    stiffness: 200,
                  }}
                  className="vs-container"
                  whileHover={{ scale: 1.1 }}
                >
                  <Text className="vs-text">VS</Text>
                </motion.div>
              </Col>

              {/* Team 2 */}
              <MotionCol
                xs={24}
                md={11}
                initial={{ x: 50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ duration: 0.5, delay: 0.3 }}
              >
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                  }}
                >
                  <Tag
                    color={
                      (data.team2Score ?? 0) > (data.team1Score ?? 0)
                        ? WLColors[1]
                        : WLColors[0]
                    }
                    style={{ fontSize: '30px', marginRight: '8px' }}
                    className="match-type ms-2 p-2"
                  >
                    {data.team2Score ?? 0}
                  </Tag>
                  <Card
                    title={
                      <div className="team-header team2-header">
                        <TeamOutlined className="team-icon" />
                        <Text strong>{data.teams[1]?.name || 'Team 2'}</Text>
                      </div>
                    }
                    className="team-card team2-card"
                    bordered={false}
                    style={{ background: '#fff', flex: 1 }}
                  >
                    {isSingleMatch ? (
                      renderPlayer(data.player3, 3)
                    ) : (
                      <>
                        {renderPlayer(data.player3, 3)}
                        {renderPlayer(data.player4, 4)}
                      </>
                    )}
                  </Card>
                </div>
              </MotionCol>
            </Row>
            {/* Editable information section */}
            {renderEditableInfo()}

            {/* Only show scores for non-competitive matches */}
            {!isCompetitive && (
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.5 }}
              >
                <Divider orientation="left" className="section-divider">
                  <Space>
                    <TrophyOutlined />
                    <span className="divider-title">Scores</span>
                  </Space>
                </Divider>
                <MatchScore matchId={matchId} />
              </motion.div>
            )}

            {/* For competitive matches - show info message */}
            {isCompetitive && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 0.5, delay: 0.5 }}
                className="mt-4"
              >
                <Card className="info-card">
                  <Space align="start">
                    <InfoCircleOutlined className="info-icon-large" />
                    <div>
                      <Text strong className="competitive-title">
                        Competitive Match
                      </Text>
                      <Paragraph className="competitive-info">
                        Scores for competitive matches are managed through the
                        matchmaking system. Players need to confirm scores after
                        the match is completed.
                      </Paragraph>
                      <div className="competitive-badges">
                        <Tag color="gold" icon={<TrophyOutlined />}>
                          Ranking Points
                        </Tag>
                        <Tag color="cyan" icon={<TeamOutlined />}>
                          Leaderboard Impact
                        </Tag>
                      </div>
                    </div>
                  </Space>
                </Card>
              </motion.div>
            )}
          </MotionCard>
        </Col>

        {/* Join Match Modal */}
        <Modal
          title={
            <div className="modal-title">
              <TeamOutlined className="modal-icon" />
              Join Match
            </div>
          }
          open={isModalVisible}
          onCancel={handleCancel}
          className="join-match-modal"
          footer={[
            <Button key="no" onClick={handleCancel}>
              Cancel
            </Button>,
            <Button
              key="yes"
              type="primary"
              loading={isJoining}
              onClick={handleJoinMatch}
              icon={<CheckCircleOutlined />}
            >
              Confirm Join
            </Button>,
          ]}
        >
          <div className="modal-content">
            <div
              className="modal-F-icon"
              style={{
                background: joiningPosition <= 2 ? '#e6f7ff' : '#fff1f0',
                color: joiningPosition <= 2 ? '#1890ff' : '#f5222d',
              }}
            >
              <TeamOutlined />
            </div>

            <Title level={4} className="modal-question">
              Ready to join this match?
            </Title>

            <Space align="center" className="modal-detail">
              <Badge color={joiningPosition <= 2 ? 'blue' : 'red'} />
              <Text>
                You'll join{' '}
                <strong>{joiningPosition <= 2 ? 'Team 1' : 'Team 2'}</strong>,
                as Player {joiningPosition % 2 === 0 ? 2 : 1}
              </Text>
            </Space>

            <div className="modal-match-detail">
              <Tag color="blue" icon={<CalendarOutlined />}>
                {dayjs(data.matchDate).format('MMM D, YYYY')}
              </Tag>
              <Tag color="purple" icon={<TeamOutlined />}>
                {MatchFormat[data.matchFormat]}
              </Tag>
            </div>
          </div>
        </Modal>
      </MotionRow>
      <MatchConfirmationModal
        open={isScoreModalVisible}
        onClose={() => setIsScoreModalVisible(false)}
        matchId={matchId.toString()}
        isRoomOwner={isCurrentUserRoomOwner}
        teamName={(() => {
          const isTeam1 =
            user?.id === data?.player1?.id || user?.id === data?.player2?.id;
          return isTeam1 ? 'Team 1' : 'Team 2';
        })()}
      />
      <CustomScoreSubmissionModal
        open={isCustomScoreModalVisible}
        onClose={() => setIsCustomScoreModalVisible(false)}
        matchId={matchId.toString()}
      />
    </>
  );
}
