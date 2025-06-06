import { SearchOutlined, UserOutlined } from '@ant-design/icons';
import {
  Button,
  DatePicker,
  Input,
  InputRef,
  Space,
  Table,
  Tag,
  Card,
  Row,
  Col,
  message,
  Avatar,
  Typography,
} from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import type { FilterDropdownProps } from 'antd/es/table/interface';
import moment from 'moment';
import React, { useRef, useState, useEffect } from 'react';
import {
  useGetAllUser,
  useGetAllUsers,
} from '@src/modules/User/hooks/useGetAllUser';
import { useUpdateUser } from '@src/modules/User/hooks/useUpdateUser';
import { User } from '@src/modules/User/models';
import { Pie } from '@ant-design/plots';

const { Title } = Typography;

// Define UserRole enum
enum UserRole {
  Player = 1,
  Admin = 2,
  Sponsor = 3,
  Referee = 4,
  User = 5,
}

// Define role colors
const roleColors: Record<number, string> = {
  [UserRole.Player]: '#1890ff', // Blue
  [UserRole.Admin]: '#722ed1', // Purple
  [UserRole.Sponsor]: '#faad14', // Gold
  [UserRole.Referee]: '#eb2f96', // Pink
  [UserRole.User]: '#52c41a', // Green
};

// Map role IDs to names for display
const roleNames: Record<number, string> = {
  [UserRole.Player]: 'Player',
  [UserRole.Admin]: 'Admin',
  [UserRole.Sponsor]: 'Sponsor',
  [UserRole.Referee]: 'Referee',
  [UserRole.User]: 'User',
};

// Extend User interface to include roleId
interface ExtendedUser extends Omit<User, 'roleId'> {
  roleId?: UserRole;
}

type DataIndex = keyof ExtendedUser;

