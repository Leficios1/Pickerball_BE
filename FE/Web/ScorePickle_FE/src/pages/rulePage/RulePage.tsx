import { useState } from 'react';
import { Tabs, Card, Table, Alert } from 'antd';
import { ExclamationCircleOutlined } from '@ant-design/icons';

export const RulePage = () => {
  const [activeTab, setActiveTab] = useState('scoring');

  return (
    <div className="container mt-4">
      <h1 className="display-4 fw-bold mb-4 text-white">Platform Rules</h1>

      <Tabs defaultActiveKey={activeTab} onChange={setActiveTab}>
        <Tabs.TabPane
          tab={<span className="text-white">Scoring System</span>}
          key="scoring"
        >
          <ScoringSystem />
        </Tabs.TabPane>
        <Tabs.TabPane
          tab={<span className="text-white">Challenge Rules</span>}
          key="challenge"
        >
          <ChallengeRules />
        </Tabs.TabPane>
        <Tabs.TabPane
          tab={<span className="text-white">Tournament Rules</span>}
          key="tournament"
        >
          <TournamentRules />
        </Tabs.TabPane>
        <Tabs.TabPane
          tab={<span className="text-white">Rating Level Rules</span>}
          key="conduct"
        >
          <RankingLevelRules />
        </Tabs.TabPane>
      </Tabs>
    </div>
  );
};

