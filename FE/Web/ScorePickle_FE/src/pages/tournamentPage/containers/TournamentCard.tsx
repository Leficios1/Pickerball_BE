import {
  CalendarOutlined,
  DollarOutlined,
  EnvironmentOutlined,
  TeamOutlined,
  TrophyOutlined,
} from '@ant-design/icons';
import { Badge, Divider, Tag } from 'antd';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import './TournamentCard.css';

export const TournamentCard = ({
  id,
  title,
  dates,
  location,
  type,
  registeredCount,
  skillLevels,
  entryFee,
  status,
  banner,
}) => {
  // Status badge type based on status
  const getStatusBadge = (
    status
  ): {
    color:
      | 'processing'
      | 'success'
      | 'default'
      | 'warning'
      | 'error'
      | undefined;
    text: string;
  } => {
    switch (status) {
      case 'Scheduled':
        return { color: 'processing', text: 'Coming Soon' };
      case 'Ongoing':
        return { color: 'success', text: 'Ongoing' };
      case 'Completed':
        return { color: 'default', text: 'Completed' };
      default:
        return { color: 'warning', text: status };
    }
  };

  const statusConfig = getStatusBadge(status);

  // Tournament type based styling
  const isDoubles = type.toLowerCase().includes('doubles');

  return (
    <motion.div
      className="tournament-card-container"
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      whileHover={{ y: -5 }}
    >
      <div className="tournament-card">
        <div className="tournament-card-header">
          <div className="header-content">
            <div className="title-area">
              <h4 className="tournament-title">{title}</h4>
              <Badge
                status={statusConfig.color}
                text={<span className="status-badge">{statusConfig.text}</span>}
              />
            </div>
            <Tag
              color={isDoubles ? 'purple' : 'blue'}
              className="tournament-type"
            >
              {type}
            </Tag>
          </div>
        </div>

        <img
          src={banner}
          alt=""
          height={'300px'}
          width={'100%'}
          style={{
            objectFit: 'cover',
            borderRadius: '8px',
            marginBottom: '16px',
          }}
        />

        <div className="tournament-info-section">
          <div className="tournament-meta">
            <div className="meta-row">
              <div className="meta-item">
                <CalendarOutlined className="meta-icon" />
                <span>{dates}</span>
              </div>
              <div className="meta-item">
                <EnvironmentOutlined className="meta-icon" />
                <span>{location}</span>
              </div>
              <div className="meta-item">
                <TeamOutlined className="meta-icon" />
                <span>Maximum Teams: {registeredCount}</span>
              </div>
            </div>
          </div>

          <Divider className="card-divider" />

          <div className="tournament-stats">
            <div className="stats-row">
              <div className="stat-item">
                <TrophyOutlined className="stat-icon" />
                <span className="stat-label">Skill Levels:</span>
                <span className="stat-value">
                  {skillLevels !== 'null - null' ? skillLevels : 'All'}
                </span>
              </div>
              <div className="stat-item">
                <DollarOutlined className="stat-icon" />
                <span className="stat-label">Entry Fee:</span>
                <span className="stat-value">
                  {entryFee.toLocaleString('vi-VN')}₫
                </span>
              </div>
            </div>
          </div>
        </div>

        <div className="tournament-card-footer">
          <Link to={`/tournament-detail/${id}`} className="btn-detail">
            View Details
          </Link>
        </div>
      </div>
    </motion.div>
  );
};
