import React from 'react';
import {
  Table,
  Card,
  Typography,
  Spin,
  Empty,
  Statistic,
  Row,
  Col,
  Avatar,
} from 'antd';
import { useGetSponsorsByTournamentId } from '@src/modules/Tournament/hooks/useGetSponsorsByTournamentId';
import { motion } from 'framer-motion';
import {
  DollarCircleOutlined,
  TrophyOutlined,
  TeamOutlined,
  GlobalOutlined,
} from '@ant-design/icons';

const { Text } = Typography;

interface DonateProps {
  tournamentId: number;
}

const Donate: React.FC<DonateProps> = ({ tournamentId }) => {
  const {
    data: sponsors,
    isLoading,
    error,
  } = useGetSponsorsByTournamentId(tournamentId);

  // Calculate total donation amount
  const totalDonations =
    sponsors?.reduce((sum, sponsor) => sum + sponsor.donate, 0) || 0;

  const columns = [
    {
      title: 'Sponsors',
      dataIndex: 'name',
      key: 'name',
      render: (name, record) => (
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <Avatar
            src={record.logo}
            size={48}
            style={{ marginRight: 12 }}
            shape="square"
          />
          <div>
            <Text strong>{name}</Text>
            {record.website && (
              <div>
                <a
                  href={record.website}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <GlobalOutlined /> Website
                </a>
              </div>
            )}
          </div>
        </div>
      ),
    },
    {
      title: 'Sponsorship Amount',
      dataIndex: 'donate',
      key: 'donate',
      sorter: (a, b) => a.donate - b.donate,
      render: (amount) => (
        <Text strong style={{ color: '#1890ff' }}>
          ₫{amount.toLocaleString()}
        </Text>
      ),
    },
  ];

  if (isLoading) {
    return (
      <div style={{ textAlign: 'center', padding: '50px' }}>
        <Spin size="large" />
        <p>Loading donation information...</p>
      </div>
    );
  }

  if (error) {
    return (
      <Card>
        <Empty
          description="Error loading sponsors data"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        />
      </Card>
    );
  }

  if (!sponsors || sponsors.length === 0) {
    return (
      <Card title="Tournament Sponsors">
        <Empty
          description="No sponsors found for this tournament"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        />
      </Card>
    );
  }

  // Use minimal animations to ensure content appears
  return (
    <div>
      {/* Donation Summary */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.3 }}
        style={{ marginBottom: 24 }}
      >
        <Card bordered={false}>
          <Row gutter={[24, 24]} justify="space-around">
            <Col xs={24} sm={12} md={8}>
              <Statistic
                title={
                  <Text strong style={{ fontSize: 16 }}>
                    <DollarCircleOutlined
                      style={{ marginRight: 8, color: '#1890ff' }}
                    />
                    Total Sponsorships
                  </Text>
                }
                value={totalDonations}
                precision={0}
                valueStyle={{ color: '#1890ff', fontWeight: 'bold' }}
                prefix="₫"
                suffix=""
              />
            </Col>
            <Col xs={24} sm={12} md={8}>
              <Statistic
                title={
                  <Text strong style={{ fontSize: 16 }}>
                    <TeamOutlined
                      style={{ marginRight: 8, color: '#722ed1' }}
                    />
                    Total Sponsors
                  </Text>
                }
                value={sponsors.length}
                valueStyle={{ color: '#722ed1', fontWeight: 'bold' }}
              />
            </Col>
            <Col xs={24} sm={12} md={8}>
              <Statistic
                title={
                  <Text strong style={{ fontSize: 16 }}>
                    <TrophyOutlined
                      style={{ marginRight: 8, color: '#52c41a' }}
                    />
                    Top Sponsorships
                  </Text>
                }
                value={Math.max(...sponsors.map((s) => s.donate))}
                precision={0}
                valueStyle={{ color: '#52c41a', fontWeight: 'bold' }}
                prefix="₫"
              />
            </Col>
          </Row>
        </Card>
      </motion.div>

      {/* Sponsors Table - minimized animations */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.3 }}
      >
        <Card
          title={
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <TeamOutlined style={{ marginRight: 12, color: '#1890ff' }} />
              Tournament Sponsors
            </div>
          }
          bordered={false}
        >
          <Table
            columns={columns as any}
            dataSource={sponsors}
            rowKey="id"
            pagination={sponsors.length > 10 ? { pageSize: 10 } : false}
            summary={() => (
              <Table.Summary fixed>
                <Table.Summary.Row>
                  <Table.Summary.Cell index={0}>
                    <Text strong>Total</Text>
                  </Table.Summary.Cell>
                  <Table.Summary.Cell index={1}>
                    <Text strong type="danger">
                      ₫{totalDonations.toLocaleString()}
                    </Text>
                  </Table.Summary.Cell>
                </Table.Summary.Row>
              </Table.Summary>
            )}
          />
        </Card>
      </motion.div>

      {/* Add simpler styles - removed hover effects */}
      <style
        dangerouslySetInnerHTML={{
          __html: `
        .ant-card {
          box-shadow: 0 1px 4px rgba(0,0,0,0.05);
          border-radius: 8px;
        }
        `,
        }}
      />
    </div>
  );
};

export default Donate;