function ScoringSystem() {
  const matchData = [
    {
      key: '1',
      matchType: 'Singles',
      scoringFormat: 'Rally scoring to 11-15-21 points',
      winCondition: 'Win by 2 points, best of 3 games',
    },
    {
      key: '2',
      matchType: 'Doubles',
      scoringFormat: 'Rally scoring to 11-15-21 points',
      winCondition: 'Win by 2 points, best of 3 games',
    },
    {
      key: '3',
      matchType: 'Mixed Doubles',
      scoringFormat: 'Rally scoring to 11-15-21 points',
      winCondition: 'Win by 2 points, best of 3 games',
    },
    {
      key: '4',
      matchType: 'Tournament Finals',
      scoringFormat: 'Rally scoring to 11-15-21 points',
      winCondition: 'Win by 2 points, best of 3 games',
    },
  ];

  const matchColumns = [
    { title: 'Match Type', dataIndex: 'matchType' },
    { title: 'Scoring Format', dataIndex: 'scoringFormat' },
    { title: 'Win Condition', dataIndex: 'winCondition' },
  ];

  return (
    <Card>
      <div className="container my-5 p-4 border rounded">
        <h1 className="display-5 font-weight-bold mb-2">Scoring System</h1>
        <p className="text-muted mb-4">
          How matches are scored and how ratings are calculated
        </p>

        <section className="mb-4">
          <h3 className="h6">Match Scoring</h3>
          <p>
            Score/Pulse follows standard pickleball scoring rules with some
            platform-specific adaptations:
          </p>
          <Table
            columns={matchColumns}
            dataSource={matchData}
            pagination={false}
          />
        </section>

        {/* <section>
        <Alert
          message={
            <>
              <InfoCircleOutlined /> Rating Protection
            </>
          }
          description="Players have a 10-match grace period after reaching a new level before they can be demoted to a lower level."
          type="info"
        />
      </section> */}
      </div>
    </Card>
  );
}
function ChallengeRules() {
  const cancellationData = [
    {
      timing: 'More than 48 hours before match',
      penalty: 'No penalty',
      ratingImpact: 'No impact',
    },
    // {
    //   timing: '24-48 hours before match',
    //   penalty: 'Warning',
    //   ratingImpact: 'No impact',
    // },
    // {
    //   timing: 'Less than 24 hours before match',
    //   penalty: 'Challenge restriction (3 days)',
    //   ratingImpact: 'No impact',
    // },
    // {
    //   timing: 'No-show without notice',
    //   penalty: 'Challenge restriction (7 days)',
    //   ratingImpact: '-0.1 rating points',
    // },
    // {
    //   timing: 'Repeated cancellations (3+ in 30 days)',
    //   penalty: 'Challenge restriction (14 days)',
    //   ratingImpact: '-0.2 rating points',
    // },
  ];

  const columns = [
    {
      title: 'Cancellation Timing',
      dataIndex: 'timing',
      key: 'timing',
    },
    {
      title: 'Penalty',
      dataIndex: 'penalty',
      key: 'penalty',
    },
    {
      title: 'Rating Impact',
      dataIndex: 'ratingImpact',
      key: 'ratingImpact',
    },
  ];

  return (
    <Card>
      <div className="container my-5 p-4 border rounded">
        <h1 className="display-5 font-weight-bold mb-2">Challenge Rules</h1>
        <p className="text-muted mb-4">
          Rules for challenging other players to matches
        </p>

        <section className="mb-5">
          <h2 className="h4 font-weight-semibold mb-3">
            Challenge Eligibility
          </h2>
          <p>
            The challenge system allows players to initiate matches with other
            players on the platform:
          </p>

          <ul className="list-unstyled">
            <li>
              <strong>Level Restrictions:</strong> Players can challenge others
              within ±1.0 level of their own level
            </li>
            <li>
              <strong>How to challenge:</strong> Players will create a match
              room and other players will join and will be scheduled.
            </li>
            <li>
              <strong>Challenge Scheduling:</strong> Players cannot challenge
              multiple people at the same time
            </li>
          </ul>
        </section>

        <section className="mb-5">
          <h2 className="h4 font-weight-semibold mb-3">
            Challenge Match Requirements
          </h2>
          <p>Challenge matches must meet the following requirements:</p>

          <ul className="list-unstyled">
            <li>
              <strong>Venue:</strong> Matches must be played at a verified venue
              registered on the platform
            </li>
            <li>
              <strong>Verification:</strong> Match results must be verified by
              both players
            </li>
            <li>
              <strong>Format:</strong> Standard scoring format (best of 3 games
              to 11 points)
            </li>
            <li>
              <strong>Witnesses:</strong> Recommended but not required for
              standard challenge matches
            </li>
            <li>
              <strong>Result Submission:</strong> Results must be submitted
              within 24 hours of match completion
            </li>
          </ul>
        </section>

        <section className="mb-5">
          <h2 className="h4 font-weight-semibold mb-3">
            Challenge Cancellation
          </h2>
          <p>Rules regarding cancellation of challenge matches:</p>

          <Table
            columns={columns}
            dataSource={cancellationData}
            rowKey="timing"
            pagination={false}
          />
        </section>

        <Alert
          message="Dispute Resolution"
          description={
            <>
              <p>
                In case of disputes about match results or conduct, both players
                can that the match result be annulled and the platform will
                remove it.
              </p>
            </>
          }
          type="error"
          showIcon
          icon={<ExclamationCircleOutlined />}
          className="mt-4"
        />
      </div>
    </Card>
  );
}
function TournamentRules() {
  return (
    <Card>
      <div className="container my-5 p-4 border rounded">
        <h1 className="display-5 font-weight-bold mb-2">Tournament Rules</h1>
        <p className="text-muted mb-4">Rules for tournament</p>

        <section className="mb-5">
          <h2 className="h4 font-weight-semibold mb-3">Knockout Tournament</h2>
          <p>
            The tournament is organized in the form of knock-out competition.
          </p>

          <ul className="list-unstyled">
            <li>
              <strong>BO3 format:</strong> Win by 2 points, best of 3 games
            </li>
            <li>
              <strong>Score match:</strong> Rally scoring to 11-15-21 points
            </li>
            <li>
              <strong>Scheduling:</strong> Each tournament will have a start
              date and end date. Players will be notified of their match times.
            </li>
            <li>
              <strong>Referee:</strong> Each tournament match will have a
              referee assigned to ensure fair play and adherence to rules.
            </li>
            <li>
              <strong>Venue:</strong> Each match of a tournament will be held at
              a same venue and verified location registered on the platform
            </li>
          </ul>
        </section>

        <section className="mb-5">
          <h2 className="h4 font-weight-semibold mb-3">
            Tournament Requirements
          </h2>
          <p>Tournament registration must meet the following requirements:</p>

          <ul className="list-unstyled">
            <li>
              <strong>Singles Tournament:</strong>
              <ul>
                <li>
                  Players must register individually and pay the tournament fee.
                </li>
                <li>Player must qualify for tournament-appropriate gender.</li>
                <li>
                  Player must qualify for tournament-appropriate minimum level,
                  and maximum level.
                </li>
              </ul>
            </li>
            <li>
              <strong>Doubles Tournaments:</strong>
              <ul>
                <li>
                  Players must register with friend (fill out the registration
                  form) and pay the tournament fee.
                </li>
                <li>
                  The player who fills out the form will be the one to pay the
                  tournament entry fee.
                </li>
                <li>
                  Players must confirm their participation in the tournament.
                </li>
                <li>Players must qualify for tournament-appropriate gender.</li>
                <li>
                  Players must qualify for tournament-appropriate minimum level,
                  and maximum level.
                </li>
              </ul>
            </li>
          </ul>
        </section>

        <Alert
          message="Tournament Cancellation"
          description={
            <>
              <p>
                In case of disputes about match results or conduct, players can
                contact the tournament organizer for resolution.
              </p>
            </>
          }
          type="error"
          showIcon
          icon={<ExclamationCircleOutlined />}
          className="mt-4"
        />
      </div>
    </Card>
  );
}

