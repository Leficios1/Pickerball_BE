import {
  ApartmentOutlined,
  BellOutlined,
  CalendarOutlined,
  ContainerOutlined,
  DollarCircleOutlined,
  EditOutlined,
  LockOutlined,
  LoginOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  ReadOutlined,
  TeamOutlined,
  ThunderboltOutlined,
  TrophyOutlined,
  UserAddOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  PATH_MATCH_PAGE,
  PATH_PLAYER_PAGE,
  PATH_RANKING_PAGE,
  PATH_RULE_PAGE,
  PATH_TOURNAMENT_PAGE,
} from '@src/constants/routes';
import { useCountNotification } from '@src/modules/Notification/hooks/useCountNoti';
import useLogout from '@src/modules/User/hooks/useLogout';
import FriendRequest from '@src/pages/friend/FriendRequest';
import TournamentInvitation from '@src/pages/tournamentPage/containers/TournamentInvitation';
import { RootState } from '@src/redux/store';
import {
  Avatar as AntAvatar,
  Badge,
  Button,
  Card,
  Drawer,
  Dropdown,
  Flex,
  FloatButton,
  Layout,
  MenuProps,
  Modal,
  Tabs,
  theme,
  Tooltip,
} from 'antd';
import TabPane from 'antd/es/tabs/TabPane';
import { motion } from 'framer-motion';
import { useEffect, useRef, useState } from 'react';
import { useSelector } from 'react-redux';
import { useMediaQuery } from 'react-responsive';
import { Link, Outlet, useLocation } from 'react-router-dom';
import {
  CSSTransition,
  SwitchTransition,
  TransitionGroup,
} from 'react-transition-group';
import { Logo, NProgress } from '../../components';
import { PATH_AUTH, PATH_LANDING } from '../../constants';
import './guest-layout.css';

const { Header, Content } = Layout;

interface NavItem {
  path: string;
  label: string;
  icon: JSX.Element;
  exact?: boolean;
}

