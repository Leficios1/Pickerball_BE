import { Button, Spin, Tabs } from 'antd';
import { useNavigate, useParams } from 'react-router-dom';
import Rank from '../../components/Rank';
import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';
import MatchRoom from './containers/MatchRoom';

const { TabPane } = Tabs;

const RefereeDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { data, isLoading, error } = useGetTournamentById(Number(id || 0));
  const navigate = useNavigate();

  if (isLoading) {
    return <Spin size="large" />;
  }

  if (error) {
    return <div>Error loading tournament details</div>;
  }

  if (!data) {
    return <div>No tournament data found</div>;
  }

  return (
    <div>
      <Button
        type="primary"
        onClick={() => navigate(-1)}
        style={{ marginBottom: 16 }}
      >
        Back
      </Button>
      <Tabs defaultActiveKey="1">
        <TabPane tab="Room" key="1">
          <MatchRoom />
        </TabPane>
        <TabPane tab="Rank" key="7">
          <Rank tournamentId={data.id} />
        </TabPane>
      </Tabs>
    </div>
  );
};

export default RefereeDetail;
