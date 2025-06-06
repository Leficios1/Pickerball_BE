import {
  Button,
  Col,
  Divider,
  Flex,
  Form,
  Input,
  message,
  Row,
  theme,
  Typography,
  Card,
  DatePicker,
  Select,
} from 'antd';
import {
  FacebookFilled,
  GoogleOutlined,
  TwitterOutlined,
} from '@ant-design/icons';
import { useMediaQuery } from 'react-responsive';
import { PATH_AUTH } from '../../constants';
import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';
import { useRegisterPlayer } from '@src/modules/User/hooks/useRegisterUser';
import { RoleFactory } from '@src/modules/User/models';
import dayjs from 'dayjs';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useSendOtp } from '@src/modules/Auth/hooks/useSendOtp';

const { Title, Text, Link } = Typography;

type FieldType = {
  firstName: string;
  secondName?: string;
  lastName: string;
  passwordHash: string;
  cPassword: string;
  dateOfBirth: Date;
  gender: string;
  phoneNumber: string;
  email: string; // Added email property
};

export const SignUpPage = () => {
  const {
    token: { colorPrimary },
  } = theme.useToken();
  const isMobile = useMediaQuery({ maxWidth: 769 });
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const { mutate: registerUser } = useRegisterPlayer();
  const { mutate: sendOtp } = useSendOtp();
  const [showOtpField, setShowOtpField] = useState(false);
  const [userFormData, setUserFormData] = useState<FieldType | null>(null);
  const [otpInput, setOtpInput] = useState('');
  const otpFromState = useSelector(
    (state: RootState) => state.user.otp?.toString() || ''
  );

  const handleSendOtpFirst = (values: FieldType) => {
    setUserFormData(values);
    sendOtp(values.email, {
      onSuccess: () => setShowOtpField(true),
    });
  };
  const handleVerifyOtpAndRegister = () => {
    if (otpInput.toString() === otpFromState && userFormData) {
      registerUser(
        {
          FirstName: userFormData.firstName,
          LastName: userFormData.lastName,
          SecondName: userFormData.secondName || '',
          Email: userFormData.email,
          PasswordHash: userFormData.passwordHash,
          DateOfBirth: userFormData.dateOfBirth.toISOString(),
          Gender: userFormData.gender,
          PhoneNumber: userFormData.phoneNumber,
          RoleId: RoleFactory.User,
        },
        {
          onSuccess: () => {
            message.success('Sign up successfully. Please choose a role.');
            navigate(PATH_AUTH.selectRole);
          },
          onError: () => {
            message.error('Sign up failed');
          },
        }
      );
    } else {
      message.error('OTP does not match');
    }
  };
  const onFinish = (values: FieldType) => {
    handleSendOtpFirst(values);
  };

  // const email = useSelector((state: RootState) => state.user.email);
  // const isVerified = useSelector((state: RootState) => state.user.isVerified);

  // useEffect(() => {
  //   if (!isVerified) {
  //     navigate(PATH_AUTH.registerEmail);
  //   }
  // }, [isVerified, navigate]);

  // const onFinish = (values: FieldType) => {
  //   registerUser(
  //     {
  //       FirstName: values.firstName,
  //       LastName: values.lastName,
  //       SecondName: values.secondName || '',
  //       Email: values.email,
  //       PasswordHash: values.passwordHash,
  //       DateOfBirth: values.dateOfBirth.toISOString(),
  //       Gender: values.gender,
  //       PhoneNumber: values.phoneNumber,
  //       RoleId: RoleFactory.User,
  //     },
  //     {
  //       onSuccess: () => {
  //         message.open({
  //           type: 'success',
  //           content: 'Sign up successful',
  //         });
  //         navigate(PATH_AUTH.signin);
  //       },
  //       onError: (error) => {
  //         console.log(error);
  //         message.open({
  //           type: 'error',
  //           content: 'Sign up failed',
  //         });
  //         setLoading(false);
  //       },
  //     }
  //   );
  // };

  const onFinishFailed = (errorInfo: any) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <Row style={{ minHeight: isMobile ? 'auto' : '100vh', overflow: 'hidden' }}>
      <Col xs={24} lg={12}>
        <Flex
          vertical
          align="center"
          justify="center"
          className="text-center"
          style={{ background: colorPrimary, height: '100%' }}
        >
          <Card
            hoverable
            style={{
              border: '0px !important',
              width: '100%',
              height: '100%',
              alignContent: 'center',
              background: colorPrimary,
            }}
          />
        </Flex>
      </Col>
      <Col xs={24} lg={12}>
        <Flex
          vertical
          align={isMobile ? 'center' : 'flex-start'}
          justify="center"
          gap="middle"
          style={{ height: '100%', padding: '2rem' }}
        >
          <Title className="m-0">Create an account</Title>
          <Flex gap={4}>
            <Text>Already have an account?</Text>
            <Link href={PATH_AUTH.signin}>Sign in here</Link>
          </Flex>
          {/* <Flex
            vertical={isMobile}
            gap="small"
            wrap="wrap"
            style={{ width: '100%' }}
          >
            <Button icon={<GoogleOutlined />}>Sign up with Google</Button>
            <Button icon={<FacebookFilled />}>Sign up with Facebook</Button>
            <Button icon={<TwitterOutlined />}>Sign up with Twitter</Button>
          </Flex>
          <Divider className="m-0">or</Divider>
           */}
          <Form
            name="sign-up-form"
            layout="vertical"
            labelCol={{ span: 8 }}
            wrapperCol={{ span: 24 }}
            initialValues={{ remember: true }}
            onFinish={onFinish}
            onFinishFailed={onFinishFailed}
            autoComplete="off"
            requiredMark={false}
          >
            <Row gutter={[8, 0]}>
              <Col xs={24} lg={8}>
                <Form.Item<FieldType>
                  label={
                    <span style={{ whiteSpace: 'nowrap' }}>First name</span>
                  }
                  name="firstName"
                  rules={[
                    {
                      required: true,
                      message: 'Please input your first name!',
                    },
                  ]}
                >
                  <Input />
                </Form.Item>
              </Col>
              <Col xs={24} lg={8}>
                <Form.Item<FieldType>
                  label={
                    <span style={{ whiteSpace: 'nowrap' }}>Second name</span>
                  }
                  name="secondName"
                >
                  <Input />
                </Form.Item>
              </Col>
              <Col xs={24} lg={8}>
                <Form.Item<FieldType>
                  label={
                    <span style={{ whiteSpace: 'nowrap' }}>Last name</span>
                  }
                  name="lastName"
                  rules={[
                    { required: true, message: 'Please input your last name!' },
                  ]}
                >
                  <Input />
                </Form.Item>
              </Col>
              <Col xs={24} lg={12}>
                <Form.Item<FieldType>
                  label="DateOfBirth"
                  name="dateOfBirth"
                  rules={[
                    {
                      validator: (_, value) => {
                        if (!value) {
                          return Promise.reject(
                            new Error('Select your date of birth')
                          );
                        }
                        const sevenYearsAgo = dayjs().subtract(7, 'year');
                        if (value.isAfter(sevenYearsAgo)) {
                          return Promise.reject(
                            new Error('Player must be at least 7 years old')
                          );
                        }
                        return Promise.resolve();
                      },
                    },
                  ]}
                >
                  <DatePicker style={{ width: '100%' }} />
                </Form.Item>
              </Col>
              <Col xs={24} lg={12}>
                <Form.Item<FieldType> label="Gender" name="gender">
                  <Select>
                    <Select.Option value="Male">Male</Select.Option>
                    <Select.Option value="Female">Female</Select.Option>
                  </Select>
                </Form.Item>
              </Col>
              <Col xs={24}>
                <Form.Item<FieldType> label="PhoneNumber" name="phoneNumber">
                  <Input />
                </Form.Item>
              </Col>
              <Col xs={24}>
                <Form.Item<FieldType>
                  label="Email"
                  name="email"
                  rules={[
                    { required: true, message: 'Please input your email' },
                  ]}
                >
                  <Input />
                </Form.Item>
              </Col>
              <Col xs={24}>
                <Form.Item<FieldType>
                  label="Password"
                  name="passwordHash"
                  rules={[
                    { required: true, message: 'Please input your password!' },
                  ]}
                >
                  <Input.Password />
                </Form.Item>
              </Col>
              <Col xs={24}>
                <Form.Item<FieldType>
                  label="Confirm password"
                  name="cPassword"
                  rules={[
                    {
                      required: true,
                      message: 'Please ensure passwords match!',
                    },
                  ]}
                >
                  <Input.Password />
                </Form.Item>
              </Col>
              <Col xs={24}>
                {showOtpField && (
                  <Form.Item label="OTP">
                    <Input
                      value={otpInput}
                      onChange={(e) => setOtpInput(e.target.value)}
                    />
                    <Button
                      type="primary"
                      onClick={handleVerifyOtpAndRegister}
                      style={{ marginTop: '1rem' }}
                    >
                      Verify OTP and Register
                    </Button>
                  </Form.Item>
                )}
              </Col>
            </Row>
            <Form.Item>
              <Button
                type="primary"
                htmlType="submit"
                size="middle"
                loading={loading}
              >
                Submit
              </Button>
            </Form.Item>
          </Form>
        </Flex>
      </Col>
    </Row>
  );
};
