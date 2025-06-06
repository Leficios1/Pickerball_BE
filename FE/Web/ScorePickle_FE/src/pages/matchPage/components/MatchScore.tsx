import {
  Collapse,
  Typography,
  Space,
  Spin,
  Alert,
  Card,
  Timeline,
  Tag,
  Row,
  Col,
} from 'antd';
import type { CollapseProps } from 'antd';
import {
  LogEntry,
  useGetMatchRealTime,
} from '@src/modules/Match/hooks/useGetMatchRealTime';
import { ClockCircleOutlined } from '@ant-design/icons';

const { Title, Text } = Typography;

interface MatchCollapseProps {
  matchId: number;
}

export function MatchScore({ matchId }: MatchCollapseProps) {
  const { logs, isLoading, error } = useGetMatchRealTime(matchId);

  if (isLoading) {
    return (
      <div style={{ textAlign: 'center', padding: '2rem' }}>
        <Spin tip="⏳ Updating score ..." />
      </div>
    );
  }

  if (error) {
    return (
      <Alert
        message="Some error occured when loading score"
        description={error.message}
        type="error"
        showIcon
      />
    );
  }

  if (Object.keys(logs).length === 0) {
    return <Text type="secondary">No score found.</Text>;
  }

  const items: CollapseProps['items'] = Object.entries(logs).map(
    ([roundKey, roundLogs]) => {
      const round = roundKey.replace('round_', '');
      const sortedEntries = [...roundLogs].sort(
        (a, b) =>
          new Date(a.timestamp).getTime() - new Date(b.timestamp).getTime()
      );
      const team1Entries = sortedEntries.filter((log) => log.team === 1);
      const team2Entries = sortedEntries.filter((log) => log.team === 2);
      const team1Score = team1Entries.reduce((sum, log) => sum + log.points, 0);
      const team2Score = team2Entries.reduce((sum, log) => sum + log.points, 0);

      const scoreSummary = `Đội 1: ${team1Score} - Đội 2: ${team2Score}`;

      const renderTimeline = (entries: LogEntry[]) => (
        <Timeline
          style={{ maxHeight: '200px', overflowY: 'auto', paddingTop: 20 }}
        >
          {entries.map((log, idx) => (
            <Timeline.Item
              key={idx}
              color={log.team === 1 ? 'blue' : 'orange'}
              dot={
                log.points > 0 ? undefined : (
                  <ClockCircleOutlined style={{ fontSize: 16 }} />
                )
              }
            >
              <Space>
                <Tag color={log.team === 1 ? 'blue' : 'orange'}>
                  Team {log.team}
                </Tag>
                <Text type={log.points > 0 ? 'success' : 'danger'}>
                  {log.points > 0 ? `+${log.points}` : log.points}
                </Text>
                <Text type="secondary">
                  {new Date(log.timestamp).toLocaleString()}
                </Text>
              </Space>
            </Timeline.Item>
          ))}
        </Timeline>
      );

      return {
        key: roundKey,
        label: (
          <Title
            level={4}
            style={{
              margin: 0,
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
            }}
          >
            <div>Round {round}</div>
            <div style={{ flexGrow: 1, textAlign: 'center' }}>
              {scoreSummary}
            </div>
          </Title>
        ),
        children: (
          <Card bordered className="mt-5">
            <Row gutter={16}>
              <Col span={12} style={{ background: 'rgba(254, 226, 171, 0.3)' }}>
                <Title level={5} style={{ textAlign: 'center' }}>
                  Team 1
                </Title>
                {renderTimeline(team1Entries)}
              </Col>
              <Col span={12} style={{ background: 'rgba(171, 219, 254, 0.3)' }}>
                <Title level={5} style={{ textAlign: 'center' }}>
                  Team 2
                </Title>
                {renderTimeline(team2Entries)}
              </Col>
            </Row>
          </Card>
        ),
      };
    }
  );

  return <Collapse accordion bordered={false} items={items || []} />;
}
