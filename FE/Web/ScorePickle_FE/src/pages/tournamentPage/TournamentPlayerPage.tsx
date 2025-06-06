import { useGetAllTournamentsByPlayerId } from '@src/modules/Tournament/hooks/useGetTournamentByPlayerId';
import { RootState } from '@src/redux/store';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useState } from 'react';
import { useSelector } from 'react-redux';
import { TournamentCard } from './containers/TournamentCard';
import { LoadingOutlined } from '@ant-design/icons';
import { Tabs } from 'antd';

const { TabPane } = Tabs;
export const TournamentPlayerPage = () => {
  const user = useSelector((state: RootState) => state.auth.user);
  const { data, isLoading } = useGetAllTournamentsByPlayerId(user?.id ?? 0);
  const [filter, setFilter] = useState('All');
  const filteredTournaments = data?.filter((tournament) => {
    if (filter === 'All') return true;
    return tournament.status === filter;
  });
  const formatDates = (startDate: string, endDate: string) => {
    const start = new Date(startDate);
    const end = new Date(endDate);

    const options: Intl.DateTimeFormatOptions = {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    };

    const formattedStartDate = start.toLocaleDateString('en-US', options);
    const formattedEndDate = end.toLocaleDateString('en-US', options);

    return `${formattedStartDate} - ${formattedEndDate}`;
  };
  return (
    <div className="container py-5">
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          boxSizing: 'border-box',
        }}
        className="mb-4"
      >
        <h1
          className="text-white"
          style={{ fontSize: '2.5rem', fontWeight: 700, margin: 0 }}
        >
          Registered Tournaments
        </h1>
      </div>
      <Tabs
        defaultActiveKey="All"
        onChange={(key) => setFilter(key)}
        className="mb-4 text-white"
      >
        <TabPane tab={<span className="text-white">All</span>} key="All" />
        <TabPane
          tab={<span className="text-white">Schedule</span>}
          key="Schedule"
        />
        <TabPane
          tab={<span className="text-white">OnGoing</span>}
          key="Ongoing"
        />
        <TabPane
          tab={<span className="text-white">Completed</span>}
          key="Completed"
        />
        <TabPane
          tab={<span className="text-white">Disabled</span>}
          key="Disable"
        />
      </Tabs>

      <div className="row g-4">
        {isLoading ? (
          <div
            style={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              height: '100%',
            }}
          >
            <LoadingOutlined style={{ fontSize: '50px' }} />
          </div>
        ) : (
          // Grid 2 cột cho các TournamentCard
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(2, 1fr)',
              gap: '1rem',
            }}
          >
            {(filteredTournaments ?? []).map((tournament) => (
              <TournamentCard
                key={tournament.id}
                id={tournament.id}
                title={tournament.name}
                dates={formatDates(tournament.startDate, tournament.endDate)}
                location={tournament.location}
                type={tournament.type}
                registeredCount={tournament.maxPlayer}
                skillLevels={`${tournament.isMinRanking} - ${tournament.isMaxRanking}`}
                entryFee={tournament.entryFee}
                status={tournament.status}
                banner={tournament.banner}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default TournamentPlayerPage;
