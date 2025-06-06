import { SearchOutlined, UserOutlined } from '@ant-design/icons';
import type { InputRef } from 'antd';
import {
  Button,
  Card,
  Col,
  Input,
  Row,
  Space,
  Table,
  Tag,
  Typography,
} from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import { useRef, useState } from 'react';
import { useGetAllStaffs } from '@src/modules/User/hooks/useGetAllStaff';

type DataIndex = string;
const { Text } = Typography;

export const StaffPage = () => {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [pageSize, setPageSize] = useState<number>(10);
  const { data, isLoading, refetch } = useGetAllStaffs(currentPage, pageSize);
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
  ];

  const totalStaffs = data?.totalItems || 0;

  return (
    <div>
      <Row gutter={16} style={{ marginBottom: 16 }}>
        <Col span={6}>
          <Card title="Total Staffs" bordered={false} style={{ height: 150 }}>
            <UserOutlined style={{ fontSize: 24, color: '#1890ff' }} />
            <Text style={{ fontSize: 24, marginLeft: 8 }}>{totalStaffs}</Text>
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

export default StaffPage;
