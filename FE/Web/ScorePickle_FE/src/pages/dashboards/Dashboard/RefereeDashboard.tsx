import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Spin } from 'antd';

interface RefereeDashboardProps {
  user: any;
}

const RefereeDashboard: React.FC<RefereeDashboardProps> = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Simple redirect to referee page
    navigate('/referee/dashboard', { replace: true });
  }, [navigate]);

  // Display loading while redirect happens
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
      }}
    >
      <Spin size="large" tip="Redirecting to referee dashboard..." />
    </div>
  );
};

export default RefereeDashboard;
