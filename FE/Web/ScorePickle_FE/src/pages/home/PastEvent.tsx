'use client';

import { useState } from 'react';
import {
  Button,
  Card,
  DatePicker,
  Divider,
  Input,
  Select,
  Table,
  Image,
} from 'antd';
import {
  SearchOutlined,
  CalendarOutlined,
  UserOutlined,
} from '@ant-design/icons';

export default function PastEvent() {
  const [selectedEvent, setSelectedEvent] = useState<string | null>(null);

  const events = [
    {
      id: '1',
      name: 'Georgia Super Regional',
      date: 'Jan 20, 2024',
      participants: 64,
      image:
        'https://cdn.prod.website-files.com/6553d656e0c08a595048965b/67abcbf08a73686e0cd07594_Georgia%20SR%20April%202024.png',
    },
    {
      id: '2',
      name: 'Virginia Super Regional',
      date: 'Mar 15, 2024',
      participants: 48,
      image:
        'https://cdn.prod.website-files.com/6553d656e0c08a595048965b/67abcbf08a73686e0cd07594_Georgia%20SR%20April%202024.png',
    },
    {
      id: '3',
      name: 'Utah Super Regional',
      date: 'Apr 10, 2024',
      participants: 56,
      image:
        'https://cdn.prod.website-files.com/6553d656e0c08a595048965b/67abcbf08a73686e0cd07594_Georgia%20SR%20April%202024.png',
    },
    {
      id: '4',
      name: 'Illinois Super Regional',
      date: 'May 5, 2024',
      participants: 72,
      image:
        'https://cdn.prod.website-files.com/6553d656e0c08a595048965b/67abcbf08a73686e0cd07594_Georgia%20SR%20April%202024.png',
    },
  ];

  const columns = [
    {
      title: 'Event Name',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Date',
      dataIndex: 'date',
      key: 'date',
    },
    {
      title: 'Participants',
      dataIndex: 'participants',
      key: 'participants',
    },
    {
      title: 'Actions',
      key: 'actions',
      render: (_, record: any) => (
        <Button
          type="primary"
          size="small"
          onClick={() => setSelectedEvent(record.id)}
        >
          View Details
        </Button>
      ),
    },
  ];

  return (
    <main className="container-fluid p-4">
      <h1 className="mb-4">Event Management System</h1>

      {/* Search and Filter Section - Using Bootstrap Grid */}
      <div className="row mb-4">
        <div className="col-md-6 mb-3 mb-md-0">
          <Input
            placeholder="Search events"
            prefix={<SearchOutlined />}
            className="w-100"
          />
        </div>
        <div className="col-md-3 mb-3 mb-md-0">
          <DatePicker placeholder="Select date" className="w-100" />
        </div>
        <div className="col-md-3">
          <Select
            placeholder="Filter by region"
            className="w-100"
            options={[
              { value: 'georgia', label: 'Georgia' },
              { value: 'virginia', label: 'Virginia' },
              { value: 'utah', label: 'Utah' },
              { value: 'illinois', label: 'Illinois' },
            ]}
          />
        </div>
      </div>

      {/* Past Events Section */}
      <Divider orientation="left">Past Events</Divider>
      <div className="row">
        {events.map((event) => (
          <div key={event.id} className="col-md-6 col-lg-3 mb-4">
            <Card
              hoverable
              cover={
                <div className="position-relative" style={{ height: '200px' }}>
                  <Image
                    src={event.image || '/placeholder.svg'}
                    alt={event.name}
                    style={{
                      objectFit: 'cover',
                      width: '100%',
                      height: '100%',
                    }}
                  />
                </div>
              }
              actions={[
                <Button key="view" type="link">
                  View
                </Button>,
                <Button key="register" type="link">
                  Results
                </Button>,
              ]}
            >
              <Card.Meta
                title={event.name}
                description={
                  <div>
                    <p>
                      <CalendarOutlined /> {event.date}
                    </p>
                    <p>
                      <UserOutlined /> {event.participants} participants
                    </p>
                  </div>
                }
              />
            </Card>
          </div>
        ))}
      </div>

      {/* Event Data Table */}
      <Divider orientation="left">Event Data</Divider>
      <Table
        dataSource={events}
        columns={columns}
        rowKey="id"
        pagination={{ pageSize: 5 }}
      />

      {/* Selected Event Details */}
      {selectedEvent && (
        <div className="mt-4">
          <Card title="Event Details" className="shadow-sm">
            {events.find((e) => e.id === selectedEvent)?.name}
          </Card>
        </div>
      )}
    </main>
  );
}
