'use client';

import type React from 'react';
import { useState } from 'react';
import { Button, Card, Row, Col, Badge, Typography, Spin } from 'antd';
import { LeftOutlined, RightOutlined } from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';
import './match-calendar.css';
import { RootState } from '@src/redux/store';
import { useSelector } from 'react-redux';
import { useGetMatchByUserId } from '@src/modules/Match/hooks/useGetMatchByUserId';
import { MatchCategory, Matches } from '@src/modules/Match/models';
import { useNavigate } from 'react-router-dom';

const { Title } = Typography;

// Define types
interface MatchEvent {
  type: MatchCategory;
  match: Matches;
}

interface CalendarDay {
  day: number;
  events: MatchEvent[];
}

// Custom styles to avoid any color imports
const styles = {
  container: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '20px',
  },
  title: {
    marginBottom: '20px',
  },
  viewSelector: {
    display: 'flex',
    gap: '10px',
    marginBottom: '1rem',
  },
  viewButton: {
    borderRadius: '20px',
  },
  calendarCard: {
    borderRadius: '8px',
  },
  monthHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '1rem',
  },
  monthTitle: {
    margin: 0,
  },
  navButtons: {
    display: 'flex',
    gap: '10px',
  },
  calendarHeader: {
    fontWeight: 'bold',
    marginBottom: '10px',
    textAlign: 'center' as const,
  },
  calendarWeek: {
    minHeight: '100px',
  },
  calendarCell: {
    border: '1px solid #f0f0f0',
    padding: 0,
  },
  calendarDay: {
    height: '100%',
    minHeight: '100px',
    padding: '8px',
    position: 'relative' as const,
  },
  emptyDay: {
    height: '100%',
    minHeight: '100px',
    padding: '8px',
    position: 'relative' as const,
    backgroundColor: '#fafafa',
  },
  dayNumber: {
    fontWeight: 'bold',
    marginBottom: '8px',
  },
  matchLabel: {
    fontSize: '12px',
    color: '#666',
    backgroundColor: '#f9f9f9',
    padding: '2px 6px',
    borderRadius: '4px',
    display: 'inline-block',
  },
  tournamentEvent: {
    marginTop: '4px',
  },
  tournamentBadge: {
    marginBottom: '4px',
  },
  tournamentTitle: {
    fontSize: '12px',
    color: '#ff8c00',
  },
  yourMatch: {
    backgroundColor: '#f0f0f0',
    padding: '6px',
    borderRadius: '4px',
    marginTop: '4px',
  },
  yourMatchBadge: {
    marginBottom: '4px',
  },
  matchTime: {
    fontSize: '12px',
    color: '#333',
  },
};