export const BlockUser: React.FC = () => {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [pageSize, setPageSize] = useState<number>(10);
  const {
    data: rawData,
    isLoading,
    error,
    refetch,
  } = useGetAllUsers(currentPage, pageSize);
  const { data: allData } = useGetAllUser();
  const { mutate: updateUser } = useUpdateUser();
  const [, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const searchInput = useRef<InputRef>(null);

  // Process data for charts
  const [usersByRole, setUsersByRole] = useState<any[]>([]);
  const [usersByStatus, setUsersByStatus] = useState<any[]>([]);
  const [data, setData] = useState<ExtendedUser[]>([]);

  const handlePaginationChange = (page: number, pageSize: number) => {
    setCurrentPage(page);
    setPageSize(pageSize);
  };

  useEffect(() => {
    if (allData) {
      // Mock roleId for demonstration since your actual data might not have it yet
      const extendedData: ExtendedUser[] = allData.map((user: User) => ({
        ...user,
        roleId: user.roleId ? user.roleId : UserRole.User,
      }));

      setData(extendedData);

      // Prepare chart data for roles
      const roleCountMap: Record<number, number> = {};
      extendedData.forEach((user) => {
        if (user.roleId) {
          roleCountMap[user.roleId] = (roleCountMap[user.roleId] || 0) + 1;
        }
      });

      const roleChartData = Object.keys(roleCountMap).map((roleId) => ({
        type: roleNames[Number(roleId)],
        value: roleCountMap[Number(roleId)],
      }));
      setUsersByRole(roleChartData);

      // Prepare chart data for status
      const activeCount = extendedData.filter((user) => user.status).length;
      const inactiveCount = extendedData.length - activeCount;
      setUsersByStatus([
        { type: 'Active', value: activeCount },
        { type: 'Inactive', value: inactiveCount },
      ]);
    }
  }, [allData]);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error loading users</div>;
  }

  const getColumnSearchProps = (
    dataIndex: DataIndex
  ): ColumnType<ExtendedUser> => ({
    filterDropdown: ({
      setSelectedKeys,
      selectedKeys,
      confirm,
      clearFilters,
      close,
    }: FilterDropdownProps) => (
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
            onClick={() => clearFilters && handleReset(clearFilters)}
            size="small"
            style={{ width: 90 }}
          >
            Reset
          </Button>
          <Button onClick={close} size="small" style={{ width: 90 }}>
            Close
          </Button>
        </Space>
      </div>
    ),
    filterIcon: (filtered: boolean) => (
      <SearchOutlined style={{ color: filtered ? '#1890ff' : undefined }} />
    ),
    onFilter: (value, record) =>
      record[dataIndex] !== undefined
        ? record[dataIndex]!.toString()
            .toLowerCase()
            .includes((value as string).toLowerCase())
        : false,
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

  const handleSearch = (
    selectedKeys: React.Key[],
    confirm: () => void,
    dataIndex: DataIndex
  ) => {
    confirm();
    setSearchText(selectedKeys[0] as string);
    setSearchedColumn(dataIndex);
  };

  const handleReset = (clearFilters: () => void) => {
    clearFilters();
    setSearchText('');
  };

  const handleAction = (userId: number, status: boolean) => {
    updateUser(
      { id: userId, data: { status: !status } },
      {
        onSuccess: () => {
          message.success(
            `User ${status ? 'banned' : 'unbanned'} successfully`
          );
          refetch();
        },
        onError: () => {
          message.error(`Failed to ${status ? 'ban' : 'unban'} user`);
        },
      }
    );
  };

  // Configuration for Pie charts
  const pieConfig = {
    appendPadding: 10,
    angleField: 'value',
    colorField: 'type',
    radius: 0.8,
    label: {
      type: 'outer',
      content: '{name} {percentage}',
    },
    interactions: [{ type: 'element-active' }],
  };

  const columns: ColumnsType<ExtendedUser> = [
    {
      title: 'Avatar',
      dataIndex: 'avatarUrl',
      key: 'avatarUrl',
      render: (avatarUrl: string) => (
        <Avatar src={avatarUrl} size={40} icon={<UserOutlined />} />
      ),
    },
    {
      title: 'First Name',
      dataIndex: 'firstName',
      key: 'firstName',
      ...getColumnSearchProps('firstName'),
    },
    {
      title: 'Last Name',
      dataIndex: 'lastName',
      key: 'lastName',
      ...getColumnSearchProps('lastName'),
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      ...getColumnSearchProps('email'),
    },
    {
      title: 'Date of Birth',
      dataIndex: 'dateOfBirth',
      key: 'dateOfBirth',
      render: (text: string) => moment(text).format('YYYY-MM-DD'),
      filterDropdown: ({
        setSelectedKeys,
        selectedKeys,
        confirm,
        clearFilters,
        close,
      }: FilterDropdownProps) => (
        <div style={{ padding: 8 }}>
          <DatePicker
            onChange={(date) =>
              setSelectedKeys(date ? [date.format('YYYY-MM-DD')] : [])
            }
            style={{ marginBottom: 8, display: 'block' }}
          />
          <Space>
            <Button
              type="primary"
              onClick={() => handleSearch(selectedKeys, confirm, 'dateOfBirth')}
              icon={<SearchOutlined />}
              size="small"
              style={{ width: 90 }}
            >
              Search
            </Button>
            <Button
              onClick={() => clearFilters && handleReset(clearFilters)}
              size="small"
              style={{ width: 90 }}
            >
              Reset
            </Button>
            <Button onClick={close} size="small" style={{ width: 90 }}>
              Close
            </Button>
          </Space>
        </div>
      ),
      onFilter: (value, record) =>
        moment(record.dateOfBirth).format('YYYY-MM-DD') === value,
    },
    {
      title: 'Role',
      dataIndex: 'roleId',
      key: 'roleId',
      filters: Object.entries(roleNames).map(([id, name]) => ({
        text: name,
        value: Number(id),
      })),
      onFilter: (value, record) => record.roleId === value,
      render: (roleId: UserRole) => (
        <Tag color={roleColors[roleId]} icon={<UserOutlined />}>
          {roleNames[roleId] || `Role ${roleId}`}
        </Tag>
      ),
    },
    {
      title: 'Gender',
      dataIndex: 'gender',
      key: 'gender',
      filters: [
        { text: 'Male', value: 'Male' },
        { text: 'Female', value: 'Female' },
      ],
      onFilter: (value, record) => record.gender === value,
    },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      filters: [
        { text: 'Active', value: true },
        { text: 'Inactive', value: false },
      ],
      onFilter: (value, record) => record.status === value,
      render: (status: boolean) => (
        <Tag color={status ? 'green' : 'red'}>
          {status ? 'Active' : 'Inactive'}
        </Tag>
      ),
    },
    {
      title: 'Action',
      key: 'action',
      render: (record: ExtendedUser) =>
        record.roleId !== UserRole.Admin && (
          <Button
            type="primary"
            danger={record.status}
            onClick={() => handleAction(record.id, record.status)}
          >
            {record.status ? 'Ban' : 'Unban'}
          </Button>
        ),
    },
  ];

  // Define custom colors for role pie chart
  const roleColorMap: Record<string, string> = {};
  Object.entries(roleNames).forEach(([id, name]) => {
    roleColorMap[name] = roleColors[Number(id)];
  });

  const roleColorsArray = usersByRole.map(
    (item) => roleColorMap[item.type] || '#1890ff'
  );

  return (
    <div>
      <Title level={2}>User Statistics</Title>
      <Row gutter={[16, 16]} style={{ marginBottom: 20 }}>
        <Col xs={24} md={12}>
          <Card title={<Title level={4}>Users by Role</Title>} bordered={false}>
            <Pie {...pieConfig} data={usersByRole} color={roleColorsArray} />
          </Card>
        </Col>
        <Col xs={24} md={12}>
          <Card
            title={<Title level={4}>Users by Status</Title>}
            bordered={false}
          >
            <Pie
              {...pieConfig}
              data={usersByStatus}
              colorField="type"
              color={['#52c41a', '#f5222d']}
            />
          </Card>
        </Col>
      </Row>

      <Title level={2}>User List</Title>
      <Table
        columns={columns}
        dataSource={data}
        loading={isLoading}
        rowKey="id"
        style={{ backgroundColor: '#ffffff' }}
        pagination={{
          current: rawData?.currentPage,
          total: rawData?.totalItems,
          pageSize: rawData?.pageSize,
          onChange: handlePaginationChange,
          pageSizeOptions: ['10', '20', '50'],
          showSizeChanger: true,
        }}
      />
    </div>
  );
};

export default BlockUser;
