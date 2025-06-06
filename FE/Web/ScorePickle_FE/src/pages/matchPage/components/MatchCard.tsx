import type React from 'react';
import { Button, Avatar, Badge } from 'antd';
import { PlayCircleFilled } from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';
import './match-scoreboard.css';

interface TeamProps {
  name: string;
  subTitle: string;
  position: number;
  score: number;
  avatarUrl: string;
}

interface MatchScoreboardProps {
  matchId: string;
  venue: string;
  timer: string;
  isLive: boolean;
  teamA: TeamProps;
  teamB: TeamProps;
}

export const MatchScoreboard: React.FC<MatchScoreboardProps> = ({
  matchId,
  venue,
  timer,
  isLive,
  teamA,
  teamB,
}) => {
  return (
    <div className="scoreboard-container">
      <div className="scoreboard-header d-flex justify-content-between align-items-center">
        <div className="d-flex align-items-center">
          <Badge status="success" />
          <span className="match-id ms-2">{matchId}</span>
          <PlayCircleFilled
            className="play-icon ms-2"
            style={{ color: '#4CAF50' }}
          />
          <span className="timer ms-2">{timer}</span>
        </div>
        <div className="d-flex align-items-center">
          <span className="venue me-3">{venue}</span>
          <Button type="primary" danger shape="round" className="live-button">
            {isLive ? 'Trực tiếp' : 'Offline'}
          </Button>
        </div>
      </div>

      <div className="scoreboard-body">
        <TeamRow team={teamA} />
        <TeamRow team={teamB} />
      </div>
    </div>
  );
};

const TeamRow: React.FC<{ team: TeamProps }> = ({ team }) => {
  return (
    <div className="team-row d-flex justify-content-between align-items-center my-2">
      <div className="d-flex align-items-center">
        <div className="team-avatars">
          <Avatar src={team.avatarUrl} size={40} className="team-avatar" />
          <Avatar
            className="player-avatar"
            size={24}
            style={{
              marginLeft: -15,
              marginTop: 15,
              border: '2px solid white',
            }}
          />
        </div>
        <div className="team-info ms-2">
          <div className="team-name">{team.name}</div>
          <div className="team-subtitle">{team.subTitle}</div>
        </div>
      </div>
      <div className="d-flex align-items-center">
        <div className="position-badge me-3">{team.position}</div>
        <div className="score-badge">{team.score}</div>
      </div>
    </div>
  );
};

export default MatchScoreboard;
