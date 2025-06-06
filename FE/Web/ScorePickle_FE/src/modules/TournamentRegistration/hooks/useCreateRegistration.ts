import { useMutation } from '@tanstack/react-query';
import {
  CreateTournamentRegistrationPayload,
  CreateTournamentRegistrationResponse,
} from '../models';
import Api from '@src/api/api';
import { message } from 'antd';

export const createRegistration = async (
  registration: CreateTournamentRegistrationPayload
): Promise<CreateTournamentRegistrationResponse> => {
  const response = await Api.post(
    '/PlayerRegistration/CreateRegistration',
    registration
  );
  message.info(response.message);
  return response.data as CreateTournamentRegistrationResponse;
};

export function useCreateRegistration() {
  return useMutation<
    CreateTournamentRegistrationResponse,
    Error,
    CreateTournamentRegistrationPayload
  >({
    mutationFn: (variables: CreateTournamentRegistrationPayload) =>
      createRegistration(variables),
    onSuccess: (data) => {
      const registeredAt = new Date(data.registeredAt);
      if (registeredAt.getMinutes() < new Date().getMinutes() - 3)
        message.success('You have already registered for this tournament');
    },
    onError: () => {
      message.info('Tournament is fullly registered');
    },
  });
}
