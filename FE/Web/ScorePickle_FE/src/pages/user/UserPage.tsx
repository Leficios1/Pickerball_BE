import { SearchOutlined } from '@ant-design/icons';
import type { InputRef } from 'antd';
import { Button, Card, Col, Input, Row, Space, Table, Tag } from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import { useRef, useState } from 'react';
import { useGetAllUsers } from '@src/modules/User/hooks/useGetAllUser';

type DataIndex = string;

export const UserPage = () => {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [pageSize, setPageSize] = useState<number>(10);
  const { data, isLoading, refetch } = useGetAllUsers(currentPage, pageSize);
  const [searchText, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const searchInput = useRef<InputRef>(null);

  const handlePaginationChange = (page: number, pageSize: number) => {
    setCurrentPage(page);
    setPageSize(pageSize);
  };

  // todo: remove this
  console.log(searchText);

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
      title: 'First Name',
      dataIndex: 'firstName',
      key: 'firstName',
    },
    {
      title: 'Second Name',
      dataIndex: 'secondName',
      key: 'secondName',
    },
    {
      title: 'Last Name',
      dataIndex: 'lastName',
      key: 'lastName',
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      ...getColumnSearchProps('email'),
    },
    {
      title: 'Phone Number',
      dataIndex: 'phoneNumber',
      key: 'phoneNumber',
    },
    {
      title: 'Gender',
      dataIndex: 'gender',
      key: 'gender',
      render: (gender: string) => (
        <Tag
          color={
            gender === 'Male' ? 'blue' : gender === 'Female' ? 'pink' : 'gold'
          }
        >
          {gender}
        </Tag>
      ),
    },
    {
      title: 'Role',
      dataIndex: 'roleId',
      key: 'roleId',
      filters: [
        { text: '1', value: 'Player' },
        { text: '2', value: 'Admin' },
        { text: '3', value: 'Sponsor' },
        { text: '4', value: 'Referee' },
        { text: '5', value: 'User' },
        { text: '6', value: 'Staff' },
        { text: '7', value: 'Organizer' },
      ],
      onFilter: (value, record) => record.roleId.indexOf(value) === 0,
      render: (role: string) => {
        let tagColor;

        // Define tag color based on role
        switch (role) {
          case 'Player':
            tagColor = 'green';
            break;
          case 'Admin':
            tagColor = 'red';
            break;
          case 'Sponsor':
            tagColor = 'gold';
            break;
          case 'Referee':
            tagColor = 'blue';
            break;
          case 'User':
            tagColor = 'gray';
            break;
          case 'Staff':
            tagColor = 'purple';
            break;
          case 'Organizer':
            tagColor = 'cyan';
            break;
          default:
            tagColor = 'default';
        }

        return <Tag color={tagColor}>{role}</Tag>;
      },
    },
  ];

  const totalUsers = data?.totalItems || 0;
  const totalPlayers = data?.totalItems || 0;
  const totalSponsors = data?.totalItems || 0;
  const totalReferees = data?.totalItems || 0;
  const totalOrganizers = data?.totalItems || 0;
  const totalStaffs = data?.totalItems || 0;

  return (
    <div>
      <Row gutter={16} style={{ marginBottom: 16 }}>
        <Col span={4}>
          <Card title="Total User" bordered={false}>
            {totalUsers}
          </Card>
        </Col>
        <Col span={4}>
          <Card title="Total Player" bordered={false}>
            {totalPlayers}
          </Card>
        </Col>
        <Col span={4}>
          <Card title="Total Sponsor" bordered={false}>
            {totalSponsors}
          </Card>
        </Col>
        <Col span={4}>
          <Card title="Total Referee" bordered={false}>
            {totalReferees}
          </Card>
        </Col>
        <Col span={4}>
          <Card title="Total Organizer" bordered={false}>
            {totalOrganizers}
          </Card>
        </Col>
        <Col span={4}>
          <Card title="Total Staff" bordered={false}>
            {totalStaffs}
          </Card>
        </Col>
      </Row>
      <Button
        type="primary"
        onClick={() => refetch()}
        style={{ marginBottom: 16 }}
      >
        Refetch
      </Button>
      <Table
        columns={[
          {
            title: 'STT',
            render: (index) => (currentPage - 1) * pageSize + index + 1,
          },
          ...columns,
        ]}
        dataSource={data?.data}
        loading={isLoading}
        rowKey="id"
        pagination={{
          current: data?.currentPage,
          total: data?.totalItems,
          pageSize: data?.pageSize,
          onChange: handlePaginationChange,
          pageSizeOptions: ['10', '20', '50'],
          showSizeChanger: true,
        }}
      />
    </div>
  );
};

export default UserPage;
