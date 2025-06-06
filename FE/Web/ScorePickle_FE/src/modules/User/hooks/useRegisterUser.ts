import { useMutation } from '@tanstack/react-query';
import Api from '../../../api/api';
import {
  CreatePlayerRequest,
  CreatePlayerResponse,
  Player,
  RegisterUser,
  RegisterUserRequest,
  RegisterUserResponse,
  RoleFactory,
} from '../models';
import { useDispatch, useSelector } from 'react-redux';
import { setUserId, clearVerified } from '@src/redux/user/userSlice';
import { message } from 'antd';
import { useNavigate } from 'react-router-dom';
import { RootState } from '@src/redux/store';
import { setUser } from '@src/redux/authentication/authSlide';

const registerUser = async (
  user: RegisterUserRequest
): Promise<RegisterUserResponse> => {
  const payload: RegisterUserRequest = {
    ...user,
    RoleId: RoleFactory.Player,
  };
  const response = await Api.post('Auth/register', payload);
  const data = response.data as RegisterUserResponse;
  return data;
};

export function useRegisterUser() {
  return useMutation({
    mutationFn: registerUser,
    onError: (error) => {
      console.error('Error registering user:', error);
    },
  });
}

export const createPlayer = async (
  request: CreatePlayerRequest
): Promise<Player> => {
  const response = await Api.post('Player/CreatePlayer', request);
  const data = response.data as Player;
  return data;
};

const registerPlayer = async (
  user: RegisterUser
): Promise<RegisterUserResponse> => {
  const response = await Api.post('Auth/register', user);
  const data = response.data as RegisterUserResponse;
  return data;
};

export function useRegisterPlayer() {
  const dispatch = useDispatch();

  return useMutation({
    mutationFn: registerPlayer,
    onSuccess: (data) => {
      dispatch(setUserId(data.id));
      //createPlayer(data.id);
    },
    onError: (error) => {
      console.error('Error registering player:', error);
    },
  });
}

export const useCreatePlayer = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const user = useSelector((state: RootState) => state.auth.user);
  return useMutation<Player, Error, CreatePlayerRequest>({
    mutationFn: (request: CreatePlayerRequest) => createPlayer(request),
    onSuccess: (data) => {
      message.success('Player created successfully!');
      dispatch(clearVerified());
      if (user) {
        const updatedUser = { ...user, userDetails: data };
        dispatch(setUser(updatedUser));
      }
      setTimeout(() => {
        navigate('/');
      }, 1000);
    },
    onError: (error) => {
      console.error('❌ Failed to create player:', error.message);
      message.error('Player creation failed!');
    },
  });
};
