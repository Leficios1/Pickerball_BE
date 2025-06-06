import { useGetTournamentTeamRequestNotification } from '@src/modules/Notification/hooks/useGetNotification';
import { useGetTournamentTeamRequestByPlayerId } from '@src/modules/TournamentRegistration/hooks/useGetTournamentTeamRequest';
import { useRespondTeamRequest } from '@src/modules/TournamentRegistration/hooks/useRespondTeamRequest';
import { InvitationStatus } from '@src/modules/TournamentRegistration/models';
import { Button, message, Spin } from 'antd';
import { useNavigate } from 'react-router-dom';
const containerStyle: React.CSSProperties = {
  maxHeight: '300px',
  overflowY: 'auto',
  overflowX: 'hidden',
  paddingRight: '10px',
  border: '1px solid #ccc',
  borderRadius: '8px',
  // Ẩn scrollbar trên Chrome, Edge, Safari
  scrollbarWidth: 'none', // Firefox
  msOverflowStyle: 'none',
};

const requestStyle: React.CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  padding: '8px',
  borderBottom: '1px solid #eee',
};

const TournamentInvitation = ({ playerId }) => {
  const { data, error, isLoading, refetch } =
    useGetTournamentTeamRequestByPlayerId(playerId);
  const {
    data: notifications,
    error: errorNoti,
    isLoading: loadingNoti,
    refetch: refetchNoti,
  } = useGetTournamentTeamRequestNotification(playerId);
  const { mutate } = useRespondTeamRequest();
  const navigate = useNavigate();

  if (isLoading && loadingNoti) {
    return <Spin />;
  }

  if (error || errorNoti) {
    return (
      <p>Error: {error?.message || errorNoti?.message || 'Unknown error'}</p>
    );
  }

  if (
    (!data || data?.length === 0) &&
    (!notifications || notifications?.length === 0)
  ) {
    return <p>No invitations available.</p>;
  }

  const handleAcceptInvitation = async (invitationId) => {
    try {
      await mutate({ id: invitationId, isAccept: 'true' });
      message.success('Accepted invitation successfully!');
      refetch();
      refetchNoti();
    } catch (err) {
      message.error('Failed to accept invitation!');
    }
  };

  const handleRejectInvitation = async (invitationId) => {
    try {
      await mutate({ id: invitationId, isAccept: 'false' });
      message.success('Rejected invitation successfully!');
      refetch();
      refetchNoti();
    } catch (err) {
      message.error('Failed to reject invitation!');
    }
  };

  const handleNavigateTournament = (tournamentId) => () => {
    navigate(`/tournament-detail/${tournamentId}`);
  };

  return (
    <ul style={containerStyle}>
      {(data ?? []).map((invitation, index) => (
        <li key={index} className="row mb-2" style={requestStyle}>
          <strong
            className="col-8"
            style={{ cursor: 'pointer' }}
            onClick={handleNavigateTournament(invitation.tournamentId)}
          >
            Team Request Tournament{' '}
            <span style={{ color: 'blueviolet' }}>
              {invitation.tournamentName}
            </span>{' '}
            By{' '}
            <span style={{ color: 'coral' }}>{invitation.requesterName}</span>{' '}
            {/* <span>{invitation.status === InvitationStatus.Accepted ? "was accepted" : "was rejected"}</span> */}
          </strong>
          {invitation.status === InvitationStatus.Pending ? (
            <div className="col-4 d-flex justify-content-end">
              <Button
                style={{ borderColor: 'green', color: 'green' }}
                onClick={(e) => {
                  e.stopPropagation();
                  handleAcceptInvitation(invitation.id);
                }}
              >
                <span>Accept</span>
              </Button>
              <Button
                style={{ borderColor: 'red', color: 'red' }}
                onClick={(e) => {
                  e.stopPropagation();
                  handleRejectInvitation(invitation.id);
                }}
                className="ms-2"
              >
                Reject
              </Button>
            </div>
          ) : invitation.status === InvitationStatus.Accepted ? (
            <div className="col-4 d-flex justify-content-end">
              <Button
                style={{ borderColor: 'green', color: 'green' }}
                onClick={() => {
                  handleAcceptInvitation(invitation.id);
                }}
              >
                <span>Accepted</span>
              </Button>
            </div>
          ) : (
            <div className="col-4 d-flex justify-content-end">
              <Button
                style={{ borderColor: 'red', color: 'red' }}
                onClick={() => {
                  handleAcceptInvitation(invitation.id);
                }}
              >
                <span>Rejected</span>
              </Button>
            </div>
          )}
        </li>
      ))}
      {(notifications ?? []).map((noti, index) => (
        <li key={index} className="row mb-2">
          <strong>
            {noti.message} by {noti.referenceName}
          </strong>
        </li>
      ))}
    </ul>
  );
};

export default TournamentInvitation;
