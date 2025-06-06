import { CalendarOutlined, SearchOutlined } from '@ant-design/icons';
import type { InputRef } from 'antd';
import {
  Button,
  Col,
  Descriptions,
  Form,
  Image,
  Input,
  Modal,
  Row,
  Space,
  Table,
  Typography,
} from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import { useRef, useState } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useGetAllTournaments } from '@src/modules/Tournament/hooks/useGetAllTournaments';
import { useSponsorTournament } from '@src/modules/Payment/hooks/useSponsor';

type DataIndex = string;

const { Title } = Typography;

const formatDate = (dateStr: string) => {
  if (!dateStr) return '-';
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
};

type SponsorTournamentModalProps = {
  visible: boolean;
  onCancel: () => void;
  onSubmit: (amount: number) => void;
  isSubmitting: boolean;
  tournament: any | null;
};

const SponsorTournamentModal: React.FC<SponsorTournamentModalProps> = ({
  visible,
  onCancel,
  onSubmit,
  tournament,
}) => {
  const [form] = Form.useForm();
  const [amount, setAmount] = useState<number>(0);

  const handleSubmit = () => {
    onSubmit(amount);
  };

  const handleCancel = () => {
    form.resetFields();
    onCancel();
  };

  if (!visible) return null;

  return (
    <Modal
      title={
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Title level={4} style={{ margin: 0 }}>
            Sponsor Tournament
          </Title>
        </div>
      }
      visible={visible}
      onCancel={handleCancel}
      width={800}
      footer={null}
      destroyOnClose={true}
    >
      <Form
        form={form}
        layout="vertical"
        onFinish={handleSubmit}
        preserve={false}
      >
        <Row gutter={16}>
          <Col span={10}>
            <Form.Item>
              <Image
                src={tournament?.banner}
                alt="Tournament Banner"
                width={300}
                height={200}
                style={{ borderRadius: '8px' }}
              />
            </Form.Item>
          </Col>
          <Col span={14}>
            <Descriptions
              layout="horizontal"
              column={1}
              labelStyle={{ fontWeight: 'bold' }}
            >
              <Descriptions.Item label="Tournament Name">
                {tournament?.name}
              </Descriptions.Item>
              <Descriptions.Item label="Location">
                {tournament?.location}
              </Descriptions.Item>
              <Descriptions.Item label="Duration">
                {formatDate(tournament?.startDate)} -{' '}
                {formatDate(tournament?.endDate)}
              </Descriptions.Item>
              <Descriptions.Item label="Type">
                {tournament?.type}
              </Descriptions.Item>
              <Descriptions.Item label="Status">
                {tournament?.status}
              </Descriptions.Item>
            </Descriptions>
          </Col>
        </Row>
        <Input
          type="number"
          placeholder="e.g. 1000000"
          value={amount}
          onChange={(e) => setAmount(Number(e.target.value))}
          className="mb-3"
        />
        <Button type="primary" onClick={handleSubmit} className="me-2">
          Confirm
        </Button>
        <Button onClick={onCancel}>Cancel</Button>
      </Form>
    </Modal>
  );
};