function RankingLevelRules() {
  const ratingData = [
    {
      key: '1',
      level: 'Level 1',
      point: '0 - 200',
      winPoint: '+20',
      lossPoint: '-10',
    },
    {
      key: '2',
      level: 'Level 2',
      point: '201 - 250',
      winPoint: '+19',
      lossPoint: '-11',
    },
    {
      key: '3',
      level: 'Level 3',
      point: '251 - 300',
      winPoint: '+18',
      lossPoint: '-12',
    },
    {
      key: '4',
      level: 'Level 4',
      point: '301 - 350',
      winPoint: '+17',
      lossPoint: '-13',
    },
    {
      key: '5',
      level: 'Level 5',
      point: '351 - 400',
      winPoint: '+16',
      lossPoint: '-14',
    },
    {
      key: '6',
      level: 'Level 6',
      point: '401 - 450',
      winPoint: '+15',
      lossPoint: '-15',
    },
    {
      key: '7',
      level: 'Level 7',
      point: '451 - 500',
      winPoint: '+14',
      lossPoint: '-16',
    },
    {
      key: '8',
      level: 'Level 8',
      point: '501 - 550',
      winPoint: '+13',
      lossPoint: '-17',
    },
    {
      key: '9',
      level: 'Level 9',
      point: '550+',
      winPoint: '+12',
      lossPoint: '-18',
    },
  ];

  const ratingColumns = [
    { title: 'Level', dataIndex: 'level' },
    { title: 'Point', dataIndex: 'point' },
    { title: 'Win Point', dataIndex: 'winPoint' },
    { title: 'Loss Point', dataIndex: 'lossPoint' },
  ];

  return (
    <Card>
      <div className="container my-5 p-4 border rounded">
        <h1 className="display-5 font-weight-bold mb-2">
          Ranking Point - Level
        </h1>
        <p className="text-muted mb-4">How level and ratings are calculated</p>

        <section className="mb-4">
          <h3 className="h6">Rating Levels</h3>
          <p>
            Players are categorized into skill levels based on their numerical
            rating:
          </p>
          <Table
            columns={ratingColumns}
            dataSource={ratingData}
            pagination={false}
          />
        </section>
      </div>
    </Card>
  );
}

export default RulePage;
