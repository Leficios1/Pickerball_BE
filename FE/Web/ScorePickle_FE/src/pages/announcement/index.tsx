import React, { useState } from 'react';
import {
  Tabs,
  Card,
  Row,
  Col,
  Typography,
  Tag,
  Spin,
  Empty,
  Modal,
  Badge,
  Divider,
} from 'antd';
import {
  AppstoreOutlined,
  InfoCircleOutlined,
  ReadOutlined,
  BulbOutlined,
} from '@ant-design/icons';
import { motion, AnimatePresence } from 'framer-motion';

// Import hooks for fetching data
import { useGetAllRules } from '@src/modules/Category/hooks/useGetAllRules';
import { useGetBlogCategories } from '@src/modules/Category/hooks/useGetBlogCategories';

const { TabPane } = Tabs;
const { Title, Text } = Typography;

interface Rule {
  id: number;
  title: string;
  content: string;
  blogCategoryId: number;
  image1?: string;
  image2?: string;
}

// Animation variants
const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
    },
  },
};

const itemVariants = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: {
      type: 'spring',
      stiffness: 300,
      damping: 24,
    },
  },
};

const fadeIn = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { duration: 0.6 },
  },
};

const Announcement: React.FC = () => {
  const [viewingContent, setViewingContent] = useState<Rule | null>(null);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [activeTabKey, setActiveTabKey] = useState<string>('all');

  // Fetch categories and rules
  const { data: categoriesData, isLoading: loadingCategories } =
    useGetBlogCategories();
  const { data: rulesData, isLoading: loadingRules } = useGetAllRules();

  const categories = categoriesData?.results || [];
  const rules = rulesData?.results || [];

  // Show content when clicking on an announcement
  const handleViewContent = (rule: Rule) => {
    setViewingContent(rule);
    setIsModalVisible(true);
  };

  // Filter rules based on active tab
  const getFilteredRules = () => {
    if (activeTabKey === 'all') {
      return rules;
    }
    return rules.filter(
      (rule) => rule.blogCategoryId === parseInt(activeTabKey)
    );
  };

  // Get category name by id
  const getCategoryName = (categoryId: number) => {
    const category = categories.find((cat) => cat.id === categoryId);
    return category ? category.name : 'General';
  };

  if (loadingCategories || loadingRules) {
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        style={{ textAlign: 'center', padding: '50px' }}
      >
        <Spin size="large" />
        <motion.p
          initial={{ y: 10, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          Loading announcements...
        </motion.p>
      </motion.div>
    );
  }

  return (
    <motion.div
      className="announcement-container"
      initial="hidden"
      animate="visible"
      variants={fadeIn}
    >
      {/* Hero Banner */}
      <motion.div
        initial={{ y: -30, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ type: 'spring', stiffness: 100, damping: 20 }}
      >
        <Card
          style={{
            marginBottom: 24,
            background: 'linear-gradient(135deg, #1890ff 0%, #722ed1 100%)',
            color: 'white',
            borderRadius: '8px',
          }}
          bodyStyle={{ padding: '24px' }}
          bordered={false}
        >
          <Title level={2} style={{ color: 'white', margin: 0 }}>
            <InfoCircleOutlined /> Announcements
          </Title>
          <Text style={{ color: 'rgba(255,255,255,0.85)' }}>
            Important information and updates for players
          </Text>
        </Card>
      </motion.div>

      {/* Main Content */}
      <motion.div
        style={{
          background: '#fff',
          padding: '24px',
          borderRadius: '8px',
        }}
        initial={{ y: 30, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ type: 'spring', stiffness: 100, damping: 20, delay: 0.2 }}
      >
        <Tabs
          activeKey={activeTabKey}
          onChange={setActiveTabKey}
          type="card"
          className="announcement-tabs"
          tabBarExtraContent={
            <motion.div whileHover={{ scale: 1.1 }} whileTap={{ scale: 0.95 }}>
              <Badge
                count={rules.length}
                style={{ backgroundColor: '#52c41a' }}
              >
                <ReadOutlined
                  style={{ fontSize: '20px', marginRight: '8px' }}
                />
              </Badge>
            </motion.div>
          }
        >
          <TabPane
            tab={
              <span>
                <AppstoreOutlined /> All
              </span>
            }
            key="all"
          >
            {renderAnnouncementCards(getFilteredRules())}
          </TabPane>

          {categories.map((category) => (
            <TabPane
              tab={
                <span>
                  {category.name}
                  <Badge
                    count={
                      rules.filter((r) => r.blogCategoryId === category.id)
                        .length
                    }
                    style={{ marginLeft: 8 }}
                  />
                </span>
              }
              key={category.id.toString()}
            >
              {renderAnnouncementCards(getFilteredRules())}
            </TabPane>
          ))}
        </Tabs>
      </motion.div>

      {/* Content Modal */}
      <AnimatePresence>
        {isModalVisible && (
          <Modal
            title={
              <motion.div
                initial={{ x: -20, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                style={{ display: 'flex', alignItems: 'center' }}
              >
                <motion.span
                  animate={{ rotate: [0, 20, -20, 0] }}
                  transition={{ duration: 0.6, delay: 0.2 }}
                >
                  <BulbOutlined
                    style={{
                      marginRight: '12px',
                      color: '#1890ff',
                      fontSize: '20px',
                    }}
                  />
                </motion.span>
                <span>{viewingContent?.title}</span>
              </motion.div>
            }
            open={isModalVisible}
            onCancel={() => setIsModalVisible(false)}
            footer={null}
            width={800}
          >
            {viewingContent && (
              <>
                {/* Category Tag and Info */}
                <motion.div
                  initial={{ y: 10, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.1 }}
                  style={{
                    marginBottom: 16,
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                  }}
                >
                  <Tag color="blue" style={{ padding: '4px 8px' }}>
                    {getCategoryName(viewingContent.blogCategoryId)}
                  </Tag>
                  <Text type="secondary">
                    Announcement #{viewingContent.id}
                  </Text>
                </motion.div>

                {/* Images Section */}
                {(viewingContent.image1 || viewingContent.image2) && (
                  <motion.div
                    initial={{ y: 20, opacity: 0 }}
                    animate={{ y: 0, opacity: 1 }}
                    transition={{ delay: 0.2 }}
                    style={{ marginBottom: 24 }}
                  >
                    <Row gutter={16}>
                      {viewingContent.image1 && (
                        <Col span={viewingContent.image2 ? 12 : 24}>
                          <motion.div
                            className="image-container"
                            whileHover={{ scale: 1.02 }}
                            transition={{
                              type: 'spring',
                              stiffness: 400,
                              damping: 10,
                            }}
                          >
                            <img
                              src={viewingContent.image1}
                              alt="Image 1"
                              style={{
                                width: '100%',
                                borderRadius: 8,
                                boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
                              }}
                            />
                          </motion.div>
                        </Col>
                      )}
                      {viewingContent.image2 && (
                        <Col span={viewingContent.image1 ? 12 : 24}>
                          <motion.div
                            className="image-container"
                            whileHover={{ scale: 1.02 }}
                            transition={{
                              type: 'spring',
                              stiffness: 400,
                              damping: 10,
                            }}
                          >
                            <img
                              src={viewingContent.image2}
                              alt="Image 2"
                              style={{
                                width: '100%',
                                borderRadius: 8,
                                boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
                              }}
                            />
                          </motion.div>
                        </Col>
                      )}
                    </Row>
                  </motion.div>
                )}

                <motion.div
                  initial={{ y: 20, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.3 }}
                >
                  <Divider style={{ marginTop: 0 }}>
                    <Text strong style={{ color: '#1890ff' }}>
                      Content Details
                    </Text>
                  </Divider>
                </motion.div>

                {/* Content */}
                <motion.div
                  initial={{ y: 30, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.4 }}
                  className="content-container"
                  dangerouslySetInnerHTML={{ __html: viewingContent.content }}
                />
              </>
            )}
          </Modal>
        )}
      </AnimatePresence>

      {/* CSS Styles */}
      <style>{`
        .announcement-container {
          max-width: 1200px;
          margin: 20px auto;
          padding: 0 16px;
        }
        
        .announcement-tabs .ant-tabs-tab {
          padding: 12px 16px;
          font-size: 15px;
          transition: all 0.3s ease;
        }
        
        .announcement-tabs .ant-tabs-tab:hover {
          color: #1890ff;
          transform: translateY(-2px);
        }
        
        .announcement-tabs .ant-tabs-tab-active {
          font-weight: 500;
        }
        
        .announcement-card {
          height: 100%;
          transition: all 0.3s;
        }
        
        .announcement-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .card-image-container {
          overflow: hidden;
          border-radius: 8px 8px 0 0;
          position: relative;
        }
        
        .card-image-container:after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          right: 0;
          height: 40px;
          background: linear-gradient(transparent, rgba(0,0,0,0.3));
        }
        
        .card-image-container img {
          transition: transform 0.3s ease;
        }
        
        .announcement-card:hover .card-image-container img {
          transform: scale(1.05);
        }
        
        .rule-preview {
          margin-top: 8px;
          color: #666;
          font-size: 14px;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 3;
          -webkit-box-orient: vertical;
        }
        
        .content-container {
          padding: 16px;
          background: #fafafa;
          border-radius: 8px;
          overflow-x: auto;
          line-height: 1.6;
        }
        
        .content-container img {
          max-width: 100%;
        }
        
        .content-container h1, 
        .content-container h2, 
        .content-container h3 {
          margin-top: 16px;
          margin-bottom: 8px;
        }
        
        .content-container ul, 
        .content-container ol {
          padding-left: 24px;
          margin-bottom: 16px;
        }
        
        .content-container blockquote {
          border-left: 4px solid #1890ff;
          padding-left: 16px;
          margin-left: 0;
          color: #666;
        }
        
        .content-container li {
          margin-bottom: 8px;
        }
        
        .content-container strong {
          color: #1890ff;
        }
        
        .image-container {
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .no-announcements {
          text-align: center;
          padding: 40px 0;
        }
        
        /* Modal animation styles */
        .ant-modal {
          transform-origin: top;
        }
        
        @keyframes floatAnimation {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-6px); }
          100% { transform: translateY(0px); }
        }
        
        .float-animation {
          animation: floatAnimation 3s ease infinite;
        }
      `}</style>
    </motion.div>
  );

  // Helper function to render announcement cards
  function renderAnnouncementCards(rulesData: Rule[]) {
    if (rulesData.length === 0) {
      return (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.2 }}
          className="no-announcements"
        >
          <Empty description="No announcements available in this category" />
        </motion.div>
      );
    }

    return (
      <motion.div
        variants={containerVariants}
        initial="hidden"
        animate="visible"
      >
        <Row gutter={[16, 16]}>
          {rulesData.map((rule, index) => (
            <Col xs={24} sm={12} md={8} lg={6} key={rule.id}>
              <motion.div
                variants={itemVariants}
                custom={index}
                whileHover={{ y: -5, transition: { duration: 0.2 } }}
                className="card-motion-wrapper"
              >
                <Card
                  className="announcement-card"
                  hoverable
                  cover={
                    rule.image1 && (
                      <div className="card-image-container">
                        <img
                          alt={rule.title}
                          src={rule.image1}
                          style={{
                            height: 180,
                            width: '100%',
                            objectFit: 'cover',
                          }}
                        />
                      </div>
                    )
                  }
                  onClick={() => handleViewContent(rule)}
                >
                  <Card.Meta
                    title={
                      <motion.div
                        style={{ height: '48px', overflow: 'hidden' }}
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: 0.1 }}
                      >
                        {rule.title}
                      </motion.div>
                    }
                    description={
                      <>
                        <motion.div
                          initial={{ opacity: 0 }}
                          animate={{ opacity: 1 }}
                          transition={{ delay: 0.2 }}
                        >
                          <Tag color="blue">
                            {getCategoryName(rule.blogCategoryId)}
                          </Tag>
                          {rule.image2 && (
                            <Tag color="green" style={{ marginLeft: 4 }}>
                              +1 image
                            </Tag>
                          )}
                        </motion.div>
                        <motion.div
                          className="rule-preview"
                          initial={{ opacity: 0, y: 10 }}
                          animate={{ opacity: 1, y: 0 }}
                          transition={{ delay: 0.3 }}
                        >
                          {(
                            rule.content?.replace(/<[^>]+>/g, '') || ''
                          ).substring(0, 100)}
                          {(rule.content?.replace(/<[^>]+>/g, '') || '')
                            .length > 100
                            ? '...'
                            : ''}
                        </motion.div>
                      </>
                    }
                  />
                </Card>
              </motion.div>
            </Col>
          ))}
        </Row>
      </motion.div>
    );
  }
};

export default Announcement;
