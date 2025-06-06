import {
  Input,
  Modal,
  Button,
  AutoComplete,
  Card,
  Avatar,
  Tag,
  message,
} from 'antd';
import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
//import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';
import { UserOutlined, MinusCircleOutlined } from '@ant-design/icons';
import { useGetFriendByUserId } from '@src/modules/Friend/hooks/useGetFriendByUserId';
import { User } from '@src/modules/User/models';
import { useCreateRegistration } from '@src/modules/TournamentRegistration/hooks/useCreateRegistration';
import { useGetTournamentById } from '@src/modules/Tournament/hooks/useGetTournamentById';
interface Player {
  userId: number;
  name: string;
  rating: number;
}

interface TeamData {
  teamPlayers: Player[];
}

type RegistrationFormModalProps = {
  visible: boolean;
  onClose: () => void;
  tournamentId: number;
};

export const RegistrationFormModal: React.FC<RegistrationFormModalProps> = ({
  visible,
  onClose,
  tournamentId,
}) => {
  const user = useSelector(
    (state: RootState) => state.auth.user
  ) as User | null;

  const { data: tournamentData } = useGetTournamentById(tournamentId);
  const { data: friendData } = useGetFriendByUserId(
    user?.id ?? 0,
    tournamentData?.type.includes('Mix')
      ? undefined
      : tournamentData?.type.includes('Male')
        ? 'Male'
        : 'Female',
    tournamentData?.isMinRanking,
    tournamentData?.isMaxRanking
  );
  //const [friendData, setFriendData] = useState<GetFriendByUserIdResponse[]>(data ?? []);
  const [teamData, setTeamData] = useState<TeamData>({
    teamPlayers: user
      ? [
          {
            userId: user.id,
            name: user.firstName + ' ' + user.lastName,
            rating: user.userDetails?.experienceLevel ?? 0,
          },
        ]
      : [],
  });
  const [searchText, setSearchText] = useState('');

  // Search and select a player
  const handlePlayerSelect = (value: string, index: number) => {
    const selectedFriend = friendData?.find((f) => f.userFriendName === value);

    if (selectedFriend) {
      const newTeamPlayers = [...teamData.teamPlayers];
      // Add or update player at the specified index
      newTeamPlayers[index] = {
        userId: selectedFriend.userFriendId ?? 0, // Assuming userFriendId exists in friendData
        name: selectedFriend.userFriendName ?? '',
        rating: selectedFriend.exeprienceLevel ?? 0, // Assuming exeprienceLevel exists in friendData
      }; // You can modify the rating here if it's part of friendData
      setTeamData({ ...teamData, teamPlayers: newTeamPlayers });
    }
  };

  // Remove player from team
  const removePlayer = (index: number) => {
    const newTeamPlayers = [...teamData.teamPlayers];
    newTeamPlayers.splice(index, 1);
    setTeamData({ ...teamData, teamPlayers: newTeamPlayers });
  };

  const createRegistration = useCreateRegistration();

  const handleOk = () => {
    if (teamData.teamPlayers.length < 2) {
      message.error('Please select a partner player!');
      return;
    }
    createRegistration.mutate(
      {
        tournamentId: tournamentId,
        playerId: user?.id ?? 0,
        partnerId: teamData.teamPlayers[1]?.userId ?? undefined,
      },
      {
        onSuccess: (data) => {
          console.log('Success:', data);
          onClose(); // Đóng modal sau khi thành công
        },
        onError: (error) => {
          console.error('Error:', error);
          onClose();
        },
      }
    );
  };

  const handleCancel = () => {
    onClose();
  };

  const handleSearch = (searchText: string) => {
    return (friendData || []).filter(
      (f) => f.userFriendName?.toLowerCase().includes(searchText.toLowerCase())
    );
  };

  const handleSearchChange = (value) => {
    setSearchText(value); // Cập nhật từ khóa tìm kiếm khi người dùng gõ
  };

  return (
    <Modal
      title="Registration Form"
      visible={visible}
      onOk={handleOk}
      onCancel={handleCancel}
      width={800}
    >
      <Card className="match-card">
        <div className="row mb-4">
          <div className="col-md-12">
            <label className="form-label">Team</label>
            {teamData.teamPlayers.map((player, index) => (
              <div
                key={`team-${index}`}
                className="player-search-container mb-2"
              >
                {player.name ? (
                  <div className="selected-player">
                    <Avatar icon={<UserOutlined />} className="player-avatar" />
                    <span className="player-name ms-2">{player.name}</span>
                    <Tag color="blue" className="player-rating ms-3">
                      {player.rating}
                    </Tag>
                    {index !== 0 && ( // Only show the remove button if it's not the first player
                      <Button
                        type="text"
                        icon={<MinusCircleOutlined />}
                        onClick={() => removePlayer(index)}
                        className="remove-player"
                      />
                    )}
                  </div>
                ) : (
                  <AutoComplete
                    options={handleSearch('')?.map((f) => ({
                      value: f.userFriendName ?? '',
                      label: f.userFriendName ?? '',
                    }))}
                    onSelect={(value) => handlePlayerSelect(value, index)}
                    className="player-search w-100"
                  >
                    <Input
                      prefix={<UserOutlined />}
                      placeholder="Search Player"
                      className="rounded-pill"
                    />
                  </AutoComplete>
                )}
              </div>
            ))}
            {teamData.teamPlayers.length < 2 && (
              <AutoComplete
                options={handleSearch(searchText)?.map((f) => ({
                  value: f.userFriendName ?? '',
                  label: (
                    <div className="d-flex flex-column my-2">
                      <span className="fw-bold">{f.userFriendName}</span>
                      <small className="text-muted">
                        Gender: {f.gender} | Level: {f.exeprienceLevel}
                      </small>
                    </div>
                  ),
                }))}
                onSelect={(value) =>
                  handlePlayerSelect(value, teamData.teamPlayers.length)
                }
                className="player-search w-100"
              >
                <Input
                  prefix={<UserOutlined />}
                  placeholder="Search Player"
                  className="rounded-pill"
                  onChange={(e) => handleSearchChange(e.target.value)}
                />
              </AutoComplete>
            )}
          </div>
        </div>
      </Card>
    </Modal>
  );
};

export default RegistrationFormModal;
