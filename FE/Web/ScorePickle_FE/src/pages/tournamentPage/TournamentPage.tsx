import {
  FilterOutlined,
  LoadingOutlined,
  SearchOutlined,
} from '@ant-design/icons';
import { useGetAllTournamentsForPlayer } from '@src/modules/Tournament/hooks/useGetAllTournaments';
import { RootState } from '@src/redux/store';
import { Button, Checkbox, Input, message } from 'antd';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useEffect, useRef, useState } from 'react';
import { useSelector } from 'react-redux';
import { TournamentCard } from './containers/TournamentCard';

export const TournamentPage = () => {
  const { data, isLoading } = useGetAllTournamentsForPlayer();
  const [isSidebarHidden, setIsSidebarHidden] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const sidebarRef = useRef<HTMLDivElement>(null);
  const mainRef = useRef(null);

  const toggleSidebar = () => {
    setIsSidebarHidden((prevState) => !prevState);
  };

  const initialFilters = {
    tournamentType: [] as string[],
    skillLevel: [] as string[],
    status: [] as string[],
    gender: [] as string[],
  };

  const [filters, setFilters] = useState<{
    tournamentType: string[];
    skillLevel: string[];
    status: string[];
    gender: string[];
  }>({
    tournamentType: [],
    skillLevel: [],
    status: [],
    gender: [],
  });

  const user = useSelector((state: RootState) => state.auth.user);

  useEffect(() => {
    setFilters((prev) => ({
      ...prev,
      status: ['Scheduled'],
    }));
  }, []);

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

  // Hàm lọc dữ liệu
  const filterTournaments = (data) => {
    return data.filter((tournament) => {
      // Check if tournament type matches any of the selected types
      const isTypeMatch =
        filters.tournamentType.length === 0 ||
        filters.tournamentType.some((type) =>
          tournament.type.toLowerCase().includes(type.toLowerCase())
        );

      // Check if skill level is within the selected skill levels
      const isSkillLevelMatch =
        filters.skillLevel.length === 0 ||
        filters.skillLevel.some(
          (level) =>
            level >= tournament.isMinRanking && level <= tournament.isMaxRanking
        );

      // Check if the status matches any of the selected statuses
      const isStatusMatch =
        filters.status.length === 0 ||
        filters.status.includes(tournament.status);

      const isSearchMatch =
        searchTerm.trim() === '' ||
        tournament.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        tournament.location.toLowerCase().includes(searchTerm.toLowerCase());

      const isGenderMatch =
        filters.gender.length === 0 ||
        filters.gender.some((gender) => {
          if (gender === 'male') {
            return ['SinglesMale', 'DoublesMale', 'DoublesMix'].includes(
              tournament.type
            );
          }
          if (gender === 'female') {
            return ['SinglesFemale', 'DoublesFemale', 'DoublesMix'].includes(
              tournament.type
            );
          }
          return false;
        });

      // Return true if all conditions are met
      return (
        isTypeMatch &&
        isSkillLevelMatch &&
        isStatusMatch &&
        isSearchMatch &&
        isGenderMatch
      );
    });
  };

  const handleCheckboxChange = (category, value) => {
    setFilters((prevFilters) => {
      const updatedCategory = prevFilters[category].includes(value)
        ? prevFilters[category].filter((item) => item !== value)
        : [...prevFilters[category], value];

      return { ...prevFilters, [category]: updatedCategory };
    });
  };

  const recommendTournaments = () => {
    // Áp dụng bộ lọc đặc biệt cho "Recommend Tournament" dựa trên level và gender của người dùng
    setFilters({
      tournamentType: [],
      skillLevel: [user?.userDetails?.experienceLevel?.toString() ?? '0'],
      status: [],
      gender: [user?.gender?.toLowerCase() ?? 'male'],
    });
    message.success('Filter follow your level and gender succesfully');
  };

  const handleResetFilters = () => {
    setFilters(initialFilters);
    message.success('Filters reset successfully');
  };

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        height: '150vh',
        width: '100%', // use percentage to avoid overflow
        boxSizing: 'border-box', // include padding in width
        overflowX: 'hidden', // prevent horizontal scroll
      }}
      className="text-white"
    >
      {/* HEADER */}
      <div
        style={{
          padding: '1rem 2rem',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          width: '100%',
          boxSizing: 'border-box',
        }}
      >
        <h1
          style={{
            fontSize: '2.5rem',
            fontWeight: 700,
            margin: 0,
            marginLeft: isSidebarHidden ? '3rem' : '2rem',
          }}
        >
          Tournaments
        </h1>
        <div
          style={{
            display: 'flex', // thành flex để Input và Button nằm cạnh
            alignItems: 'center',
            width: '50%',
            gap: '0.5rem', // khoảng cách giữa 2 phần tử
            boxSizing: 'border-box',
          }}
        >
          <Input
            prefix={<SearchOutlined style={{ color: '#bfbfbf' }} />}
            placeholder="Search"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{
              flex: 1, // chiếm hết không gian còn lại
              borderRadius: '999px',
              padding: '0.5rem 1rem',
              boxSizing: 'border-box',
            }}
          />
          <Button
            onClick={toggleSidebar}
            style={{
              height: '40px', // hoặc '100%' nếu muốn cao bằng Input
              width: '40px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              borderRadius: '999px',
              marginRight: '5rem',
            }}
          >
            <FilterOutlined style={{ color: '#0066cc' }} />
          </Button>
        </div>
      </div>

      {/* CONTENT WRAPPER */}
      <div
        style={{
          display: 'flex',
          flexGrow: 1,
          overflow: 'hidden',
          color: 'white',
          height: '100vh',
        }}
      >
        {/* SIDEBAR */}
        <aside
          ref={sidebarRef}
          style={{
            flex: '0 0 25%',
            maxWidth: isSidebarHidden ? '0' : '20%',
            transform: isSidebarHidden ? 'translateX(-100%)' : 'translateX(0)',
            transition: 'transform .3s ease, max-width .3s ease',
            height: '100%',
            overflowY: 'hidden',
            msOverflowStyle: 'none',
            scrollbarWidth: 'none',
            overscrollBehaviorY: 'contain',
            padding: isSidebarHidden ? '0' : '1rem',
            marginTop: '30px',
            marginLeft: isSidebarHidden ? '0' : '3rem',
          }}
        >
          <div style={{ position: 'sticky', top: 0 }}>
            {user?.id && (
              <div style={{ marginBottom: '1rem' }}>
                <h2
                  style={{
                    fontSize: '1.25rem',
                    fontWeight: 500,
                    margin: '0 0 .75rem',
                  }}
                >
                  Recommend Tournament
                </h2>
                <Button
                  style={{ width: '100%', marginBottom: '1rem' }}
                  type="primary"
                  onClick={recommendTournaments}
                >
                  Filter By Level And Gender
                </Button>
              </div>
            )}

            <div style={{ marginBottom: '1rem' }}>
              <h2
                style={{
                  fontSize: '1.25rem',
                  fontWeight: 500,
                  margin: '0 0 .75rem',
                }}
              >
                Filters
              </h2>
              <Button
                style={{ width: '100%', marginBottom: '1rem' }}
                onClick={handleResetFilters}
              >
                Reset Filters
              </Button>
            </div>

            {/* Tournament Type */}
            <div style={{ marginBottom: '1rem' }}>
              <h3
                style={{
                  fontSize: '1rem',
                  fontWeight: 500,
                  margin: '0 0 .5rem',
                }}
              >
                Tournament Type
              </h3>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '0.5rem',
                }}
              >
                <Checkbox
                  className="text-white"
                  onChange={() =>
                    handleCheckboxChange('tournamentType', 'singles')
                  }
                >
                  Single
                </Checkbox>
                <Checkbox
                  className="text-white"
                  onChange={() =>
                    handleCheckboxChange('tournamentType', 'doubles')
                  }
                >
                  Doubles
                </Checkbox>
              </div>
            </div>

            {/* Tournament Gender */}
            <div style={{ marginBottom: '1rem' }}>
              <h3
                style={{
                  fontSize: '1rem',
                  fontWeight: 500,
                  margin: '0 0 .5rem',
                }}
              >
                Gender
              </h3>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '0.5rem',
                }}
              >
                <Checkbox
                  className="text-white"
                  checked={filters.gender.includes('male')}
                  onChange={() => handleCheckboxChange('gender', 'male')}
                >
                  Male
                </Checkbox>
                <Checkbox
                  className="text-white"
                  checked={filters.gender.includes('female')}
                  onChange={() => handleCheckboxChange('gender', 'female')}
                >
                  Female
                </Checkbox>
              </div>
            </div>

            {/* Skill Level */}
            <div style={{ marginBottom: '1rem' }}>
              <h3
                style={{
                  fontSize: '1rem',
                  fontWeight: 500,
                  margin: '0 0 .5rem',
                }}
              >
                Skill Level
              </h3>
              <div
                style={{ display: 'flex', flexDirection: 'row', gap: '1rem' }}
              >
                <div
                  style={{
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '0.5rem',
                  }}
                >
                  {[1, 2, 3, 4, 5].map((level) => (
                    <Checkbox
                      className="text-white"
                      key={level}
                      style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        whiteSpace: 'nowrap',
                      }}
                      checked={filters.skillLevel.includes(String(level))}
                      onChange={() =>
                        handleCheckboxChange('skillLevel', String(level))
                      }
                    >
                      Level {level}
                    </Checkbox>
                  ))}
                </div>
                <div
                  style={{
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '0.5rem',
                  }}
                >
                  {[6, 7, 8, 9].map((level) => (
                    <Checkbox
                      className="text-white"
                      key={level}
                      style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        whiteSpace: 'nowrap',
                      }}
                      checked={filters.skillLevel.includes(String(level))}
                      onChange={() =>
                        handleCheckboxChange('skillLevel', String(level))
                      }
                    >
                      Level {level}
                    </Checkbox>
                  ))}
                </div>
              </div>
            </div>

            {/* Status */}
            <div style={{ marginBottom: '1rem' }}>
              <h3
                style={{
                  fontSize: '1rem',
                  fontWeight: 500,
                  margin: '0 0 .5rem',
                }}
              >
                Status
              </h3>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '0.5rem',
                }}
              >
                <Checkbox
                  className="text-white"
                  checked={filters.status.includes('Scheduled')}
                  onChange={() => handleCheckboxChange('status', 'Scheduled')}
                >
                  Coming Soon
                </Checkbox>
                <Checkbox
                  className="text-white"
                  onChange={() => handleCheckboxChange('status', 'Ongoing')}
                >
                  Ongoing
                </Checkbox>
                <Checkbox
                  className="text-white"
                  onChange={() => handleCheckboxChange('status', 'Completed')}
                >
                  Past Tournaments
                </Checkbox>
              </div>
            </div>

            {/* <Button style={{ width: '100%' }} className="bg-dark text-white">
              Apply Filters
            </Button> */}
          </div>
        </aside>

        {/* MAIN CONTENT */}
        <main
          ref={mainRef}
          style={{
            flex: isSidebarHidden ? '0 0 90%' : '0 0 70%',
            height: '100%',
            minHeight: '0',
            overflowY: 'auto',
            msOverflowStyle: 'none',
            scrollbarWidth: 'none',
            margin: '1rem',
            transition: 'all .3s ease',
            willChange: 'width',
            marginTop: '0px',
            marginLeft: isSidebarHidden ? '5rem' : '1rem',
          }}
        >
          {/* Header sticky */}
          {/* <div
            style={{
              position: 'sticky',
              top: 0,
              zIndex: 10, // đảm bảo nổi trên content
              background: 'inherit', // hoặc '#fff' nếu cần
              paddingBottom: '1rem',
              marginBottom: '1rem',
            }}
          >
            <div style={{ marginBottom: '1rem', color: 'inherit' }}>
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                }}
              >
                <h2 style={{ fontSize: '1.5rem', fontWeight: 700, margin: 0 }}>
                  Tournaments Open
                </h2>
                <div
                  style={{
                    position: 'relative',
                    width: '50%',
                    paddingRight: '40px',
                  }}
                >
                  <Input
                    prefix={<SearchOutlined style={{ color: '#bfbfbf' }} />}
                    placeholder="Search"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    style={{
                      width: '100%',
                      borderRadius: '999px',
                      padding: '0.5rem 1rem',
                      paddingRight: '40px',
                    }}
                  />
                  <Button
                    onClick={toggleSidebar}
                    style={{
                      position: 'absolute',
                      right: 0,
                      top: 0,
                      height: '100%',
                      width: '40px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      borderRadius: '999px',
                    }}
                  >
                    <FilterOutlined style={{ color: '#0066cc' }} />
                  </Button>
                </div>
              </div>
            </div>
          </div> */}

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
              {filterTournaments(data).map((tournament) => (
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
        </main>
      </div>
    </div>
  );
};
