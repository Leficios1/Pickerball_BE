import {
  Button,
  Col,
  Flex,
  Form,
  Input,
  message,
  Row,
  Spin,
  theme,
  Typography,
} from 'antd';
import { useMediaQuery } from 'react-responsive';
import { useState } from 'react';
import { RootState } from '@src/redux/store';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { setVerified } from '@src/redux/user/userSlice';

const { Title, Text } = Typography;

type FieldType = {
  otp?: string;
};

export const VerifyOtp = () => {
  const {
    token: { colorPrimary },
  } = theme.useToken();
  const isMobile = useMediaQuery({ maxWidth: 769 });
  const [loading, setLoading] = useState(false);
  const otp = useSelector((state: RootState) => state.user.otp);
  const navigate = useNavigate();
  const dispatch = useDispatch();

  if (loading) {
    return (
      <Spin className="d-flex justify-content-between align-items-center"></Spin>
    );
  }

  const onFinish = async (values: FieldType) => {
    setLoading(true);
    try {
      if (Number(values.otp) === otp) {
        message.success('OTP verified successfully!');
        dispatch(setVerified(true));
        navigate('/auth/signup');
      } else {
        message.error('Incorrect OTP. Please try again.');
      }
    } catch (error) {
      message.error('Something went wrong. Please try again later.');
    } finally {
      setLoading(false);
    }
  };

  const onFinishFailed = (errorInfo: any) => {
    console.log('Form Failed:', errorInfo);
  };

  return (
    <Row style={{ minHeight: isMobile ? 'auto' : '100vh', overflow: 'hidden' }}>
      <Col xs={24} lg={12}>
        <Flex
          vertical
          align="center"
          justify="center"
          className="text-center"
          style={{ background: colorPrimary, height: '100%', padding: '1rem' }}
        >
          {/* You can add an image or illustration here */}
          <></>
        </Flex>
      </Col>
      <Col xs={24} lg={12}>
        <Flex
          vertical
          align={isMobile ? 'center' : 'flex-start'}
          justify="center"
          gap="middle"
          style={{ height: '100%', width: '100%', padding: '2rem' }}
        >
          <Title className="m-0">Verify OTP</Title>
          <Text>Enter the OTP sent to your email to verify your account.</Text>
          <Form
            name="otp-verify-form"
            layout="vertical"
            labelCol={{ span: 24 }}
            wrapperCol={{ span: 24 }}
            initialValues={{ remember: true }}
            onFinish={onFinish}
            onFinishFailed={onFinishFailed}
            autoComplete="off"
            requiredMark={false}
            style={{ width: '100%' }}
          >
            <Form.Item<FieldType>
              label="OTP"
              name="otp"
              rules={[
                { required: true, message: 'Please enter the OTP' },
                {
                  len: 6,
                  message: 'OTP must be 6 digits',
                  transform: (value) => value?.trim(),
                },
              ]}
            >
              <Input maxLength={6} />
            </Form.Item>
            <Form.Item>
              <Flex align="center" gap="small">
                <Button
                  type="primary"
                  htmlType="submit"
                  size="middle"
                  loading={loading}
                >
                  Submit
                </Button>
                <Button
                  type="text"
                  size="middle"
                  disabled={loading}
                  onClick={() => navigate('/auth/register-account')}
                >
                  Cancel
                </Button>
              </Flex>
            </Form.Item>
          </Form>
        </Flex>
      </Col>
    </Row>
  );
};