export const TournamentList = () => {
  const user = useSelector((state: RootState) => state.auth.user);
  const {
    data: sponsorTournament,
    isLoading,
    refetch,
  } = useGetAllTournaments();
  const data =
    sponsorTournament?.filter(
      (tournament) =>
        tournament.organizerId !== user?.id && tournament.status === 'Scheduled'
    ) ?? [];
  const [, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const searchInput = useRef<InputRef>(null);
  const [isSponsorModalVisible, setIsSponsorModalVisible] = useState(false);
  const [selectedTournament, setSelectedTournament] = useState<any>(null);
  const { mutate } = useSponsorTournament();

  const handleSearch = (
    selectedKeys: string[],
    confirm: () => void,
    dataIndex: DataIndex
  ) => {
    confirm();
    setSearchText(selectedKeys[0]);
    setSearchedColumn(dataIndex);
  };

  const handleReset = (clearFilters?: () => void) => {
    if (clearFilters) {
      clearFilters();
    }
    setSearchText('');
  };

  const handleSponsor = (tournament: any) => {
    setSelectedTournament(tournament);
    setIsSponsorModalVisible(true);
  };

  const getColumnSearchProps = (dataIndex: DataIndex): ColumnType<any> => ({
    filterDropdown: ({
      setSelectedKeys,
      selectedKeys,
      confirm,
      clearFilters,
    }) => (
      <div style={{ padding: 8 }}>
        <Input
          ref={searchInput}
          placeholder={`Search ${dataIndex}`}
          value={selectedKeys[0]}
          onChange={(e) =>
            setSelectedKeys(e.target.value ? [e.target.value] : [])
          }
          onPressEnter={() =>
            handleSearch(selectedKeys as string[], confirm, dataIndex)
          }
          style={{ marginBottom: 8, display: 'block' }}
        />
        <Space>
          <Button
            type="primary"
            onClick={() =>
              handleSearch(selectedKeys as string[], confirm, dataIndex)
            }
            icon={<SearchOutlined />}
            size="small"
            style={{ width: 90 }}
          >
            Search
          </Button>
          <Button
            onClick={() => handleReset(clearFilters)}
            size="small"
            style={{ width: 90 }}
          >
            Reset
          </Button>
        </Space>
      </div>
    ),
    filterIcon: (filtered: boolean) => (
      <SearchOutlined style={{ color: filtered ? '#1890ff' : undefined }} />
    ),
    onFilter: (value, record) =>
      record[dataIndex]
        ? record[dataIndex]
            .toString()
            .toLowerCase()
            .includes((value as string).toLowerCase())
        : '',
    onFilterDropdownVisibleChange: (visible) => {
      if (visible) {
        setTimeout(() => searchInput.current?.select(), 100);
      }
    },
    render: (text) =>
      searchedColumn === dataIndex ? (
        <span style={{ backgroundColor: '#ffc069', padding: 0 }}>{text}</span>
      ) : (
        text
      ),
  });

  const columns: ColumnsType<any> = [
    {
      title: 'Tournament',
      dataIndex: 'name',
      key: 'name',
      ...getColumnSearchProps('name'),
      render: (text: string, record: any) => (
        <div
          style={{ display: 'flex', flexDirection: 'row', padding: '8px 0' }}
        >
          <Image
            src={record.banner}
            alt="Tournament"
            width={300}
            height={200}
          />
          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              marginLeft: 12,
              justifyContent: 'center',
            }}
          >
            <span style={{ fontWeight: 'bold' }}>{text}</span>
            <span style={{ fontSize: '12px', color: '#888' }}>
              {record.location}
            </span>
          </div>
        </div>
      ),
      width: 220,
    },
    {
      title: 'Period',
      key: 'period',
      render: (_, record) => (
        <div
          style={{ display: 'flex', flexDirection: 'column', padding: '6px 0' }}
        >
          <div>
            <CalendarOutlined /> <span style={{ fontWeight: 500 }}>Start:</span>{' '}
            {formatDate(record.startDate)}
          </div>
          <div style={{ marginTop: 4 }}>
            <CalendarOutlined /> <span style={{ fontWeight: 500 }}>End:</span>{' '}
            {formatDate(record.endDate)}
          </div>
        </div>
      ),
      width: 220,
    },
    {
      title: 'Action',
      key: 'action',
      render: (_, record) => (
        <div>
          {record.isAccept ? (
            <>
              <Button
                className="bg-primary text-white"
                onClick={() => handleSponsor(record)}
              >
                Sponsor
              </Button>
            </>
          ) : null}
        </div>
      ),
      width: 10,
    },
  ];

  return (
    <div style={{ padding: '24px', backgroundColor: '#f0f2f5' }}>
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: '24px',
        }}
      >
        <Typography.Title level={2} style={{ margin: 0 }}>
          Upcoming Tournaments
        </Typography.Title>
      </div>

      {/* Second half of screen - Table */}
      <div
        style={{
          marginBottom: 16,
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
        }}
      >
        <Button
          type="primary"
          onClick={() => refetch()}
          icon={<SearchOutlined />}
        >
          Refresh Data
        </Button>

        <Typography.Text type="secondary">
          Showing {data?.length || 0} tournaments
        </Typography.Text>
      </div>

      <SponsorTournamentModal
        visible={isSponsorModalVisible}
        onCancel={() => {
          setIsSponsorModalVisible(false);
          setSelectedTournament(null);
        }}
        onSubmit={(amount: number) => {
          if (!selectedTournament) return;

          const payload = {
            touramentId: selectedTournament.id, // Corrected property name
            amount: Number(amount),
            sponnerId: user?.id ?? 0, // Ensure a default value if undefined
            returnUrl: 3, // Updated to match the expected type
          };

          mutate(payload, {
            onSuccess: (paymentUrl) => {
              console.log('Redirecting to payment:', paymentUrl);
              window.location.href = paymentUrl; // hoặc navigate nếu cần
            },
            onError: (error) => {
              console.error('Sponsorship error:', error.message);
            },
          });

          setIsSponsorModalVisible(false);
          setSelectedTournament(null);
        }}
        isSubmitting={isLoading}
        tournament={selectedTournament} // Pass the selected tournament
      />

      <Table
        columns={columns}
        dataSource={data}
        loading={isLoading}
        rowKey="id"
        style={{
          backgroundColor: '#ffffff',
          borderRadius: '8px',
          boxShadow: '0 1px 2px rgba(0, 0, 0, 0.03)',
        }}
        pagination={{
          pageSize: 10,
          showSizeChanger: true,
          showTotal: (total) => `Total ${total} tournaments`,
        }}
        size="middle"
        bordered={false}
      />

      <style>
        {`
        .chart-container {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 140px;
        }
        
        .compact-legend {
          display: flex;
          flex-direction: column;
          padding: 0 10px;
          font-size: 12px;
        }
        
        .legend-item {
          display: flex;
          align-items: center;
          margin-bottom: 5px;
        }
        
        .color-dot {
          width: 10px;
          height: 10px;
          border-radius: 50%;
          margin-right: 6px;
        }
        
        .legend-label {
          flex: 1;
        }
        
        .legend-value {
          font-weight: bold;
        }
        
        @media (max-width: 768px) {
          .stats-row > div {
            margin-bottom: 10px;
          }
        }
        `}
      </style>
    </div>
  );
};

export default TournamentList;
