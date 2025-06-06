'use client';

import { useState } from 'react';
import {
  Layout,
  Menu,
  Button,
  Card,
  Tag,
  Input,
  Select,
  Slider,
  Row,
  Col,
  Divider,
  Typography,
  Badge,
  Image,
} from 'antd';
import {
  SearchOutlined,
  TrophyOutlined,
  TeamOutlined,
  EnvironmentOutlined,
  FilterOutlined,
  CalendarOutlined,
  MailOutlined,
  PhoneOutlined,
} from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';

const { Header, Content, Footer } = Layout;
const { Title, Paragraph, Text } = Typography;
const { Option } = Select;

interface Tournament {
  id: number;
  name: string;
  date: string;
  gender: 'Male' | 'Female' | 'Mixed';
  minLevel: number;
  maxLevel: number;
  fee: number;
  location: string;
  type: 'Singles' | 'Doubles' | 'Mixed Doubles';
  image: string;
  spotsLeft: number;
  featured?: boolean;
}

export default function HomePagee() {
  // Sample tournament data
  const tournaments: Tournament[] = [
    {
      id: 1,
      name: 'Summer Pickleball Championship',
      date: '2025-06-15',
      gender: 'Mixed',
      minLevel: 3.0,
      maxLevel: 4.5,
      fee: 50,
      location: 'Hanoi Sports Center',
      type: 'Doubles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 12,
      featured: true,
    },
    {
      id: 2,
      name: 'Beginner Friendly Tournament',
      date: '2025-05-20',
      gender: 'Mixed',
      minLevel: 2.0,
      maxLevel: 3.0,
      fee: 30,
      location: 'Ho Chi Minh City Courts',
      type: 'Singles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 8,
    },
    {
      id: 3,
      name: "Women's Pickleball Challenge",
      date: '2025-07-10',
      gender: 'Female',
      minLevel: 3.5,
      maxLevel: 5.0,
      fee: 45,
      location: 'Da Nang Beach Courts',
      type: 'Doubles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 16,
      featured: true,
    },
    {
      id: 4,
      name: "Men's Pro Tournament",
      date: '2025-08-05',
      gender: 'Male',
      minLevel: 4.0,
      maxLevel: 5.0,
      fee: 75,
      location: 'Hanoi Elite Club',
      type: 'Singles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 4,
    },
    {
      id: 5,
      name: 'Family Pickleball Day',
      date: '2025-06-30',
      gender: 'Mixed',
      minLevel: 2.0,
      maxLevel: 4.0,
      fee: 25,
      location: 'Nha Trang Community Center',
      type: 'Mixed Doubles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 20,
    },
    {
      id: 6,
      name: 'Corporate Challenge Cup',
      date: '2025-09-15',
      gender: 'Mixed',
      minLevel: 3.0,
      maxLevel: 4.0,
      fee: 60,
      location: 'Hanoi Business Park',
      type: 'Doubles',
      image: '/placeholder.svg?height=200&width=300',
      spotsLeft: 10,
    },
  ];

  // Filter states
  const [searchTerm, setSearchTerm] = useState('');
  const [genderFilter, setGenderFilter] = useState<string | null>(null);
  const [typeFilter, setTypeFilter] = useState<string | null>(null);
  const [levelRange, setLevelRange] = useState<[number, number]>([2.0, 5.0]);
  const [maxFee, setMaxFee] = useState<number | null>(null);
  const [locationFilter, setLocationFilter] = useState<string | null>(null);

  // Filter tournaments based on criteria
  const filteredTournaments = tournaments.filter((tournament) => {
    return (
      (searchTerm === '' ||
        tournament.name.toLowerCase().includes(searchTerm.toLowerCase())) &&
      (genderFilter === null || tournament.gender === genderFilter) &&
      (typeFilter === null || tournament.type === typeFilter) &&
      tournament.minLevel >= levelRange[0] &&
      tournament.maxLevel <= levelRange[1] &&
      (maxFee === null || tournament.fee <= maxFee) &&
      (locationFilter === null || tournament.location === locationFilter)
    );
  });

  // Get unique locations for filter dropdown
  const locations = Array.from(new Set(tournaments.map((t) => t.location)));

  // Featured tournaments
  const featuredTournaments = tournaments.filter((t) => t.featured);

  return (
    <Layout className="min-vh-100">
      {/* Header */}
      <Header
        className="d-flex align-items-center justify-content-between px-4"
        style={{ background: '#fff', boxShadow: '0 2px 8px rgba(0,0,0,0.1)' }}
      >
        <div className="d-flex align-items-center">
          <TrophyOutlined
            style={{ fontSize: '24px', color: '#1890ff', marginRight: '10px' }}
          />
          <Title level={3} style={{ margin: 0 }}>
            PickleBall Tournaments
          </Title>
        </div>
        <Menu
          mode="horizontal"
          defaultSelectedKeys={['home']}
          className="border-0"
        >
          <Menu.Item key="home">Home</Menu.Item>
          <Menu.Item key="tournaments">Tournaments</Menu.Item>
          <Menu.Item key="results">Results</Menu.Item>
          <Menu.Item key="about">About</Menu.Item>
          <Menu.Item key="contact">Contact</Menu.Item>
        </Menu>
        <div>
          <Button type="primary" className="me-2">
            Sign In
          </Button>
          <Button>Register</Button>
        </div>
      </Header>

      <Content>
        {/* Hero Section */}
        <div className="position-relative">
          <div
            style={{
              height: '400px',
              background: 'linear-gradient(135deg, #1890ff 0%, #096dd9 100%)',
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            <div className="container h-100 d-flex flex-column justify-content-center text-white">
              <Row>
                <Col md={12}>
                  <Title
                    level={1}
                    style={{ color: 'white', marginBottom: '20px' }}
                  >
                    Find Your Perfect Pickleball Tournament
                  </Title>
                  <Paragraph style={{ color: 'white', fontSize: '18px' }}>
                    Browse, register, and compete in pickleball tournaments
                    across Vietnam. From beginners to pros, we have tournaments
                    for all skill levels.
                  </Paragraph>
                  <Button
                    type="primary"
                    size="large"
                    style={{
                      background: 'white',
                      color: '#1890ff',
                      borderColor: 'white',
                    }}
                  >
                    Find Tournaments
                  </Button>
                  <Button
                    type="default"
                    size="large"
                    style={{
                      marginLeft: '10px',
                      borderColor: 'white',
                      color: 'white',
                    }}
                  >
                    Host a Tournament
                  </Button>
                </Col>
              </Row>
            </div>
            <div
              className="position-absolute"
              style={{ right: '50px', bottom: '0', opacity: 0.2 }}
            >
              <TeamOutlined style={{ fontSize: '300px', color: 'white' }} />
            </div>
          </div>
        </div>

        {/* Featured Tournaments */}
        {featuredTournaments.length > 0 && (
          <div className="container my-5">
            <Title level={2}>Featured Tournaments</Title>
            <Row gutter={[24, 24]}>
              {featuredTournaments.map((tournament) => (
                <Col key={tournament.id} xs={24} md={12}>
                  <Card
                    hoverable
                    className="h-100"
                    cover={
                      <div style={{ height: '200px', position: 'relative' }}>
                        <Image
                          src={tournament.image || '/placeholder.svg'}
                          alt={tournament.name}
                          style={{
                            width: '100%',
                            height: '100%',
                            objectFit: 'cover',
                          }}
                        />
                        <Badge
                          count="Featured"
                          style={{
                            position: 'absolute',
                            top: '10px',
                            right: '10px',
                            background: '#f50',
                          }}
                        />
                      </div>
                    }
                  >
                    <Title level={4}>{tournament.name}</Title>
                    <div className="mb-2">
                      <CalendarOutlined className="me-2" />
                      <Text>
                        {new Date(tournament.date).toLocaleDateString()}
                      </Text>
                    </div>
                    <div className="mb-2">
                      <EnvironmentOutlined className="me-2" />
                      <Text>{tournament.location}</Text>
                    </div>
                    <div className="d-flex flex-wrap gap-2 mb-3">
                      <Tag color="blue">{tournament.gender}</Tag>
                      <Tag color="green">{tournament.type}</Tag>
                      <Tag color="orange">
                        Level {tournament.minLevel}-{tournament.maxLevel}
                      </Tag>
                      <Tag color="purple">${tournament.fee}</Tag>
                    </div>
                    <div className="d-flex justify-content-between align-items-center">
                      <Text type="secondary">
                        {tournament.spotsLeft} spots left
                      </Text>
                      <Button type="primary">Register Now</Button>
                    </div>
                  </Card>
                </Col>
              ))}
            </Row>
          </div>
        )}

        {/* Tournament Search and Filters */}
        <div className="container my-5">
          <Card className="mb-4">
            <Title level={4}>
              <FilterOutlined /> Filter Tournaments
            </Title>
            <Row gutter={[16, 16]}>
              <Col xs={24} md={8}>
                <Input
                  placeholder="Search tournaments"
                  prefix={<SearchOutlined />}
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </Col>
              <Col xs={24} md={8}>
                <Select
                  placeholder="Select Gender"
                  style={{ width: '100%' }}
                  allowClear
                  onChange={(value) => setGenderFilter(value)}
                >
                  <Option value="Male">Male</Option>
                  <Option value="Female">Female</Option>
                  <Option value="Mixed">Mixed</Option>
                </Select>
              </Col>
              <Col xs={24} md={8}>
                <Select
                  placeholder="Tournament Type"
                  style={{ width: '100%' }}
                  allowClear
                  onChange={(value) => setTypeFilter(value)}
                >
                  <Option value="Singles">Singles</Option>
                  <Option value="Doubles">Doubles</Option>
                  <Option value="Mixed Doubles">Mixed Doubles</Option>
                </Select>
              </Col>
              <Col xs={24} md={8}>
                <Text>Skill Level Range:</Text>
                <Slider
                  range
                  min={2.0}
                  max={5.0}
                  step={0.5}
                  defaultValue={[2.0, 5.0]}
                  onChange={(value) => setLevelRange(value as [number, number])}
                  marks={{
                    2.0: '2.0',
                    3.0: '3.0',
                    4.0: '4.0',
                    5.0: '5.0',
                  }}
                />
              </Col>
              <Col xs={24} md={8}>
                <Select
                  placeholder="Max Entry Fee"
                  style={{ width: '100%' }}
                  allowClear
                  onChange={(value) => setMaxFee(value)}
                >
                  <Option value={25}>$25 or less</Option>
                  <Option value={50}>$50 or less</Option>
                  <Option value={75}>$75 or less</Option>
                  <Option value={100}>$100 or less</Option>
                </Select>
              </Col>
              <Col xs={24} md={8}>
                <Select
                  placeholder="Location"
                  style={{ width: '100%' }}
                  allowClear
                  onChange={(value) => setLocationFilter(value)}
                >
                  {locations.map((location) => (
                    <Option key={location} value={location}>
                      {location}
                    </Option>
                  ))}
                </Select>
              </Col>
            </Row>
          </Card>

          {/* Tournament Listings */}
          <Title level={2}>All Tournaments</Title>
          <Row gutter={[24, 24]}>
            {filteredTournaments.length > 0 ? (
              filteredTournaments.map((tournament) => (
                <Col key={tournament.id} xs={24} sm={12} lg={8}>
                  <Card
                    hoverable
                    className="h-100"
                    cover={
                      <div style={{ height: '200px', position: 'relative' }}>
                        <Image
                          src={tournament.image || '/placeholder.svg'}
                          alt={tournament.name}
                          style={{
                            width: '100%',
                            height: '100%',
                            objectFit: 'cover',
                          }}
                        />
                      </div>
                    }
                  >
                    <Title level={4}>{tournament.name}</Title>
                    <div className="mb-2">
                      <CalendarOutlined className="me-2" />
                      <Text>
                        {new Date(tournament.date).toLocaleDateString()}
                      </Text>
                    </div>
                    <div className="mb-2">
                      <EnvironmentOutlined className="me-2" />
                      <Text>{tournament.location}</Text>
                    </div>
                    <div className="d-flex flex-wrap gap-2 mb-3">
                      <Tag color="blue">{tournament.gender}</Tag>
                      <Tag color="green">{tournament.type}</Tag>
                      <Tag color="orange">
                        Level {tournament.minLevel}-{tournament.maxLevel}
                      </Tag>
                      <Tag color="purple">${tournament.fee}</Tag>
                    </div>
                    <div className="d-flex justify-content-between align-items-center">
                      <Text type="secondary">
                        {tournament.spotsLeft} spots left
                      </Text>
                      <Button type="primary">Register</Button>
                    </div>
                  </Card>
                </Col>
              ))
            ) : (
              <Col span={24} className="text-center py-5">
                <Title level={4}>No tournaments match your filters</Title>
                <Button
                  onClick={() => {
                    setSearchTerm('');
                    setGenderFilter(null);
                    setTypeFilter(null);
                    setLevelRange([2.0, 5.0]);
                    setMaxFee(null);
                    setLocationFilter(null);
                  }}
                >
                  Clear All Filters
                </Button>
              </Col>
            )}
          </Row>
        </div>

        {/* Call to Action */}
        <div
          className="container-fluid py-5 my-5"
          style={{ background: '#f0f5ff' }}
        >
          <div className="container">
            <Row gutter={24} align="middle">
              <Col xs={24} md={16}>
                <Title level={2}>Want to host your own tournament?</Title>
                <Paragraph>
                  We provide all the tools you need to organize and manage
                  successful pickleball tournaments. From registration to
                  brackets, we've got you covered.
                </Paragraph>
              </Col>
              <Col xs={24} md={8} className="text-center">
                <Button type="primary" size="large">
                  Host a Tournament
                </Button>
              </Col>
            </Row>
          </div>
        </div>

        {/* Stats Section */}
        <div className="container my-5">
          <Row gutter={24} className="text-center">
            <Col xs={24} md={8}>
              <Title level={1} style={{ color: '#1890ff' }}>
                150+
              </Title>
              <Title level={4}>Tournaments</Title>
              <Paragraph>Organized across Vietnam</Paragraph>
            </Col>
            <Col xs={24} md={8}>
              <Title level={1} style={{ color: '#1890ff' }}>
                5,000+
              </Title>
              <Title level={4}>Players</Title>
              <Paragraph>Active in our community</Paragraph>
            </Col>
            <Col xs={24} md={8}>
              <Title level={1} style={{ color: '#1890ff' }}>
                25+
              </Title>
              <Title level={4}>Venues</Title>
              <Paragraph>Partner locations nationwide</Paragraph>
            </Col>
          </Row>
        </div>
      </Content>

      {/* Footer */}
      <Footer style={{ background: '#001529', color: 'white' }}>
        <div className="container">
          <Row gutter={24}>
            <Col xs={24} md={8}>
              <Title level={4} style={{ color: 'white' }}>
                <TrophyOutlined /> PickleBall Tournaments
              </Title>
              <Paragraph style={{ color: '#ccc' }}>
                The premier platform for pickleball tournament organization in
                Vietnam. Find, register, and compete in tournaments across the
                country.
              </Paragraph>
            </Col>
            <Col xs={24} md={8}>
              <Title level={4} style={{ color: 'white' }}>
                Quick Links
              </Title>
              <ul className="list-unstyled">
                <li>
                  <a href="#" style={{ color: '#ccc' }}>
                    Home
                  </a>
                </li>
                <li>
                  <a href="#" style={{ color: '#ccc' }}>
                    Find Tournaments
                  </a>
                </li>
                <li>
                  <a href="#" style={{ color: '#ccc' }}>
                    Host a Tournament
                  </a>
                </li>
                <li>
                  <a href="#" style={{ color: '#ccc' }}>
                    Rules & Regulations
                  </a>
                </li>
                <li>
                  <a href="#" style={{ color: '#ccc' }}>
                    About Us
                  </a>
                </li>
              </ul>
            </Col>
            <Col xs={24} md={8}>
              <Title level={4} style={{ color: 'white' }}>
                Contact Us
              </Title>
              <Paragraph style={{ color: '#ccc' }}>
                <EnvironmentOutlined /> 123 Pickleball Street, Hanoi, Vietnam
              </Paragraph>
              <Paragraph style={{ color: '#ccc' }}>
                <MailOutlined /> info@pickleballtournaments.vn
              </Paragraph>
              <Paragraph style={{ color: '#ccc' }}>
                <PhoneOutlined /> +84 123 456 789
              </Paragraph>
            </Col>
          </Row>
          <Divider style={{ borderColor: '#333' }} />
          <div className="text-center" style={{ color: '#ccc' }}>
            &copy; {new Date().getFullYear()} PickleBall Tournaments. All rights
            reserved.
          </div>
        </div>
      </Footer>
    </Layout>
  );
}
