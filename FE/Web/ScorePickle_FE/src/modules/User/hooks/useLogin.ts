import { useMutation } from '@tanstack/react-query';
import { useDispatch } from 'react-redux';
import Api from '../../../api/api';
import { LoginRequest, LoginResponse, RoleFactory, User } from '../models';
import { isAuth, setUser } from '../../../redux/authentication/authSlide';
import {
  getLocalStorageItem,
  setLocalStorageItem,
} from '@src/utils/localStorageUtils';
import { useNavigate } from 'react-router-dom';
import { PATH_LANDING } from '@src/constants';
import { PATH_AUTH, PATH_DASHBOARD } from '@src/constants/routes';
import { setEmail, setUserId, setVerified } from '@src/redux/user/userSlice';

// integration with redux for login user
const login = async (request: LoginRequest): Promise<LoginResponse> => {
  const response = await Api.post('Auth/login', request);
  const data: LoginResponse = response.data as LoginResponse;
  if (data.tokenString) {
    setLocalStorageItem('token', data.tokenString);
  }
  return data;
};

export function useLogin() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  return useMutation({
    mutationFn: login,
    onSuccess: () => {
      getUser().then((user) => {
        dispatch(setUser(user));
        dispatch(isAuth());
        if (user.roleId === RoleFactory.Player) navigate(PATH_LANDING.root);
        else if (user.roleId === RoleFactory.Admin)
          navigate(PATH_DASHBOARD.default);
        else if (user.roleId === RoleFactory.Referee)
          navigate(PATH_DASHBOARD.default);
        else if (user.roleId === RoleFactory.Sponsor)
          navigate(PATH_DASHBOARD.default);
        else if (user.roleId === RoleFactory.User) {
          navigate(PATH_AUTH.selectRole);
          dispatch(setUserId(user.id));
          dispatch(setVerified(true));
          dispatch(setEmail(user.email));
        } else navigate(PATH_LANDING.root);
      });
    },
    onError: (error) => {
      console.error('Error logging in:', error);
    },
  });
}

const getUser = async (): Promise<User> => {
  const token = getLocalStorageItem('token');
  const response = (await Api.get('Auth/GetUserByToken/', {
    token,
  })) as unknown as User;
  return response;
};

export async function saveRefreshToken() {
  const user: User = await getUser();
  setLocalStorageItem('refreshToken', user.refreshToken);
}
