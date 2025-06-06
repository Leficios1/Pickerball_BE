'use client';

import type React from 'react';
import { Card, Typography, Row, Col } from 'antd';
import { ArrowRightOutlined } from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';
import { Tournament } from '@src/modules/Tournament/models';
import { useNavigate } from 'react-router-dom';
import { Link } from 'react-router-dom';
import { PATH_TOURNAMENT_PAGE } from '@src/constants/routes';
import { Container } from '@src/components';

const { Title, Text } = Typography;

interface ChampionshipCardProps {
  rows: Tournament[];
}

export const UpcomingEvent: React.FC<ChampionshipCardProps> = ({ rows }) => {
  const navigate = useNavigate();
  function formatDateRange(startDate, endDate) {
    const options: Intl.DateTimeFormatOptions = {
      month: 'long',
      day: 'numeric',
    };

    const start = new Date(startDate);
    const end = new Date(endDate);

    const startMonthDay = start.toLocaleDateString('en-US', options);
    const endMonthDay = end.toLocaleDateString('en-US', options);

    return `${startMonthDay} - ${endMonthDay}`;
  }
  return (
    <>
      <Container>
        <Title level={2}>
          <Link
            to={PATH_TOURNAMENT_PAGE.root}
            className="text-decoration-none"
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            <Typography
              style={{
                fontSize: 50,
                color: 'rgba(0, 247, 255, 0.85)',
                textAlign: 'center',
              }}
              className="d-inline color-primary mb-3"
            >
              UPCOMING TOURNAMENTS
            </Typography>
          </Link>
        </Title>
        <Row gutter={[20, 20]}>
          {rows.map((item) => (
            <Col
              span={8}
              onClick={() => navigate(`/tournament-detail/${item.id}`)}
            >
              <Card
                className="p-0 border-0 shadow-sm"
                bodyStyle={{ padding: 0 }}
                style={{
                  maxWidth: '560px',
                  overflow: 'hidden',
                  borderRadius: '20px',
                }}
              >
                <div className="row mb-1 mt-2">
                  <div className="col-6">
                    <div className="d-flex justify-content-between align-items-center ps-3 pt-3 card-body">
                      <div className="d-flex flex-column">
                        <div
                          className="rounded-pill d-inline-flex align-items-center px-3 py-2 mb-2"
                          style={{
                            backgroundColor: 'navy',
                            color: 'white',
                            maxWidth: 'fit-content',
                          }}
                        >
                          <Text style={{ color: 'white', margin: 0 }}>
                            {item.status}
                          </Text>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div className="col-6">
                    <div className="d-flex justify-content-between align-items-center card-body pt-3 pe-3">
                      <div className="d-flex flex-column ms-auto me-3">
                        <div
                          style={{
                            color: '#05155e',
                            fontSize: '1.25rem',
                            fontWeight: '700',
                          }}
                        >
                          {formatDateRange(item.startDate, item.endDate)}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="row mt-2">
                  <div className="col-12">
                    <div className="d-flex justify-content-between align-items-center ps-3 card-body">
                      <div className="d-flex flex-column">
                        <Title
                          level={4}
                          style={{
                            color: 'navy',
                            margin: 0,
                            fontWeight: 'bold',
                            fontSize: '1.5rem',
                          }}
                        >
                          {item.name}
                        </Title>
                        <Text style={{ color: 'navy' }}>{item.location}</Text>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="row mb-3">
                  <div className="col-12">
                    <div className="d-flex justify-content-between align-items-center card-body">
                      <div className="d-flex flex-column ms-auto me-4">
                        <ArrowRightOutlined style={{ color: 'navy' }} />
                      </div>
                    </div>
                  </div>
                </div>
              </Card>
            </Col>
          ))}
        </Row>
      </Container>
    </>
  );
};

export default UpcomingEvent;
