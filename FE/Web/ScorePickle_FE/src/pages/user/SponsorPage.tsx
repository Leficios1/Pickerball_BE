import React, { useState, useRef } from 'react';
import { Button, Input, Space, Table, Typography, Row, Col, Card } from 'antd';
import { SearchOutlined, UserOutlined } from '@ant-design/icons';
import type { InputRef } from 'antd';
import type { ColumnsType, ColumnType } from 'antd/es/table';
import { useGetAllSponsor } from '@src/modules/User/hooks/useGetAllSponsor';

const { Text } = Typography;

type DataIndex = string;

const SponsorPage: React.FC = () => {
  const { data: sponsors, isLoading, error } = useGetAllSponsor();
  const [, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const searchInput = useRef<InputRef>(null);

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
      title: 'Logo',
      dataIndex: 'logoUrl',
      key: 'logoUrl',
      render: (logoUrl: string) => (
        <img
          src={logoUrl}
          alt="logoUrl"
          style={{ width: 50, height: 50, borderRadius: '50%' }}
        />
      ),
    },
    {
      title: 'Social',
      dataIndex: 'urlSocial',
      key: 'urlSocial',
      render: (urlSocial: string) => (
        <img
          src={urlSocial}
          alt="urlSocial"
          style={{ width: 50, height: 50, borderRadius: '50%' }}
        />
      ),
    },
    {
      title: 'Social 1',
      dataIndex: 'urlSocial1',
      key: 'urlSocial1',
      render: (urlSocial1: string) => (
        <img
          src={urlSocial1}
          alt="urlSocial"
          style={{ width: 50, height: 50, borderRadius: '50%' }}
        />
      ),
    },
    {
      title: 'Company Name',
      dataIndex: 'companyName',
      key: 'companyName',
      ...getColumnSearchProps('companyName'),
    },
    {
      title: 'Contact Email',
      dataIndex: 'contactEmail',
      key: 'contactEmail',
      ...getColumnSearchProps('contactEmail'),
    },
    {
      title: 'Join At',
      dataIndex: 'joinedAt',
      key: 'joinedAt',
      render: (joinedAt: string) => new Date(joinedAt).toLocaleDateString(),
    },
  ];

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error loading sponsors</div>;
  }

  return (
    <div>
      <Row gutter={8} style={{ marginBottom: 16 }}>
        <Col span={6}>
          <Card title="Total Sponsors" bordered={false} style={{ height: 150 }}>
            <UserOutlined style={{ fontSize: 24, color: '#1890ff' }} />
            <Text style={{ fontSize: 24, marginLeft: 8 }}>
              {sponsors?.length}
            </Text>
          </Card>
        </Col>
      </Row>
      <Table columns={columns} dataSource={sponsors} rowKey="id" />
    </div>
  );
};

export default SponsorPage;
