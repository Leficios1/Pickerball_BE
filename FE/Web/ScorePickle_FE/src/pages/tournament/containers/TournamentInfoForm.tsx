import React, { useState, useEffect } from 'react';
import {
  Form,
  Input,
  Button,
  Select,
  DatePicker,
  InputNumber,
  Row,
  Col,
  message,
  Radio,
  Switch,
  Upload,
  Progress,
  Space,
  Card,
  Tooltip,
} from 'antd';
import {
  UploadOutlined,
  LinkOutlined,
  CalendarOutlined,
  TrophyOutlined,
  TeamOutlined,
  ShareAltOutlined,
  InfoCircleOutlined,
  DollarOutlined,
} from '@ant-design/icons';
import moment from 'moment';
import { useUpdateTournament } from '@src/modules/Tournament/hooks/useUpdateTournament';
import useCloudinaryUpload from '@src/modules/Cloudinary/hooks/useCloudinaryUpload';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import { RoleFactory } from '@src/modules/User/models';

const { Option } = Select;

type TournamentInfoFormProps = {
  data: any;
  onSave: (values: any) => void;
};

const TournamentInfoForm = ({ data, onSave }: TournamentInfoFormProps) => {
  const [form] = Form.useForm();
  const { mutate: updateTournament } = useUpdateTournament();
  const [isFree, setIsFree] = useState<boolean>(data?.isFree || false);
  const [savedEntryFee, setSavedEntryFee] = useState<number>(
    data?.entryFee || 10000
  );

  const isDisabled = data.status !== 'Pending';
  const user = useSelector((state: RootState) => state.auth.user);

  const [bannerInputType, setBannerInputType] = useState<'url' | 'upload'>(
    'url'
  );
  const [previewBanner, setPreviewBanner] = useState<string>('');
  const { uploadToCloudinary, uploading, progress } = useCloudinaryUpload();
  const bannerUrl = Form.useWatch('banner', form);

  const isEdit = data.status === 'Scheduled' || data.status === 'Pending';
  const isFieldDisabled = !isEdit;

  useEffect(() => {
    form.setFieldsValue({
      entryFee: data?.isFree ? data?.entryFee : 0,
      isFree: data?.isFree,
    });
    setIsFree(data?.isFree || false);
    setSavedEntryFee(data?.entryFee || 10000);
  }, [data, form]);

  useEffect(() => {
    if (bannerUrl) setPreviewBanner(bannerUrl);
  }, [bannerUrl]);

  useEffect(() => {
    if (data?.banner) setPreviewBanner(data.banner);
  }, [data?.banner]);

  const handleFinish = (values: any) => {
    const updatedValues = {
      ...values,
      startDate: values.startDate ? values.startDate.toISOString() : null,
      endDate: values.endDate ? values.endDate.toISOString() : null,
      entryFee: !values.isFree ? 0 : values.entryFee,
      isMinRanking: Math.max(1, Math.min(9, values.isMinRanking)),
      isMaxRanking: Math.max(
        values.isMinRanking,
        Math.min(9, values.isMaxRanking)
      ),
    };

    const fieldsToUpdate = Object.keys(updatedValues).reduce((acc, key) => {
      if (updatedValues[key] !== data[key]) {
        acc[key] = updatedValues[key];
      }
      return acc;
    }, {} as any);

    updateTournament(
      { id: data.id, data: fieldsToUpdate },
      {
        onSuccess: () => {
          message.success('Tournament updated successfully');
          onSave(updatedValues);
        },
        onError: () => {
          message.error('Failed to update tournament');
        },
      }
    );
  };

  const handleBannerUpload = async (file: File) => {
    try {
      const result = await uploadToCloudinary(file);
      if (result && result.secure_url) {
        form.setFieldsValue({ banner: result.secure_url });
        setPreviewBanner(result.secure_url);
        message.success('Banner uploaded successfully');
        return false;
      }
    } catch (err) {
      message.error('Failed to upload banner image');
    }
    return false;
  };

  return (
    <Form
      form={form}
      layout="vertical"
      initialValues={{
        ...data,
        startDate: data?.startDate ? moment(data?.startDate) : null,
        endDate: data?.endDate ? moment(data?.endDate) : null,
      }}
      onFinish={handleFinish}
    >
      {/* Status Section */}
      <Card
        title={
          <>
            <CalendarOutlined /> Schedule & Status
          </>
        }
        style={{ marginBottom: 24 }}
      >
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              name="status"
              label="Status"
              rules={[{ required: true, message: 'Please select the status!' }]}
            >
              <Select disabled={isFieldDisabled || isDisabled}>
                <Option value="Scheduled">Scheduled</Option>
                <Option value="Ongoing">Ongoing</Option>
                <Option value="Completed">Completed</Option>
                <Option value="Disable">Disable</Option>
              </Select>
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              name="startDate"
              label="Start Date"
              rules={[
                { required: true, message: 'Please select the start date!' },
              ]}
            >
              <DatePicker
                style={{ width: '100%' }}
                disabled={isFieldDisabled || isDisabled}
              />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              name="endDate"
              label="End Date"
              rules={[
                { required: true, message: 'Please select the end date!' },
              ]}
            >
              <DatePicker
                style={{ width: '100%' }}
                disabled={isFieldDisabled || isDisabled}
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* Basic Info Section */}
      <Card
        title={
          <>
            <InfoCircleOutlined /> Basic Information
          </>
        }
        style={{ marginBottom: 24 }}
      >
        <Row gutter={16}>
          <Col span={16}>
            <Form.Item
              name="name"
              label="Tournament Name"
              rules={[{ required: true, message: 'Please input the name!' }]}
            >
              <Input disabled={isFieldDisabled || isDisabled} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              name="type"
              label="Tournament Type"
              rules={[
                {
                  required: true,
                  message: 'Please select the tournament type!',
                },
              ]}
            >
              <Select disabled={isFieldDisabled || isDisabled}>
                <Option value={1}>SingleMale</Option>
                <Option value={2}>SingleFemale</Option>
                <Option value={3}>DoublesMales</Option>
                <Option value={4}>DoublesFemales</Option>
                <Option value={5}>DoublesMix</Option>
              </Select>
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              name="location"
              label="Location"
              rules={[
                { required: true, message: 'Please input the location!' },
              ]}
            >
              <Input disabled={isFieldDisabled || isDisabled} />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* Tournament Details Section */}
      <Card
        title={
          <>
            <TrophyOutlined /> Tournament Details
          </>
        }
        style={{ marginBottom: 24 }}
      >
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              name="totalPrize"
              label="Total Prize"
              rules={[
                { required: true, message: 'Please input the total prize!' },
              ]}
            >
              <InputNumber
                min={0}
                style={{ width: '100%' }}
                formatter={(value) =>
                  `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
                }
                parser={(value: string | undefined) =>
                  value ? Number(value.replace(/[^\d]/g, '')) : 0
                }
              />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              name="maxPlayer"
              label="Max Players"
              rules={[
                { required: true, message: 'Please input the max players!' },
              ]}
            >
              <InputNumber min={1} style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              name="isFree"
              label="Fee Tournament"
              valuePropName="checked"
            >
              <Switch
                checkedChildren="Has Entry Fee"
                unCheckedChildren="Free"
                disabled={isFieldDisabled || isDisabled}
                onChange={(checked) => {
                  setIsFree(checked);
                  if (checked) {
                    form.setFieldsValue({ entryFee: savedEntryFee });
                  } else {
                    const currentFee =
                      form.getFieldValue('entryFee') || savedEntryFee;
                    setSavedEntryFee(currentFee);
                    form.setFieldsValue({ entryFee: 0 });
                  }
                }}
              />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="entryFee"
              label="Entry Fee"
              rules={[
                { required: true, message: 'Please input the entry fee!' },
                {
                  validator: (_, value) => {
                    if (!isFree) return Promise.resolve();
                    if (value >= 10000 && value <= 1000000)
                      return Promise.resolve();
                    return Promise.reject(
                      new Error(
                        'Entry fee must be between 10,000 and 1,000,000'
                      )
                    );
                  },
                },
              ]}
            >
              <InputNumber
                min={isFree ? 10000 : 0}
                max={isFree ? 1000000 : 0}
                style={{ width: '100%' }}
                disabled={!isFree || isFieldDisabled || isDisabled}
                formatter={(value) =>
                  `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
                }
                parser={(value: string | undefined) =>
                  value ? Number(value.replace(/[^\d]/g, '')) : 0
                }
                addonAfter="VND"
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* Section 4: Player Requirements */}
      <Card
        className="section-card"
        title={
          <>
            <TeamOutlined /> Player Requirements
          </>
        }
        style={{ marginBottom: 24 }}
      >
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="isMinRanking"
              label={
                <span>
                  Minimum Ranking{' '}
                  <Tooltip title="Minimum ranking must be between 1 and 9">
                    <InfoCircleOutlined style={{ color: '#1890ff' }} />
                  </Tooltip>
                </span>
              }
              rules={[
                {
                  required: true,
                  message: 'Please input the minimum ranking!',
                },
                {
                  type: 'number',
                  min: 1,
                  max: 9,
                  message: 'Ranking must be between 1 and 9',
                },
              ]}
            >
              <InputNumber
                min={1}
                max={9}
                style={{ width: '100%' }}
                disabled={isFieldDisabled || isDisabled}
                precision={0}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="isMaxRanking"
              label={
                <span>
                  Maximum Ranking{' '}
                  <Tooltip title="Maximum ranking must be between 1 and 9 and greater than or equal to minimum ranking">
                    <InfoCircleOutlined style={{ color: '#1890ff' }} />
                  </Tooltip>
                </span>
              }
              rules={[
                {
                  required: true,
                  message: 'Please input the maximum ranking!',
                },
                {
                  type: 'number',
                  min: 1,
                  max: 9,
                  message: 'Ranking must be between 1 and 9',
                },
                {
                  validator: (_, value) => {
                    const minRanking = form.getFieldValue('isMinRanking');
                    if (value < 1 || value > 9) {
                      return Promise.reject(
                        new Error('Maximum ranking must be between 1 and 9')
                      );
                    }
                    if (value < minRanking) {
                      return Promise.reject(
                        new Error(
                          'Maximum ranking must be greater than or equal to minimum ranking'
                        )
                      );
                    }
                    return Promise.resolve();
                  },
                },
              ]}
            >
              <InputNumber
                min={1}
                max={9}
                style={{ width: '100%' }}
                disabled={isFieldDisabled || isDisabled}
                precision={0}
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* Section 5: Media & Social */}
      <Card
        className="section-card"
        title={
          <>
            <ShareAltOutlined /> Media & Social
          </>
        }
        style={{ marginBottom: 24 }}
      >
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item name="social" label="Social Media Link">
              <Input
                placeholder="https://example.com/social"
                disabled={isFieldDisabled}
              />
            </Form.Item>
          </Col>
        </Row>

        {/* Banner with upload option */}
        <Form.Item label="Banner Image">
          <Radio.Group
            value={bannerInputType}
            onChange={(e) => setBannerInputType(e.target.value)}
            style={{ marginBottom: 16 }}
          >
            <Radio.Button value="url" disabled={isFieldDisabled}>
              <LinkOutlined /> URL
            </Radio.Button>
            <Radio.Button value="upload" disabled={isFieldDisabled}>
              <UploadOutlined /> Upload
            </Radio.Button>
          </Radio.Group>

          {bannerInputType === 'url' ? (
            <Form.Item
              name="banner"
              noStyle
              rules={[
                { required: true, message: 'Please input the banner URL!' },
              ]}
            >
              <Input
                placeholder="https://example.com/banner.jpg"
                disabled={isFieldDisabled}
              />
            </Form.Item>
          ) : (
            <Form.Item
              name="banner"
              noStyle
              rules={[
                { required: true, message: 'Please upload a banner image!' },
              ]}
            >
              <Space direction="vertical" style={{ width: '100%' }}>
                <Upload.Dragger
                  name="file"
                  multiple={false}
                  showUploadList={false}
                  beforeUpload={handleBannerUpload}
                  accept="image/*"
                  disabled={isFieldDisabled}
                >
                  <p className="ant-upload-drag-icon">
                    <UploadOutlined />
                  </p>
                  <p className="ant-upload-text">
                    Click or drag image to upload
                  </p>
                </Upload.Dragger>
                {uploading && (
                  <Progress
                    percent={progress}
                    size="small"
                    style={{ marginTop: 8 }}
                  />
                )}
              </Space>
            </Form.Item>
          )}
        </Form.Item>

        {/* Banner Preview */}
        {previewBanner && (
          <div style={{ marginBottom: 16 }}>
            <p>Banner Preview:</p>
            <img
              src={previewBanner}
              alt="Banner Preview"
              style={{ maxWidth: '100%', maxHeight: 200, objectFit: 'contain' }}
            />
          </div>
        )}
      </Card>

      {/* Submit Button */}
      {user?.roleId === RoleFactory.Sponsor && (
        <Form.Item>
          <Button
            type="primary"
            htmlType="submit"
            size="large"
            style={{ width: '100%' }}
            disabled={uploading}
          >
            {uploading ? 'Uploading...' : 'Save Tournament'}
          </Button>
        </Form.Item>
      )}
    </Form>
  );
};

export default React.memo(TournamentInfoForm);
