import React, { useState, useEffect } from 'react';
import { Button, Input, Spin } from 'antd';
import { useInView } from 'react-intersection-observer';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { SearchOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { useGetAllMatches } from '@src/modules/Match/hooks/useGetAllCompetitiveAndCustomMatch';
import MatchListCard from './components/MatchListCard';
import { Matches, MatchStatus } from '@src/modules/Match/models';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';

export const MatchesPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [visibleMatches, setVisibleMatches] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const { data: allMatch, isLoading } = useGetAllMatches();
  const [data, setData] = useState<Matches[]>([]);
  const navigate = useNavigate();
  const [isHover, setIsHover] = useState(false);
  const user = useSelector((state: RootState) => state.auth.user);

  useEffect(() => {
    if (allMatch) {
      setData(
        allMatch.filter(
          (m) =>
            m.status !== MatchStatus.Disabled &&
            m.status !== MatchStatus.Completed
        )
      );
    }
  }, [allMatch]);

  const { ref, inView } = useInView({
    triggerOnce: false, // Kiểm tra liên tục khi cuộn
    threshold: 0.9, // Kích hoạt khi 90% phần tử xuất hiện trong màn hình
    rootMargin: '0px 0px 100px 0px', // Kích hoạt sớm khi phần tử gần xuất hiện
  });

  // Số lượng phần tử hiển thị mỗi lần (ví dụ: 10)
  const loadMore = () => {
    if (loading || !data || visibleMatches.length >= data.length) return; // Nếu đang tải hoặc không có dữ liệu thì không làm gì

    setLoading(true);

    // Giả sử dữ liệu đã được tải hoàn toàn (data có chứa tất cả người chơi)
    setTimeout(() => {
      setVisibleMatches((prevMatches) => [
        ...prevMatches,
        ...data.slice(prevMatches.length, prevMatches.length + 10), // Lấy 10 phần tử tiếp theo
      ]);
      setLoading(false);
    }, 100); // Giả lập độ trễ khi tải thêm
  };

  // Khi dữ liệu có sẵn, hiển thị 10 phần tử đầu tiên
  useEffect(() => {
    if (data && data.length > 0) {
      setVisibleMatches(data.slice(0, 10)); // Hiển thị 10 phần tử đầu tiên
    }
  }, [data]);

  // Tải thêm dữ liệu khi phần tử cuối cùng xuất hiện
  useEffect(() => {
    if (inView) {
      loadMore();
    }
  }, [inView]);

  const handleSearch = (e) => {
    const term = e.target.value;
    setSearchTerm(term);
  };

  const goToMatchDetail = (id: string) => {
    // có thể thêm side-effect ở đây
    navigate(`/match-detail/${id}`);
  };

  const navigateCreateMatch = () => {
    navigate('/add-match');
  };

  return (
    <div className="d-flex flex-column min-vh-100 text-white justify-content-center">
      <div className="flex-grow-1 container py-4">
        <div className="d-flex align-items-center mb-4">
          <h1 className="display-4 fw-bold mb-0">Matches</h1>
          {user?.id !== undefined && user?.id !== null && (
            <Button
              onClick={navigateCreateMatch}
              onMouseEnter={() => setIsHover(true)}
              onMouseLeave={() => setIsHover(false)}
              className="ms-auto"
              type="primary"
              style={{
                transform: isHover ? 'translateY(-4px)' : 'translateY(0)',
                transition: 'all 0.3s ease',
                cursor: 'pointer',
                background: isHover ? '#ffffff' : '#ffffff',
                color: '#1890ff',
                borderRadius: '40px',
                boxShadow: isHover
                  ? '0 8px 16px rgba(24, 144, 255, 0.3)'
                  : '0 4px 8px rgba(24, 144, 255, 0.2)',
                border: 'none',
                padding: '10px 20px',
                height: 'auto',
              }}
            >
              <span
                style={{
                  fontSize: '16px',
                  fontWeight: 'bold',
                  color: '#096dd9',
                }}
              >
                + Create Match
              </span>
            </Button>
          )}
        </div>

        <div
          className="row justify-content-center"
          style={{ minHeight: '100vh', overflowX: 'hidden' }}
        >
          <div className="main-content col-12 col-md-6">
            <div className="container-fluid p-0">
              <div
                className="d-flex flex-column"
                style={{
                  color: 'white',
                }}
              >
                <div className="position-relative mb-3">
                  <Input
                    prefix={<SearchOutlined style={{ color: '#bfbfbf' }} />}
                    placeholder="Search"
                    value={searchTerm}
                    onChange={(e) => handleSearch(e)}
                    className="rounded-pill py-2 ps-3"
                    style={{
                      backgroundColor: 'white',
                      border: 'none',
                      boxShadow: 'none',
                      width: '50%',
                    }}
                  />
                </div>

                {isLoading && (
                  <div className="d-flex justify-content-center align-items-center">
                    <Spin style={{ fontSize: '50px' }} />
                  </div>
                )}
                <div className="container-fluid" style={{ padding: '0' }}>
                  {visibleMatches
                    .filter(
                      (match) =>
                        `${match.firstName} ${match.secondName} ${match.lastName}`
                          .toLowerCase()
                          .includes(searchTerm.toLowerCase()) &&
                        match.status !== MatchStatus.Disabled &&
                        match.status !== MatchStatus.Completed
                    )
                    .map((match) => (
                      <div
                        key={match.id}
                        onClick={() => goToMatchDetail(match.id)}
                        style={{ cursor: 'pointer' }}
                      >
                        <MatchListCard value={match} />
                      </div>
                    ))}
                </div>

                {!loading && visibleMatches.length < (data?.length ?? 0) && (
                  <div ref={ref}>
                    {loading && <Spin style={{ fontSize: '50px' }} />}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MatchesPage;
