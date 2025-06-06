import { useEndMatch } from '@src/modules/Match/hooks/useEndMatch';
import {
  Alert,
  Badge,
  Button,
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
  TrophyOutlined,
} from '@ant-design/icons';
import { useState } from 'react';

const { Text, Title } = Typography;
const { Step } = Steps;

interface ScoreSubmissionModalProps {
  open: boolean;
  onClose: () => void;
  matchId: string;
}

export const CustomScoreSubmissionModal = ({
  open,
  onClose,
  matchId,
}: ScoreSubmissionModalProps) => {
  const [form] = Form.useForm();
  const [note, setNote] = useState('');
  const [currentStep, setCurrentStep] = useState(0);
  const { mutate: endMatch, isPending: isEnding } = useEndMatch();

  const [scoringComplete, setScoringComplete] = useState(false);

  const handleSubmit = async () => {
    try {
      const { team1score, team2score } = await form.validateFields();
      setScoringComplete(true);
      setCurrentStep(1);
    } catch (error) {
      // Form validation error
    }
  };

  const handleEndMatch = () => {
    const values = form.getFieldsValue();
    endMatch({
      data: {
        matchId: +matchId,
        team1Score: values.team1score,
        team2Score: values.team2score,
        log: note,
      },
    });
    onClose();
  };

  return (
    <Modal
      open={open}
      onCancel={onClose}
      title={
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <TrophyOutlined style={{ color: '#faad14', fontSize: '20px' }} />
          <span>Match Score Submission</span>
        </div>
      }
      footer={null}
      destroyOnClose
      width={600}
    >
      {/* Process Steps */}
      <Steps current={currentStep} size="small" style={{ marginBottom: 24 }}>
        <Step
          title="Enter Scores"
          icon={currentStep === 0 ? <LoadingOutlined /> : <EditOutlined />}
        />
        <Step
          title="Finalize Result"
          icon={
            currentStep === 1 ? <LoadingOutlined /> : <CheckCircleOutlined />
          }
        />
      </Steps>

      {/* Score Submission Panel */}
      {currentStep === 0 && (
        <Card
          title={<Text strong>Score Submission</Text>}
          style={{ marginBottom: 16 }}
          type="inner"
        >
          <Form form={form} layout="vertical">
            <div style={{ display: 'flex', gap: 16 }}>
              <Form.Item
                name="team1score"
                label="Team 1 Score"
                rules={[
                  { required: true, message: 'Please enter Team 1 score' },
                ]}
                style={{ flex: 1 }}
              >
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
              <Form.Item
                name="team2score"
                label="Team 2 Score"
                rules={[
                  { required: true, message: 'Please enter Team 2 score' },
                ]}
                style={{ flex: 1 }}
              >
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
            </div>
            <Button
              type="primary"
              onClick={handleSubmit}
              block
              icon={<EditOutlined />}
            >
              Continue to Submit
            </Button>
          </Form>
        </Card>
      )}

      {/* Final Submission */}
      {currentStep === 1 && (
        <Card title="Finalize Match Result" type="inner">
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
              <Title level={4}>{`Team 1: ${form.getFieldValue(
                'team1score'
              )}`}</Title>
              <Title level={4}>{`Team 2: ${form.getFieldValue(
                'team2score'
              )}`}</Title>
            </div>
          </div>

          <Space direction="vertical" style={{ width: '100%' }}>
            <div>
              <Text strong>Add Notes (Optional)</Text>
              <Input.TextArea
                rows={3}
                placeholder="Add any notes about the match (remarkable moments, etc.)"
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

            <Button type="default" block onClick={() => setCurrentStep(0)}>
              Back to Edit Scores
            </Button>
          </Space>
        </Card>
      )}
    </Modal>
  );
};
