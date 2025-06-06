import { ReloadOutlined, SearchOutlined } from '@ant-design/icons';
import type { InputRef } from 'antd';
import {
  Button,
  Card,
  Col,
  Divider,
  Input,
  Row,
  Space,
  Statistic,
  Table,
  Tag,
  Typography,
} from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import { useEffect, useMemo, useRef, useState } from 'react';
import { useGetAllBillsByTournamentId } from '@src/modules/Payment/hooks/useGetAllBillsByTournamentId';
import {
  PaymentStatus,
  TournamentPayment,
  TypePayment,
} from '@src/modules/Payment/models';

const { Text } = Typography;

type DataIndex = string;

type BillTabProps = {
  id: number;
};

// Move these functions outside the component to avoid the "Cannot access before initialization" error
const getStatusTagColor = (status: number) => {
  switch (status) {
    case 1:
      return 'green'; // Paid
    case 2:
      return 'orange'; // Pending
    case 3:
      return 'red'; // Failed
    case 4:
      return 'blue'; // Refunded
    default:
      return 'default';
  }
};

const getStatusText = (status: number) => {
  switch (status) {
    case 1:
      return 'Paid';
    case 2:
      return 'Pending';
    case 3:
      return 'Failed';
    case 4:
      return 'Refunded';
    default:
      return 'Unknown';
  }
};