const MatchCalendar: React.FC = () => {
  //const [activeView, setActiveView] = useState<string>('Monthly View');
  const navigate = useNavigate();
  const [currentMonth, setCurrentMonth] = useState<string>(
    `${new Date().toLocaleString('default', {
      month: 'long',
    })} ${new Date().getFullYear()}`
  );
  const [currentDate, setCurrentDate] = useState<Date>(new Date());
  const user = useSelector((state: RootState) => state.auth.user);
  const { data: matches, isLoading } = useGetMatchByUserId(user?.id ?? 0);

  if (isLoading) {
    return (
      <>
        <div
          className="d-flex justify-content-center align-items-center"
          style={{ height: '100vh' }}
        >
          <Spin size="large" />
        </div>
      </>
    );
  }

  // Sample data for March 2025
  const generateCalendarData = (
    year: number,
    month: number
  ): CalendarDay[][] => {
    // This represents the calendar grid (6 rows x 7 columns)
    const weeks: CalendarDay[][] = [];
    const monthMatches = (matches ?? []).filter((m) => {
      const d = new Date(m.matchDate);
      return d.getFullYear() === year && d.getMonth() === month;
    });

    // 2. Tính số ngày, và thứ của ngày 1
    const firstOfMonth = new Date(year, month, 1);
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    // Chuyển getDay() (0=CN,…6=T7) -> idx 0=Thứ 2,…6=Chủ nhật
    const firstDayIdx =
      firstOfMonth.getDay() === 0 ? 6 : firstOfMonth.getDay() - 1;

    let currentWeek: CalendarDay[] = [];

    // 3. Đặt ô trống đầu tuần nếu ngày 1 không rơi đúng Thứ Hai
    for (let i = 0; i < firstDayIdx; i++) {
      currentWeek.push({ day: 0, events: [] });
    }

    // 4. Duyệt từng ngày, tạo ô và đẩy sự kiện vào
    for (let day = 1; day <= daysInMonth; day++) {
      // Tìm match cùng ngày
      const todayEvents: MatchEvent[] = monthMatches
        .filter((m) => new Date(m.matchDate).getDate() === day)
        .map((m) => ({ type: m.matchCategory, match: m }));

      currentWeek.push({ day, events: todayEvents });

      // Khi đủ 7 ô thành một tuần, đẩy vào weeks và reset
      if (currentWeek.length === 7) {
        weeks.push(currentWeek);
        currentWeek = [];
      }
    }

    // 5. Cuối cùng, nếu tuần cuối chưa đủ 7 ô thì lấp ô trống
    if (currentWeek.length > 0) {
      while (currentWeek.length < 7) {
        currentWeek.push({ day: 0, events: [] });
      }
      weeks.push(currentWeek);
    }

    return weeks;
  };

  const calendarData = generateCalendarData(
    currentDate.getFullYear(),
    currentDate.getMonth()
  );

  const handlePrevMonth = () => {
    // In a real app, this would change to the previous month
    const currentDate = new Date();
    currentDate.setMonth(currentDate.getMonth() - 1); // Trừ đi 1 tháng

    setCurrentMonth(
      `${currentDate.toLocaleString('default', {
        month: 'long',
      })} ${currentDate.getFullYear()}`
    );
    setCurrentDate((prev) => {
      const d = new Date(prev);
      d.setMonth(d.getMonth() - 1); // or +1
      return d;
    });
  };

  const handleNextMonth = () => {
    // In a real app, this would change to the next month
    const currentDate = new Date();
    currentDate.setMonth(currentDate.getMonth() + 1);

    setCurrentMonth(
      `${currentDate.toLocaleString('default', {
        month: 'long',
      })} ${currentDate.getFullYear()}`
    );
    setCurrentDate((prev) => {
      const d = new Date(prev);
      d.setMonth(d.getMonth() + 1); // or +1
      return d;
    });
  };

  // const handleViewChange = (view: string) => {
  //   setActiveView(view);
  // };

  const renderDayCell = (day: CalendarDay) => {
    if (day.day === 0) {
      return <div style={styles.emptyDay}></div>;
    }

    return (
      <div style={styles.calendarDay}>
        <div style={styles.dayNumber}>{day.day}</div>
        {day.events.map((event, index) => (
          // ← đây là chỗ thêm onClick
          <div
            key={index}
            style={{ cursor: 'pointer' }}
            onClick={() =>
              navigate(`/match-detail/${event.match.id}`, {
                state: { match: event.match },
              })
            }
          >
            {event.type === MatchCategory.Competitive && (
              //<div style={styles.matchLabel}>{event.match.title}</div>
              <div style={styles.yourMatch}>
                <Badge color="cyan" text="Competitive" />
                <div style={styles.matchTime}>{event.match.title}</div>
                <div
                  style={styles.matchTime}
                  className="bg-info rounded-pill d-flex justify-content-center align-items-center"
                >
                  {`${new Date(event.match.matchDate)
                    .getHours()
                    .toString()
                    .padStart(2, '0')}:
                    ${new Date(event.match.matchDate)
                      .getMinutes()
                      .toString()
                      .padStart(2, '0')}`}
                </div>
              </div>
            )}

            {event.type === MatchCategory.Tournament && (
              <div style={styles.yourMatch}>
                <Badge
                  color="orange"
                  text="Tournament"
                  style={styles.tournamentBadge}
                />
                <div style={styles.matchTime}>{event.match.title}</div>
                <div
                  style={{ ...styles.matchTime, background: 'orange' }}
                  className="rounded-pill d-flex justify-content-center align-items-center"
                >
                  {`${new Date(event.match.matchDate)
                    .getHours()
                    .toString()
                    .padStart(2, '0')}:
                    ${new Date(event.match.matchDate)
                      .getMinutes()
                      .toString()
                      .padStart(2, '0')}`}
                </div>
              </div>
            )}
            {event.type === MatchCategory.Custom && (
              <div style={styles.yourMatch}>
                <Badge
                  color="pink"
                  text="Friendly"
                  style={styles.yourMatchBadge}
                />
                <div style={styles.matchTime}>{event.match.title}</div>
                <div
                  style={{ ...styles.matchTime, background: 'pink' }}
                  className="rounded-pill d-flex justify-content-center align-items-center"
                >
                  {`${new Date(event.match.matchDate)
                    .getHours()
                    .toString()
                    .padStart(2, '0')}:
                    ${new Date(event.match.matchDate)
                      .getMinutes()
                      .toString()
                      .padStart(2, '0')}`}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    );
  };

  return (
    <div style={styles.container} className="mt-5">
      <Title level={2} style={styles.title} className="text-white">
        Match Calendar
      </Title>

      <div style={styles.viewSelector}></div>

      <Card style={styles.calendarCard}>
        <div style={styles.monthHeader}>
          <Title level={3} style={styles.monthTitle}>
            {currentMonth}
          </Title>
          <div style={styles.navButtons}>
            <Button icon={<LeftOutlined />} onClick={handlePrevMonth} />
            <Button icon={<RightOutlined />} onClick={handleNextMonth} />
          </div>
        </div>

        <div>
          <Row>
            <Col span={3} style={styles.calendarHeader}>
              Sun
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Mon
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Tue
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Wed
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Thu
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Fri
            </Col>
            <Col span={3} style={styles.calendarHeader}>
              Sat
            </Col>
          </Row>

          {calendarData.map((week, weekIndex) => (
            <Row key={weekIndex} style={styles.calendarWeek}>
              {week.map((day, dayIndex) => (
                <Col key={dayIndex} span={3} style={styles.calendarCell}>
                  {renderDayCell(day)}
                </Col>
              ))}
            </Row>
          ))}
        </div>
      </Card>
    </div>
  );
};

export default MatchCalendar;
