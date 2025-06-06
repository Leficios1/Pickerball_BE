import type React from 'react';
import { useEffect, useState } from 'react';
import { Form, Input, Button, message } from 'antd';
import { CameraOutlined } from '@ant-design/icons';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import useCloudinaryUpload from '@src/modules/Cloudinary/hooks/useCloudinaryUpload';
import { UpdateSponsorProfileRequest } from '@src/modules/Profile/models';
import { useCreateSponsorProfile } from '@src/modules/Profile/hooks/useCreateSpnosorProfile';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { useNavigate } from 'react-router-dom';

const SponsorProfile: React.FC = () => {
  const [form] = Form.useForm();
  const [logoUrl, setLogoUrl] = useState<string>(
    'https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg'
  );
  const { uploadToCloudinary } = useCloudinaryUpload();
  const { mutate: createProfile } = useCreateSponsorProfile();
  const sponsorId = useSelector((state: RootState) => state.user.userId) ?? 0;
  const user = useSelector((state: RootState) => state.auth.user);
  const email = useSelector((state: RootState) => state.user.email);
  const [userId, setUserId] = useState(0);

  useEffect(() => {
    setUserId(user?.id ?? 0);
    if (!user?.id && !sponsorId) {
      navigate('/auth/signin');
    }
  }, [user?.id]);
  const navigate = useNavigate();

  const handleImageUpload = async (file: File) => {
    try {
      const result = await uploadToCloudinary(file);
      if (result && result.secure_url) {
        setLogoUrl(result.secure_url);
        message.success('Image uploaded successfully');
      }
    } catch (err) {
      message.error('Failed to upload image');
    }
  };

  const handleCreateProfile = async (values: UpdateSponsorProfileRequest) => {
    const updatedValues = {
      ...values,
      id: sponsorId ?? userId,
      contactEmail: email ?? user?.email,
      logoUrl,
    };

    createProfile(
      { id: sponsorId!, data: updatedValues },
      {
        onSuccess: () => {
          message.success('Sponsor created successfully!');
          navigate('/auth/signin');
        },
        onError: () => {
          message.error('Failed to create sponsor');
        },
      }
    );
  };

  const onFinish = (values: UpdateSponsorProfileRequest) => {
    handleCreateProfile(values);
  };

  return (
    <div className="container d-flex justify-content-center align-items-center">
      <div
        className="d-flex flex-column"
        style={{
          minHeight: '100vh',
          width: '100%', // Adjust for mobile responsiveness
          maxWidth: '600px', // Limit max width to avoid stretching on large screens
        }}
      >
        <div className="p-4 mt-3">
          <h3 className="text-center mb-4">Register as a Sponsor</h3>

          {/* Form */}
          <Form form={form} layout="vertical" onFinish={onFinish}>
            {/* Profile Image */}
            <div className="mb-4 w-100 d-flex justify-content-center">
              <div
                className="position-relative"
                style={{ width: '300px', height: '300px' }}
              >
                <img
                  src={logoUrl || '/placeholder.svg'}
                  alt="Profile"
                  className="w-100 h-100 object-fit-cover"
                />
                <label
                  htmlFor="logo-image"
                  className="position-absolute bottom-0 end-0 bg-white rounded-circle p-1 cursor-pointer"
                  style={{ cursor: 'pointer' }}
                >
                  <CameraOutlined
                    style={{ fontSize: '20px', color: '#0066cc' }}
                  />
                </label>
                <input
                  id="logo-image"
                  type="file"
                  accept="image/*"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) {
                      handleImageUpload(file);
                    }
                  }}
                  style={{ display: 'none' }}
                />
              </div>
            </div>

            {/* Full Name Fields */}
            <Form.Item
              name="companyName"
              label={<span className="text-black">Company Name</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="descreption"
              label={<span className="text-black">Description</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="urlSocial"
              label={<span className="text-black">Social URL</span>}
              rules={[
                { required: true, message: 'Please input url' },
                {
                  pattern: /^(https?:\/\/)/,
                  message: 'URL must start with http:// or https://',
                },
              ]}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="urlSocial1"
              label={<span className="text-black">Other Social URL</span>}
              rules={[
                { required: true, message: 'Please input url' },
                {
                  pattern: /^(https?:\/\/)/,
                  message: 'URL must start with http:// or https://',
                },
              ]}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
              />
            </Form.Item>

            {/* <Form.Item
              name="contactEmail"
              label={<span className="text-black">Contact Email</span>}
            >
              <Input 
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                value={user?.email} 
                readOnly 
              />
            </Form.Item> */}

            {/* Save Button */}
            <Form.Item className="text-end mt-4">
              <Button
                type="primary"
                htmlType="submit"
                className="rounded-pill px-4"
                style={{
                  backgroundColor: '#e6f7ff',
                  color: '#0066cc',
                  border: 'none',
                  width: '30%', // Make button full width on smaller screens
                }}
              >
                Save
              </Button>
            </Form.Item>
          </Form>
        </div>
      </div>
    </div>
  );
};

export default SponsorProfile;