const BillTab = ({ id }: BillTabProps) => {
  const {
    data: bills,
    isLoading,
    error,
    refetch,
  } = useGetAllBillsByTournamentId(Number(id));

  const [filteredBills, setFilteredBills] = useState<TournamentPayment[]>([]);
  const [, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const searchInput = useRef<InputRef>(null);

  useEffect(() => {
    setFilteredBills(bills || []);
  }, [bills]);

  // Calculate statistics
  const statistics = useMemo(() => {
    if (!bills || !bills.length) {
      return {
        totalAmount: 0,
        totalSponsor: 0,
        totalFee: 0,
        totalAward: 0,
        totalCount: 0,
        sponsorCount: 0,
        feeCount: 0,
        awardCount: 0,
      };
    }

    // Ensure consistent type handling - convert status to number if it's a string
    const total = bills.filter(
      (bill) => bill.status === PaymentStatus.Completed
    );
    const sponsor = bills.filter(
      (bill) =>
        Number(bill.type) === TypePayment.Donate &&
        bill.status === PaymentStatus.Completed
    );
    const fee = bills.filter(
      (bill) =>
        Number(bill.type) === TypePayment.Fee &&
        bill.status === PaymentStatus.Completed
    );
    const award = bills.filter(
      (bill) =>
        Number(bill.type) === TypePayment.Award &&
        bill.status === PaymentStatus.Completed
    );

    return {
      totalAmount:
        fee.reduce((sum, bill) => sum + bill.amount, 0) +
        sponsor.reduce((sum, bill) => sum + bill.amount, 0) -
        award.reduce((sum, bill) => sum + bill.amount, 0),
      totalSponsor: sponsor.reduce((sum, bill) => sum + bill.amount, 0),
      totalFee: fee.reduce((sum, bill) => sum + bill.amount, 0),
      totalAward: award.reduce((sum, bill) => sum + bill.amount, 0),
      totalCount: total.length,
      sponsorCount: sponsor.length,
      feeCount: fee.length,
      awardCount: award.length,
    };
  }, [bills]);

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
            ?.toLowerCase()
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

  const columns: ColumnsType<TournamentPayment> = [
    {
      title: 'ID',
      dataIndex: 'id',
      key: 'id',
      width: 80,
    },
    {
      title: 'Amount',
      dataIndex: 'amount',
      key: 'amount',
      render: (amount: number) => (
        <Text strong style={{ color: '#389e0d' }}>
          ₫{amount.toLocaleString()}
        </Text>
      ),
      sorter: (a, b) => a.amount - b.amount,
    },
    {
      title: 'User ID',
      dataIndex: 'userId',
      key: 'userId',
      width: 100,
    },
    {
      title: 'Note',
      dataIndex: 'note',
      key: 'note',
      ...getColumnSearchProps('note'),
    },
    {
      title: 'Payment Method',
      dataIndex: 'paymentMethod',
      key: 'paymentMethod',
      render: (method: string) => <Tag color="blue">{method}</Tag>,
      filters: [
        { text: 'VNPAY', value: 'VNPAY' },
        { text: 'Cash', value: 'Cash' },
        { text: 'Bank Transfer', value: 'Bank Transfer' },
      ],
      onFilter: (value, record) => record.paymentMethod === value,
    },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      render: (status: number | string) => (
        <Tag color={getStatusTagColor(Number(status))}>
          {getStatusText(Number(status))}
        </Tag>
      ),
      filters: [
        { text: 'Paid', value: 1 },
        { text: 'Pending', value: 2 },
        { text: 'Failed', value: 3 },
        { text: 'Refunded', value: 4 },
      ],
      onFilter: (value, record) => Number(record.status) === value,
    },
    {
      title: 'Payment Date',
      dataIndex: 'paymentDate',
      key: 'paymentDate',
      render: (text: string) =>
        text ? new Date(text).toLocaleString() : 'Not paid yet',
      sorter: (a, b) => {
        if (!a.paymentDate) return 1;
        if (!b.paymentDate) return -1;
        return (
          new Date(a.paymentDate).getTime() - new Date(b.paymentDate).getTime()
        );
      },
    },
    {
      title: 'Type',
      dataIndex: 'type',
      key: 'type',
      render: (type: number | string) => {
        const typeNum = Number(type);
        const typeText =
          typeNum === 1
            ? 'Sponsorship'
            : typeNum === 2
              ? 'Registration'
              : 'Award';
        return <Tag color={typeNum === 1 ? 'green' : 'blue'}>{typeText}</Tag>;
      },
      filters: [
        { text: 'Sponsorship', value: 1 },
        { text: 'Registration', value: 2 },
        { text: 'Award', value: 3 },
      ],
      onFilter: (value, record) => Number(record.type) === value,
    },
  ];

  if (isLoading) {
    return <div>Loading bills...</div>;
  }

  if (error) {
    return <div>Error loading bills: {(error as Error).message}</div>;
  }

  return (
    <div className="bill-tab-container">
      {/* Summary Cards */}
      <Row gutter={16} style={{ marginBottom: 16 }}>
        <Col span={12}>
          <Card bordered={false} className="summary-card">
            <Statistic
              title="Total Profit"
              value={statistics.totalAmount}
              precision={0}
              valueStyle={{ color: '#52c41a' }}
              prefix="₫"
              formatter={(value) => value?.toLocaleString()}
            />
          </Card>
        </Col>
        <Col span={12}>
          <Card bordered={false} className="summary-card">
            <Statistic
              title="Total Fee"
              value={statistics.totalFee}
              precision={0}
              valueStyle={{ color: '#faad14' }}
              prefix="₫"
              suffix={`(${statistics.feeCount} transactions)`}
              formatter={(value) => value?.toLocaleString()}
            />
          </Card>
        </Col>
      </Row>
      <Row gutter={16} style={{ marginBottom: 16 }}>
        <Col span={12}>
          <Card bordered={false} className="summary-card">
            <Statistic
              title="Total Sponsor"
              value={statistics.totalSponsor}
              precision={0}
              valueStyle={{ color: 'rgb(233, 90, 90)' }}
              prefix="₫"
              suffix={`(${statistics.sponsorCount} sponsorships)`}
              formatter={(value) => value?.toLocaleString()}
            />
          </Card>
        </Col>
        <Col span={12}>
          <Card bordered={false} className="summary-card">
            <Statistic
              title="Total Award"
              value={statistics.totalAward}
              precision={0}
              valueStyle={{ color: 'rgba(1,1,1,1)' }}
              prefix="₫"
              suffix={`(${statistics.awardCount} awards)`}
              formatter={(value) => value?.toLocaleString()}
            />
          </Card>
        </Col>
      </Row>

      <Divider orientation="left">Payment Records</Divider>
      <Button
        type="primary"
        icon={<ReloadOutlined />}
        onClick={() => refetch()}
        style={{ marginBottom: 16 }}
      >
        Refresh Bills
      </Button>
      <Table
        columns={columns}
        dataSource={filteredBills}
        rowKey="id"
        pagination={{ pageSize: 10 }}
        summary={(pageData) => {
          let totalAmount = 0;
          pageData.forEach(({ amount }) => {
            totalAmount += amount;
          });
          return (
            <>
              <Table.Summary.Row>
                <Table.Summary.Cell index={0} colSpan={2}>
                  Page Total
                </Table.Summary.Cell>
                <Table.Summary.Cell index={1} colSpan={2}>
                  <Text strong style={{ color: '#389e0d' }}>
                    ₫{totalAmount.toLocaleString()}
                  </Text>
                </Table.Summary.Cell>
                <Table.Summary.Cell index={2} colSpan={5}></Table.Summary.Cell>
              </Table.Summary.Row>
            </>
          );
        }}
      />
    </div>
  );
};

export default BillTab;
