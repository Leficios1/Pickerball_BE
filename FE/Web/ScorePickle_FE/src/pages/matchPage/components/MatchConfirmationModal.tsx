import { useEndMatch } from '@src/modules/Match/hooks/useEndMatch';
import { useMatchSubmission } from '@src/modules/Match/hooks/useMatchSubmission';
import {
  Alert,
  Badge,
  Button,
  Divider,
  Form,
  Input,
  InputNumber,
  Modal,
  Space,
  Steps,
  Typography,
  Card,
} from 'antd';
import {
  CheckCircleOutlined,
  EditOutlined,
  LoadingOutlined,
  TeamOutlined,
  TrophyOutlined,
} from '@ant-design/icons';
import { useEffect, useState } from 'react';

const { Text, Title } = Typography;
const { Step } = Steps;

interface MatchModalProps {
  open: boolean;
  onClose: () => void;
  matchId: string;
  teamName: 'Team 1' | 'Team 2';
  isRoomOwner: boolean;
}

export const MatchConfirmationModal = ({
  open,
  onClose,
  matchId,
  teamName,
  isRoomOwner,
}: MatchModalProps) => {
  const { match, createDefaultRecord, submitScore, acceptScore } =
    useMatchSubmission(matchId);
  const [form] = Form.useForm();
  const [note, setNote] = useState('');
  const { mutate: endMatch, isPending: isEnding } = useEndMatch();

  // Current step tracking for the process flow
  const [currentStep, setCurrentStep] = useState(0);

  useEffect(() => {
    if (open) createDefaultRecord();
  }, [open]);

  useEffect(() => {
    // Update the current step based on the match state
    if (!match) {
      setCurrentStep(0); // Initial state
    } else if (match.isSend) {
      setCurrentStep(1); // Score submitted
      if (match.accepted_1 || match.accepted_2) {
        setCurrentStep(2); // At least one team accepted
      }
      if (match.accepted_1 && match.accepted_2) {
        setCurrentStep(3); // Both teams accepted
      }
    }
  }, [match]);

  const handleSubmit = async () => {
    const { team1score, team2score } = await form.validateFields();
    await submitScore(team1score, team2score);
  };

  const handleAccept = async () => {
    await acceptScore(teamName);
  };

  const handleEndMatch = () => {
    if (!match) return;
    endMatch({
      data: {
        matchId: +matchId,
        team1Score: match.submissions.team1score,
        team2Score: match.submissions.team2score,
        log: note,
      },
    });
    onClose();
  };

  const canEndMatch = match?.accepted_1 && match?.accepted_2;
  const otherTeam = teamName === 'Team 1' ? 'Team 2' : 'Team 1';
  const otherTeamAccepted =
    teamName === 'Team 1' ? match?.accepted_2 : match?.accepted_1;
  const myTeamAccepted =
    teamName === 'Team 1' ? match?.accepted_1 : match?.accepted_2;

  return (
    <Modal
      open={open}
      onCancel={onClose}
      title={
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <TrophyOutlined style={{ color: '#faad14', fontSize: '20px' }} />
          <span>Match Score Confirmation</span>
        </div>
      }
      footer={null}
      destroyOnClose
      width={600}
    >
      {/* Process Steps */}
      <Steps current={currentStep} size="small" style={{ marginBottom: 24 }}>
        <Step
          title="Submit Scores"
          icon={currentStep === 0 ? <LoadingOutlined /> : <EditOutlined />}
        />
        <Step
          title="Team Confirmations"
          icon={currentStep === 1 ? <LoadingOutlined /> : <TeamOutlined />}
        />
        <Step
          title="Complete"
          icon={
            currentStep === 3 ? <CheckCircleOutlined /> : <TrophyOutlined />
          }
        />
      </Steps>

      {/* Score Submission Panel (Room Owner Only) */}
      {isRoomOwner && (
        <Card
          title={<Text strong>Score Submission</Text>}
          style={{ marginBottom: 16 }}
          type="inner"
          extra={
            match?.isSend ? (
              <Badge status="success" text="Submitted" />
            ) : (
              <Badge status="processing" text="Pending" />
            )
          }
        >
          <Form
            form={form}
            layout="vertical"
            initialValues={match?.submissions}
          >
            <div style={{ display: 'flex', gap: 16 }}>
              <Form.Item
                name="team1score"
                label="Team 1 Score"
                rules={[{ required: true }]}
                style={{ flex: 1 }}
              >
                <InputNumber
                  min={0}
                  style={{ width: '100%' }}
                  disabled={match?.isSend}
                />
              </Form.Item>
              <Form.Item
                name="team2score"
                label="Team 2 Score"
                rules={[{ required: true }]}
                style={{ flex: 1 }}
              >
                <InputNumber
                  min={0}
                  style={{ width: '100%' }}
                  disabled={match?.isSend}
                />
              </Form.Item>
            </div>
            {!match?.isSend && (
              <Button
                type="primary"
                onClick={handleSubmit}
                block
                icon={<EditOutlined />}
              >
                Submit Score
              </Button>
            )}
            {match?.isSend && (
              <Button disabled type="default" block>
                Scores Submitted
              </Button>
            )}
          </Form>
        </Card>
      )}

      {/* Confirmation Status Cards */}
      {match?.isSend && (
        <Card
          title="Score Confirmations"
          type="inner"
          style={{ marginBottom: 16 }}
        >
          <div style={{ marginBottom: 16 }}>
            <Text>Final Score:</Text>
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                marginTop: 8,
                padding: '12px 16px',
                background: '#f5f5f5',
                borderRadius: 8,
              }}
            >
              <Title
                level={4}
              >{`Team 1: ${match?.submissions.team1score}`}</Title>
              <Title
                level={4}
              >{`Team 2: ${match?.submissions.team2score}`}</Title>
            </div>
          </div>

          {/* Team Confirmation Status */}
          <Divider plain>Team Confirmations</Divider>
          <Space direction="vertical" style={{ width: '100%' }}>
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                padding: '8px 12px',
                background: teamName === 'Team 1' ? '#e6f7ff' : '#f6f6f6',
                borderRadius: 4,
                border:
                  teamName === 'Team 1'
                    ? '1px solid #91d5ff'
                    : '1px solid #d9d9d9',
              }}
            >
              <Text strong>{teamName} (You)</Text>
              {myTeamAccepted ? (
                <Badge status="success" text="Confirmed" />
              ) : (
                <Button type="primary" size="small" onClick={handleAccept}>
                  Confirm Score
                </Button>
              )}
            </div>

            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                padding: '8px 12px',
                background: teamName === 'Team 2' ? '#e6f7ff' : '#f6f6f6',
                borderRadius: 4,
                border:
                  teamName === 'Team 2'
                    ? '1px solid #91d5ff'
                    : '1px solid #d9d9d9',
              }}
            >
              <Text strong>{otherTeam}</Text>
              {otherTeamAccepted ? (
                <Badge status="success" text="Confirmed" />
              ) : (
                <Badge status="processing" text="Waiting for confirmation" />
              )}
            </div>
          </Space>
        </Card>
      )}

      {/* Final Submission for Room Owner */}
      {canEndMatch && isRoomOwner && (
        <Card
          title="Finalize Match Result"
          type="inner"
          extra={<Badge status="success" text="Both teams confirmed" />}
        >
          <Space direction="vertical" style={{ width: '100%' }}>
            <div>
              <Text strong>Add Notes (Optional)</Text>
              <Input.TextArea
                rows={3}
                placeholder="Add any notes about the match (disputes, remarkable moments, etc.)"
                value={note}
                onChange={(e) => setNote(e.target.value)}
                style={{ marginTop: 8 }}
              />
            </div>

            <Button
              type="primary"
              danger
              block
              loading={isEnding}
              onClick={handleEndMatch}
              icon={<CheckCircleOutlined />}
            >
              End Match & Save Results
            </Button>

            <Alert
              type="warning"
              showIcon
              message="This action is final and will permanently record the match results."
            />
          </Space>
        </Card>
      )}

      {/* Show message for non-owners when scores haven't been submitted yet */}
      {!isRoomOwner && !match?.isSend && (
        <Alert
          type="info"
          showIcon
          message="Waiting for the match owner to submit scores"
          description="Once scores are submitted, you'll be able to confirm them here."
          style={{ marginBottom: 16 }}
        />
      )}
    </Modal>
  );
};
