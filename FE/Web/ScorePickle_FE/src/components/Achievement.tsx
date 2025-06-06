import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { motion } from 'framer-motion';
import {
  Card,
  Typography,
  Spin,
  Empty,
  Button,
  Modal,
  Badge,
  Row,
  Col,
  Carousel,
  Tooltip,
} from 'antd';
import {
  TrophyOutlined,
  RightOutlined,
  LeftOutlined,
  EyeOutlined,
} from '@ant-design/icons';
import {
  Achievement as AchievementState,
  useGetAchievementById,
} from '@src/modules/Tournament/hooks/useGetAchievementById';

const { Title, Text, Paragraph } = Typography;

interface AchievementCardProps {
  achievement: AchievementState;
  onClick: () => void;
}

export const AchievementCard = ({
  achievement,
  onClick,
}: AchievementCardProps) => {
  return (
    <motion.div
      whileHover={{ scale: 1.03 }}
      transition={{ type: 'spring', stiffness: 250 }}
    >
      <Card hoverable className="achievement-card" onClick={onClick}>
        <div
          style={{ display: 'flex', alignItems: 'center', marginBottom: 12 }}
        >
          <Badge
            count={<TrophyOutlined />}
            style={{ backgroundColor: '#fadb14' }}
          />
          <Title level={5} style={{ marginLeft: 8, marginBottom: 0 }}>
            {achievement.title}
          </Title>
        </div>

        <Paragraph ellipsis={{ rows: 2 }}>{achievement.description}</Paragraph>

        <Text type="secondary">
          Awarded: {new Date(achievement.awardedAt).toLocaleDateString()}
        </Text>
      </Card>
    </motion.div>
  );
};

export interface AchievementProps {
  userId: number;
}

const Achievement: React.FC<AchievementProps> = ({ userId }) => {
  const {
    data: achievements = [],
    isLoading,
    refetch,
  } = useGetAchievementById(userId || -1);

  const [selectedAchievement, setSelectedAchievement] =
    useState<AchievementState | null>(null);
  const [modalVisible, setModalVisible] = useState(false);
  const [allModalVisible, setAllModalVisible] = useState(false);

  // Reference to the carousel
  const carouselRef = React.useRef<any>(null);

  // Functions to control the carousel
  const nextSlide = () => {
    carouselRef.current?.next();
  };

  const prevSlide = () => {
    carouselRef.current?.prev();
  };

  const handleAchievementClick = (achievement) => {
    setSelectedAchievement(achievement);
    setModalVisible(true);
  };

  const handleViewAllClick = () => {
    setAllModalVisible(true);
  };

  if (isLoading) {
    return null;
  }

  if (!achievements || achievements.length === 0) {
    return null;
  }

  return (
    <div className="achievement-container">
      <div style={{ padding: '10px 0', position: 'relative' }}>
        <Carousel
          autoplay
          ref={carouselRef}
          slidesToShow={Math.min(3, achievements.length)}
          dots={achievements.length > 3}
          autoplaySpeed={4000}
        >
          {achievements.map((achievement) => (
            <div key={achievement.id} style={{ padding: '0 8px' }}>
              <AchievementCard
                achievement={achievement}
                onClick={() => handleAchievementClick(achievement)}
              />
            </div>
          ))}
        </Carousel>

        {achievements.length > 3 && (
          <>
            <Button
              className="carousel-button prev"
              onClick={prevSlide}
              icon={<LeftOutlined />}
              type="primary"
              shape="circle"
              style={{
                position: 'absolute',
                left: 0,
                top: '50%',
                transform: 'translateY(-50%)',
                zIndex: 2,
              }}
            />
            <Button
              className="carousel-button next"
              onClick={nextSlide}
              icon={<RightOutlined />}
              type="primary"
              shape="circle"
              style={{
                position: 'absolute',
                right: 0,
                top: '50%',
                transform: 'translateY(-50%)',
                zIndex: 2,
              }}
            />
          </>
        )}
      </div>
    </div>
  );
};

export default Achievement;