export const GuestLayout = () => {
  const {
    token: { borderRadius },
  } = theme.useToken();
  const isMobile = useMediaQuery({ maxWidth: 769 });
  const [isLoading, setIsLoading] = useState(false);
  const location = useLocation();
  const nodeRef = useRef(null);
  const [open, setOpen] = useState(false);
  const user = useSelector((state: RootState) => state.auth.user);
  const { data: countNoti } = useCountNotification(user?.id ?? 0);

  const { logout } = useLogout();

  // Navigation menu items definition
  const navigationItems: NavItem[] = [
    {
      path: PATH_TOURNAMENT_PAGE.root,
      label: 'Tournaments',
      icon: <TrophyOutlined />,
    },
    {
      path: PATH_MATCH_PAGE.root,
      label: 'Matches',
      icon: <ThunderboltOutlined />,
    },
    {
      path: PATH_PLAYER_PAGE.root,
      label: 'Players',
      icon: <TeamOutlined />,
    },
    {
      path: PATH_RULE_PAGE.root,
      label: 'Platform Rules',
      icon: <ReadOutlined />,
    },
    {
      path: PATH_RANKING_PAGE.root,
      label: 'Top Rankings',
      icon: <ApartmentOutlined />,
    },
    {
      path: 'announcement',
      label: 'Announcement',
      icon: <ContainerOutlined />,
    },
  ];

  // User menu items
  const userMenuItems: NavItem[] = [];

  // Check if the current path is active
  const isActive = (path: string, exact = false) => {
    if (exact) {
      return location.pathname === path;
    }
    return location.pathname.startsWith(path);
  };

  // User dropdown menu items
  const dropdownItems: MenuProps['items'] = [
    {
      label: (
        <motion.div
          initial={{ opacity: 0, y: 5 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.2 }}
        >
          <Card
            style={{ width: 300, border: '0' }}
            bodyStyle={{ padding: 10, paddingBottom: '20px' }}
            className="user-profile-card"
          >
            <Link
              to={`profile/${user?.id}`}
              className="d-flex align-items-center text-decoration-none text-reset"
            >
              <Flex align="center">
                <AntAvatar
                  src={
                    user?.avatarUrl ??
                    'https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg'
                  }
                  alt="user avatar"
                  size={64}
                  className="user-avatar"
                />
                <div className="ms-3" style={{ whiteSpace: 'nowrap' }}>
                  <div className="user-name">
                    {user?.firstName + ' ' + user?.lastName}
                  </div>
                  <div className="user-location">
                    {user?.userDetails?.province?.toLocaleLowerCase() +
                      ', ' +
                      user?.userDetails?.city?.toLocaleLowerCase()}
                    <span className="mx-1">•</span>
                    {user?.gender}
                  </div>
                  <div className="mt-1">
                    <span className="user-level">
                      Level {user?.userDetails?.experienceLevel}
                    </span>
                  </div>
                </div>
              </Flex>
            </Link>
          </Card>
        </motion.div>
      ),
      key: 'profile',
      style: { padding: '0', marginBottom: '10px' },
    },
    {
      key: 'profile-gap',
      label: <div className="menu-section-header">My Account</div>,
      disabled: true,
      style: {
        padding: '8px 16px',
        backgroundColor: 'rgba(0, 0, 0, 0.04)',
        fontWeight: '600',
      },
    },
    {
      key: 'user-profile-link',
      label: (
        <Link to={`edit-profile`} className="menu-item">
          <EditOutlined className="me-2" />
          Edit Profile
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      key: 'user-password-link',
      label: (
        <Link to={`update-password`} className="menu-item">
          <LockOutlined className="me-2" />
          Password
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      key: 'info-gap',
      label: <div className="menu-section-header">Activity</div>,
      disabled: true,
      style: {
        padding: '8px 16px',
        backgroundColor: 'rgba(0, 0, 0, 0.04)',
        fontWeight: '600',
      },
    },
    {
      key: 'my-friend',
      label: (
        <Link to={`my-friend`} className="menu-item">
          <TeamOutlined className="me-2" />
          Friends
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      key: 'my-tournament',
      label: (
        <Link to={`my-tournament`} className="menu-item">
          <TrophyOutlined className="me-2" />
          Registered Tournaments
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      key: 'my-match',
      label: (
        <Link to={`match-calendar`} className="menu-item">
          <CalendarOutlined className="me-2" />
          Matches Calendar
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      type: 'divider',
    },
    {
      key: 'transaction',
      label: (
        <Link to={`transaction`} className="menu-item">
          <DollarCircleOutlined className="me-2" />
          Transaction
        </Link>
      ),
      style: {
        padding: '10px 16px',
      },
    },
    {
      type: 'divider',
    },
    {
      key: 'user-logout-link',
      label: (
        <div className="menu-item text-danger">
          <LogoutOutlined className="me-2" />
          Logout
        </div>
      ),
      danger: true,
      onClick: () => logout(),
      style: {
        padding: '10px 16px',
      },
    },
  ];

  const showDrawer = () => {
    setOpen(true);
  };

  const onClose = () => {
    setOpen(false);
  };

  // Notification modal state and handlers
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [activeTab, setActiveTab] = useState('1');

  const showNotification = () => {
    setIsModalVisible(true);
  };

  const handleCancel = () => {
    setIsModalVisible(false);
  };

  // Close drawer when navigating on mobile
  useEffect(() => {
    if (open && isMobile) {
      setOpen(false);
    }
  }, [location.pathname, isMobile]);

  return (
    <>
      <NProgress isAnimating={isLoading} key={location.key} />
      <Layout
        className="layout"
        style={{
          minHeight: '100vh',
        }}
      >
        <Header
          className="main-header"
          style={{
            width: isMobile ? 'calc(100% - 16px)' : 'calc(100% - 40px)',
            borderRadius: '16px',
            padding: isMobile ? '0 16px' : '0 24px',
          }}
        >
          <div className="header-content">
            {/* Logo */}
            <div className="header-logo">
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.3 }}
              >
                <Logo
                  color="black"
                  asLink
                  href={PATH_LANDING.root}
                  style={{ width: isMobile ? 120 : 170 }}
                />
              </motion.div>
            </div>

            {!isMobile ? (
              // Desktop Menu
              <div className="header-nav">
                {/* Navigation Items */}
                <div className="nav-items">
                  {navigationItems.map((item) => (
                    <motion.div
                      key={item.path}
                      whileHover={{ y: -2 }}
                      whileTap={{ scale: 0.95 }}
                    >
                      <Link to={item.path} className="nav-link-container">
                        <Button
                          type={
                            isActive(item.path, item.exact) ? 'primary' : 'text'
                          }
                          icon={item.icon}
                          className={`nav-link ${
                            isActive(item.path, item.exact) ? 'active' : ''
                          } font-weight-500`}
                        >
                          {item.label}
                        </Button>
                      </Link>
                    </motion.div>
                  ))}
                </div>

                {/* User Menu */}
                <div className="auth-section">
                  {user ? (
                    <Flex gap="small" align="center">
                      {userMenuItems.map((item) => (
                      <motion.div
                        key={item.path}
                        whileHover={{ y: -3, scale: 1.05 }}
                        whileTap={{ scale: 0.9 }}
                      >
                        <Link to={item.path} className="nav-link-container">
                        <Button
                          type={
                          isActive(item.path, item.exact)
                            ? 'primary'
                            : 'text'
                          }
                          icon={item.icon}
                          className={`nav-link ${
                          isActive(item.path, item.exact) ? 'active' : ''
                          } font-weight-600`}
                          style={{
                          fontWeight: 600,
                          textTransform: 'uppercase',
                          letterSpacing: '0.5px',
                          boxShadow: isActive(item.path, item.exact) 
                            ? '0 4px 8px rgba(0,0,0,0.15)' 
                            : 'none'
                          }}
                        >
                          {item.label}
                        </Button>
                        </Link>
                      </motion.div>
                      ))}

                      {/* Notification Button */}
                      <motion.div
                        whileHover={{ y: -2, scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        <Button
                          type="text"
                          icon={
                            <Badge
                              count={countNoti}
                              overflowCount={99}
                              offset={[5, -10]}
                            >
                              <BellOutlined className="notification-icon" />
                            </Badge>
                          }
                          onClick={showNotification}
                          className="notification-button"
                          style={{ width: '50px' }}
                        />
                      </motion.div>

                      {/* User Avatar Dropdown */}
                      <Dropdown
                        menu={{
                          items: dropdownItems,
                        }}
                        trigger={['click']}
                        placement="bottomRight"
                        overlayClassName="user-dropdown"
                        getPopupContainer={(trigger) => trigger.parentElement!}
                      >
                        <motion.div
                          whileHover={{ scale: 1.05 }}
                          whileTap={{ scale: 0.95 }}
                          className="avatar-container"
                        >
                          <AntAvatar
                            src={
                              user.avatarUrl ??
                              'https://images.icon-icons.com/3446/PNG/512/account_profile_user_avatar_icon_219236.png'
                            }
                            alt="user profile photo"
                            size={40}
                            className="user-avatar-small"
                          />
                        </motion.div>
                      </Dropdown>
                    </Flex>
                  ) : (
                    <Flex gap="small">
                      <motion.div
                        whileHover={{ y: -2 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        <Link to={PATH_AUTH.signin}>
                          <Button
                            icon={<LoginOutlined />}
                            className="login-button"
                          >
                            Login
                          </Button>
                        </Link>
                      </motion.div>

                      <motion.div
                        whileHover={{ y: -2 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        <Link to={PATH_AUTH.signup}>
                          <Button
                            icon={<UserAddOutlined />}
                            type="primary"
                            className="register-button"
                          >
                            Register
                          </Button>
                        </Link>
                      </motion.div>
                    </Flex>
                  )}
                </div>
              </div>
            ) : (
              // Mobile Menu
              <Tooltip title={`${open ? 'Close menu' : 'Open menu'}`}>
                <motion.div whileTap={{ scale: 0.9 }}>
                  <Button
                    type="text"
                    icon={open ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
                    onClick={showDrawer}
                    className="mobile-menu-button"
                  />
                </motion.div>
              </Tooltip>
            )}
          </div>
        </Header>

        {/* Page Content */}
        <Content
          style={{
            borderRadius,
            transition: 'all .25s',
            paddingBottom: '10rem',
            background: 'linear-gradient(to right, #1e3a8a, #3b82f6)',
            paddingTop: '80px',
          }}
        >
          <TransitionGroup>
            <SwitchTransition>
              <CSSTransition
                key={`css-transition-${location.key}`}
                nodeRef={nodeRef}
                onEnter={() => {
                  setIsLoading(true);
                }}
                onEntered={() => {
                  setIsLoading(false);
                }}
                timeout={300}
                classNames="page"
                unmountOnExit
              >
                {() => (
                  <div
                    ref={nodeRef}
                    className="site-layout-content"
                    style={{ background: 'none' }}
                  >
                    <Outlet />
                  </div>
                )}
              </CSSTransition>
            </SwitchTransition>
          </TransitionGroup>
          <FloatButton.BackTop />
        </Content>
      </Layout>

      {/* Notification Modal */}
      <Modal
        title={
          <div className="notification-header">
            <BellOutlined className="notification-header-icon" />
            <span>Notifications</span>
          </div>
        }
        visible={isModalVisible}
        onCancel={handleCancel}
        footer={null}
        className="notification-modal"
        width={600}
      >
        <Tabs
          defaultActiveKey="1"
          activeKey={activeTab}
          onChange={setActiveTab}
          className="notification-tabs"
        >
          <TabPane
            tab={
              <span className="notification-tab">
                <TrophyOutlined /> Tournament Requests
              </span>
            }
            key="1"
          >
            <TournamentInvitation playerId={user?.id} />
          </TabPane>
          <TabPane
            tab={
              <span className="notification-tab">
                <TeamOutlined /> Friend Requests
              </span>
            }
            key="2"
          >
            <FriendRequest userId={user?.id} />
          </TabPane>
        </Tabs>
      </Modal>

      {/* Mobile Drawer */}
      <Drawer
        title={
          user ? (
            <Flex align="center" className="drawer-header">
              <AntAvatar
                src={
                  user.avatarUrl ??
                  'https://images.icon-icons.com/3446/PNG/512/account_profile_user_avatar_icon_219236.png'
                }
                alt="user profile photo"
                size={48}
                className="drawer-avatar"
              />
              <div className="drawer-user-info">
                <div className="drawer-username">
                  {user?.firstName} {user?.lastName}
                </div>
                <div className="drawer-userlevel">
                  Level {user?.userDetails?.experienceLevel}
                </div>
              </div>
            </Flex>
          ) : (
            'Menu'
          )
        }
        placement="left"
        onClose={onClose}
        open={open}
        className="mobile-drawer"
      >
        <div className="drawer-content">
          {/* Main Navigation */}
          <div className="drawer-section">
            {navigationItems.map((item) => (
              <Link
                key={item.path}
                to={item.path}
                onClick={onClose}
                className={`drawer-item ${
                  isActive(item.path, item.exact) ? 'active' : ''
                }`}
              >
                {item.icon}
                <span>{item.label}</span>
              </Link>
            ))}
          </div>

          {/* User Specific Navigation */}
          {user ? (
            <>
              <div className="drawer-divider" />
              <div className="drawer-section-title">User Menu</div>
              <div className="drawer-section">
                {userMenuItems.map((item) => (
                  <Link
                    key={item.path}
                    to={item.path}
                    onClick={onClose}
                    className={`drawer-item ${
                      isActive(item.path, item.exact) ? 'active' : ''
                    }`}
                  >
                    {item.icon}
                    <span>{item.label}</span>
                  </Link>
                ))}

                {/* Additional user links */}
                <Link
                  to={`profile/${user?.id}`}
                  onClick={onClose}
                  className={`drawer-item ${
                    isActive(`profile/${user?.id}`) ? 'active' : ''
                  }`}
                >
                  <UserOutlined />
                  <span>My Profile</span>
                </Link>

                <Link
                  to="my-tournament"
                  onClick={onClose}
                  className={`drawer-item ${
                    isActive('my-tournament') ? 'active' : ''
                  }`}
                >
                  <TrophyOutlined />
                  <span>Registered Tournaments</span>
                </Link>

                <Link
                  to="my-friend"
                  onClick={onClose}
                  className={`drawer-item ${
                    isActive('my-friend') ? 'active' : ''
                  }`}
                >
                  <TeamOutlined />
                  <span>Friends</span>
                </Link>

                <Link
                  to="match-calendar"
                  onClick={onClose}
                  className={`drawer-item ${
                    isActive('match-calendar') ? 'active' : ''
                  }`}
                >
                  <CalendarOutlined />
                  <span>Matches Calendar</span>
                </Link>

                <Link
                  to="transaction"
                  onClick={onClose}
                  className={`drawer-item ${
                    isActive('match-calendar') ? 'active' : ''
                  }`}
                >
                  <CalendarOutlined />
                  <span>Transaction</span>
                </Link>

                <div
                  className="drawer-item notification-item"
                  onClick={() => {
                    setIsModalVisible(true);
                    onClose();
                  }}
                >
                  <Badge count={countNoti} overflowCount={99}>
                    <BellOutlined />
                  </Badge>
                  <span>Notifications</span>
                </div>

                <div className="drawer-item logout-item" onClick={logout}>
                  <LogoutOutlined />
                  <span>Logout</span>
                </div>
              </div>
            </>
          ) : (
            <>
              <div className="drawer-divider" />
              <div className="drawer-section auth-section">
                <Link
                  to={PATH_AUTH.signin}
                  className="drawer-auth-button login"
                  onClick={onClose}
                >
                  <LoginOutlined />
                  <span>Login</span>
                </Link>

                <Link
                  to={PATH_AUTH.signup}
                  className="drawer-auth-button register"
                  onClick={onClose}
                >
                  <UserAddOutlined />
                  <span>Register</span>
                </Link>
              </div>
            </>
          )}
        </div>
      </Drawer>
    </>
  );
};
