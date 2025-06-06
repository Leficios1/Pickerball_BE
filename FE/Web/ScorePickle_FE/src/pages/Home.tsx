import { Button, Col, Flex, Image, Row, Typography, Card, Divider } from 'antd';
import { useMediaQuery } from 'react-responsive';
import { Link } from 'react-router-dom';
import { ApartmentOutlined, FormOutlined, CheckCircleOutlined } from '@ant-design/icons';
import { Container } from '../components';
import { PATH_RULE_PAGE, PATH_TOURNAMENT_PAGE } from '@src/constants/routes';
import scorePickleImage from '@src/assets/images/ScorePickle.png';
import { UpcomingEvent } from './home/UpcomingEvent';
import { useGetAllTournamentsForHomePage } from '@src/modules/Tournament/hooks/useGetAllTournaments';
import FooterCustom from '@components/Footer/FooterCustom';
import { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { prefetchListMatchAndScore } from '@src/modules/Match/hooks/useGetListMatchesAndScore';
import { motion } from 'framer-motion';

const { Title, Text } = Typography;

const features = [
  'Track your tournament history and ranking',
  'Join competitions based on your level',
  'Real-time score tracking & match calendar',
  'Mobile-friendly and easy to use',
];

export const HomePage = () => {
  const isMobile = useMediaQuery({ maxWidth: 769 });
  const isTablet = useMediaQuery({ maxWidth: 992 });
  const { data } = useGetAllTournamentsForHomePage();
  const tournaments = (data ?? []).slice(0, 6);

  const user = useSelector((state: RootState) => state.auth.user);
  useEffect(() => {
    if (user?.id) {
      prefetchListMatchAndScore(user.id);
    }
  }, [user?.id]);

  return (
    <div
      style={{
        background: 'linear-gradient(to right, rgb(30, 58, 138), rgb(59, 130, 246))',
        borderRadius: 6,
        transition: '0.25s',
        paddingBottom: '10rem',
        paddingTop: 80,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        minHeight: '100vh',
      }}
    >
      <Flex
        vertical
        align="center"
        justify="center"
        style={{
          height: isTablet ? 600 : 800,
          width: '100%',
          padding: isMobile ? '2rem 1rem' : '5rem 0',
        }}
      >
        <Container>
          <Row style={{ alignItems: 'center' }} className="me-2">
            <Col lg={12}>
              <motion.div
                initial={{ opacity: 0, y: 40 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
              >
                <Title
                  style={{
                    fontSize: isMobile ? 36 : 40,
                    fontWeight: 900,
                    margin: '1.5rem 0',
                  }}
                >
                  <span style={{ color: 'rgba(0, 247, 255, 0.85)' }}>
                    ScorePickle
                  </span>
                  <br />
                  <span className="text-white fw-semibold">
                    Pickleball Tournament and Level Progression System
                  </span>
                </Title>
                <Text
                  style={{ fontSize: 20, marginBottom: '1.5rem', color: 'white' }}
                >
                  Find matches, join tournaments, and connect with players who
                  share your passion for pickleball.
                </Text>
                <Flex
                  gap="middle"
                  vertical={isMobile}
                  style={{ marginTop: '1.5rem' }}
                >
                  <Link to={PATH_RULE_PAGE.root}>
                    <Button
                      icon={<FormOutlined />}
                      type="primary"
                      size="large"
                      block={isMobile}
                    >
                      ScorePickle Rule
                    </Button>
                  </Link>
                  <Link to={PATH_TOURNAMENT_PAGE.root}>
                    <Button
                      icon={<ApartmentOutlined />}
                      type="default"
                      size="large"
                      block={isMobile}
                    >
                      View Tournaments
                    </Button>
                  </Link>
                </Flex>
              </motion.div>
            </Col>
            {!isTablet && (
              <Col lg={12}>
                <motion.div
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ duration: 0.8 }}
                >
                  <Image src={scorePickleImage} alt="ScorePickle Image" preview={false} />
                </motion.div>
              </Col>
            )}
          </Row>
        </Container>
      </Flex>

      <UpcomingEvent rows={tournaments} />

      {/* Feature Section */}
      <div style={{ padding: '80px 0' }}>
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 60 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7 }}
          >
            <Title level={2} style={{ color: 'white', textAlign: 'center' }}>
              Why Choose <span style={{ color: '#0ff' }}>ScorePickle</span>?
            </Title>
            <Row gutter={[32, 32]} justify="center" style={{ marginTop: 40 }}>
              {features.map((f, index) => (
                <Col xs={24} sm={12} md={8} lg={6} key={index}>
                  <Card
                    bordered={false}
                    style={{
                      borderRadius: 6,
                      background: 'rgba(255,255,255,0.05)',
                      color: 'white',
                      height: '100%',
                      transition: '0.3s',
                    }}
                    hoverable
                  >
                    <CheckCircleOutlined style={{ fontSize: 24, color: '#0ff' }} />
                    <Text style={{ color: 'white', display: 'block', marginTop: 12 }}>
                      {f}
                    </Text>
                  </Card>
                </Col>
              ))}
            </Row>
          </motion.div>
        </Container>
      </div>

      {/* About Section */}
      <div style={{ padding: '80px 0' }}>
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 60 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7 }}
          >
            <Row gutter={[32, 32]} align="middle">
              <Col xs={24} md={12}>
                <Title level={2} style={{ color: '#0ff' }}>
                  About ScorePickle
                </Title>
                <Text style={{ color: 'white', fontSize: 16 }}>
                  ScorePickle is your go-to platform for everything pickleball. Whether
                  you're a casual player or a seasoned competitor, we provide a seamless
                  way to discover, join, and track pickleball tournaments nationwide.
                </Text>
              </Col>
              <Col xs={24} md={12}>
                <Image
                  src={scorePickleImage}
                  alt="About ScorePickle"
                  preview={false}
                  style={{ borderRadius: 6 }}
                />
              </Col>
            </Row>
          </motion.div>
        </Container>
      </div>
            {/* Testimonials Section */}
            <div style={{ padding: '80px 0' }}>
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 60 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7 }}
          >
            <Title level={2} style={{ color: 'white', textAlign: 'center' }}>
              What Players Say About <span style={{ color: '#0ff' }}>ScorePickle</span>
            </Title>
            <Row gutter={[32, 32]} style={{ marginTop: 40 }}>
              {[
                {
                  name: 'Anna Nguyen',
                  feedback:
                    'ScorePickle helped me find the right tournaments and track my performance better than any app I used before.',
                },
                {
                  name: 'John Smith',
                  feedback:
                    'Great interface, reliable features, and real-time tracking. Highly recommend for all pickleball players!',
                },
              ].map((testimonial, idx) => (
                <Col xs={24} md={12} key={idx}>
                  <Card
                    style={{
                      background: 'rgba(255,255,255,0.05)',
                      borderRadius: 6,
                      color: 'white',
                      height: '100%',
                    }}
                  >
                    <Text style={{ color: '#0ff', fontWeight: 'bold', fontSize: 16 }}>
                      {testimonial.name}
                    </Text>
                    <p style={{ color: 'white', marginTop: 12 }}>{testimonial.feedback}</p>
                  </Card>
                </Col>
              ))}
            </Row>
          </motion.div>
        </Container>
      </div>

      {/* FAQ Section */}
      <div style={{ padding: '80px 0' }}>
        <Container>
          <motion.div
            initial={{ opacity: 0, y: 60 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.7 }}
          >
            <Title level={2} style={{ color: 'white', textAlign: 'center' }}>
              Frequently Asked Questions
            </Title>
            <Row justify="center" style={{ marginTop: 40 }}>
              <Col xs={24} md={20}>
                <Card
                  style={{
                    background: 'rgba(255,255,255,0.05)',
                    borderRadius: 6,
                    color: 'white',
                  }}
                  bodyStyle={{ color: 'white' }}
                >
                  <Title level={4} style={{ color: '#0ff' }}>
                    How do I join a tournament?
                  </Title>
                  <Text style={{ color: 'white' }}>
                    Go to the Tournaments page, select a tournament that fits your level, and click “Join”.
                  </Text>
                  <Divider style={{ backgroundColor: '#0ff' }} />
                  <Title level={4} style={{ color: '#0ff' }}>
                    Can I host my own tournament?
                  </Title>
                  <Text style={{ color: 'white' }}>
                    Yes! Simply register with your email and our team will get in touch to help you organize it.
                  </Text>
                  <Divider style={{ backgroundColor: '#0ff' }} />
                  <Title level={4} style={{ color: '#0ff' }}>
                    Is ScorePickle free to use?
                  </Title>
                  <Text style={{ color: 'white' }}>
                    Absolutely. ScorePickle is free for all players. Organizers may have additional premium options.
                  </Text>
                </Card>
              </Col>
            </Row>
          </motion.div>
        </Container>
      </div>


      <FooterCustom />
    </div>
  );
};

