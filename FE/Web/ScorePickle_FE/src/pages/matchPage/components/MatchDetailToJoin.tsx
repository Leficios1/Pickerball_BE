import React from 'react';
import { useState } from 'react';
import {
  Input,
  DatePicker,
  Avatar,
  Radio,
  Collapse,
  Typography,
  Tag,
} from 'antd';
import { UserOutlined } from '@ant-design/icons';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'antd/dist/reset.css';
import type { CollapseProps } from 'antd';
import dayjs from 'dayjs';
import { MatchCategory, MatchFormat, Member } from '@src/modules/Match/models';
import { useParams } from 'react-router-dom';
import { useGetMatchDetail } from '@src/modules/Match/hooks/useGetMatchDetail';

const { Title, Text } = Typography;

export const MatchDetailToJoin: React.FC = () => {
  const [activeKey, setActiveKey] = useState<string | string[]>(['1']);
  const { id } = useParams<{ id: string }>();
  const { data } = useGetMatchDetail(Number(id || 0));

  // Safely extract members for each team
  if (data === undefined) {
    return;
  }
  const team1Members: Member[] = Array.isArray(data.teams[0]?.members)
    ? data.teams[0].members
    : [];
  const team2Members: Member[] = Array.isArray(data.teams[1]?.members)
    ? data.teams[1].members
    : [];

  // Helper to render a single member
  const renderMember = (member: Member) => {
    const pd = member.playerDetails || {};
    if (!pd) return null;
    const name =
      pd.firstName || pd.lastName
        ? `${pd.firstName ?? ''} ${pd.lastName ?? ''}`.trim()
        : pd.name || `Player ${member.playerId}`;
    const avatarUrl = pd.avatarUrl || undefined;
    const level = pd.userDetails?.experienceLevel ?? 0;

    return (
      <div
        key={member.id}
        className="selected-player border p-2 rounded-pill mb-2"
        style={{ background: 'rgba(177, 177, 177, 0.5)' }}
      >
        <Avatar
          src={avatarUrl}
          icon={!avatarUrl ? <UserOutlined /> : undefined}
        />
        <span className="ms-2">{name}</span>
        <Tag color="blue" className="ms-3">
          {level}
        </Tag>
      </div>
    );
  };

  const items: CollapseProps['items'] = [
    {
      key: '1',
      label: (
        <Title level={4} style={{ margin: 0 }}>
          Match
        </Title>
      ),
      children: (
        <div className="match-form">
          {/* Match Info Row */}
          <div className="row mb-4">
            <div className="col-md-12">
              <span className="form-label">Title</span>
              <Text className="rounded-pill p-3">{data.title}</Text>
            </div>
            <div className="col-md-4">
              <label className="form-label">Description</label>
              <Input
                className="rounded-pill p-3"
                value={data.description}
                readOnly
              />
            </div>
            <div className="col-md-4">
              <label className="form-label">Date</label>
              <DatePicker
                className="w-100 rounded-pill p-3"
                value={dayjs(data.matchDate)}
                showTime={{ format: 'HH:mm' }}
                format="YYYY-MM-DD HH:mm"
                disabled
              />
            </div>
          </div>

          {/* Teams and Players */}
          <div className="row mb-4">
            <div className="col-md-6">
              <label className="form-label">
                {data.matchFormat === MatchFormat.SingleFemale ||
                data.matchFormat === MatchFormat.SingleMale
                  ? 'Player 1'
                  : 'Team 1'}
              </label>
              {team1Members.map(renderMember)}

              <label className="form-label">
                {data.matchFormat === MatchFormat.SingleFemale ||
                data.matchFormat === MatchFormat.SingleMale
                  ? 'Player 2'
                  : 'Team 2'}
              </label>
              {team2Members.map(renderMember)}
            </div>

            {/* Match Settings */}
            <div className="col-md-6">
              <div className="d-flex justify-content-between align-items-center my-3">
                <label className="form-label">Match Category</label>
                <Radio.Group value={data.matchCategory} disabled>
                  <Radio.Button value={MatchCategory.Competitive}>
                    Competitive
                  </Radio.Button>
                  <Radio.Button value={MatchCategory.Custom}>
                    Friendly
                  </Radio.Button>
                </Radio.Group>
              </div>

              <div className="d-flex justify-content-between align-items-center mb-3">
                <label className="form-label">Match Type</label>
                <Text>{data.matchFormat}</Text>
              </div>

              <div className="d-flex justify-content-between align-items-center mb-3">
                <label className="form-label">Score to Win</label>
                <Text>{data.winScore}</Text>
              </div>

              {/* <div className="d-flex justify-content-between align-items-center mb-3">
                <label className="form-label">Venue</label>
                <Card>
                        <Image src={data.venue.urlImage} />
                        <br />
                        <Text>{venue.name}</Text>
                      </Card>
              </div> */}

              <div className="d-flex justify-content-between align-items-center mb-3">
                <label className="form-label">Referee</label>
                <Text>{data.refereeId ? `ID: ${data.refereeId}` : 'TBD'}</Text>
              </div>
            </div>
          </div>
        </div>
      ),
    },
  ];

  return (
    <div className="container p-5">
      <div className="d-flex justify-content-between align-items-center">
        <h1 className="display-4 fw-bold mb-4 text-white">Match Detail</h1>
      </div>
      <div className="p-3 bg-light">
        <Collapse
          items={items}
          activeKey={activeKey}
          onChange={setActiveKey as (key: string | string[]) => void}
          bordered={false}
        />
      </div>
    </div>
  );
};

export default MatchDetailToJoin;
