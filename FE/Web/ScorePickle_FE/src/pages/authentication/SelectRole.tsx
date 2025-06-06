import { Card } from 'antd';
import { RoleFactory } from '@src/modules/User/models';
import { Typography } from 'antd';
import { useNavigate } from 'react-router-dom';

const { Title, Text } = Typography;

export const SelectRole = () => {
  const navigate = useNavigate();

  const handleSelectRole = (role: RoleFactory) => {
    // Lưu role tạm (có thể dùng Redux hoặc localStorage nếu cần)
    // Và chuyển tới bước xác thực email
    if (role === RoleFactory.Player) {
      navigate('/auth/player-form');
    } else if (role === RoleFactory.Sponsor) {
      navigate('/auth/sponsor-form');
    }
  };
  return (
    <div className="d-flex justify-content-center align-items-center min-vh-100">
      <div className="container">
        <div className="row g-4">
          <Title className="text-center mb-4">Select Your Role</Title>
          <Text className="text-center mb-4">Choose your role to proceed</Text>
          <div className="col-md-6">
            <Card
              className="card h-100 border-2 cursor-pointer"
              onClick={() => handleSelectRole(RoleFactory.Player)}
              style={{ cursor: 'pointer' }}
            >
              <div className="card-body text-center p-4">
                <div className="mb-3">
                  <div className="d-inline-flex justify-content-center align-items-center bg-primary bg-opacity-10 rounded-circle p-3 mb-3">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="32"
                      height="32"
                      fill="currentColor"
                      className="bi bi-person text-primary"
                      viewBox="0 0 16 16"
                    >
                      <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664z" />
                    </svg>
                  </div>
                </div>
                <h3 className="card-title">Player</h3>
                <p className="card-text text-muted">
                  Register as a player to participate in tournaments, track your
                  schedule and connect with others player.
                </p>
              </div>
            </Card>
          </div>

          <div className="col-md-6">
            <div
              className="card h-100 border-2"
              onClick={() => handleSelectRole(RoleFactory.Sponsor)}
              style={{ cursor: 'pointer' }}
            >
              <Card className="card-body text-center p-4">
                <div className="mb-3">
                  <div className="d-inline-flex justify-content-center align-items-center bg-primary bg-opacity-10 rounded-circle p-3 mb-3">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="32"
                      height="32"
                      fill="currentColor"
                      className="bi bi-briefcase text-primary"
                      viewBox="0 0 16 16"
                    >
                      <path d="M6.5 1A1.5 1.5 0 0 0 5 2.5V3H1.5A1.5 1.5 0 0 0 0 4.5v8A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-8A1.5 1.5 0 0 0 14.5 3H11v-.5A1.5 1.5 0 0 0 9.5 1zm0 1h3a.5.5 0 0 1 .5.5V3H6v-.5a.5.5 0 0 1 .5-.5m1.886 6.914L15 7.151V12.5a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5V7.15l6.614 1.764a1.5 1.5 0 0 0 .772 0M1.5 4h13a.5.5 0 0 1 .5.5v1.616L8.129 7.948a.5.5 0 0 1-.258 0L1 6.116V4.5a.5.5 0 0 1 .5-.5" />
                    </svg>
                  </div>
                </div>
                <h3 className="card-title">Sponsor</h3>
                <p className="card-text text-muted">
                  Register as a sponsor to organize tournaments, promote your
                  brand.
                </p>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
