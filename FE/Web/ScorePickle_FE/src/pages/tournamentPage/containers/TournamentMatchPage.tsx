import { Spin, Alert, Card, Empty } from 'antd';
import { useGetAllMatchByTournamentId } from '@src/modules/Match/hooks/useGetMatchByTournamentId';
import TournamentMatchCard from './TournamentMatchCard';
import { motion } from 'framer-motion';
import React, { useEffect } from 'react';

interface TournamentInfoProps {
  id: number;
}

export const TournamentMatches: React.FC<TournamentInfoProps> = ({ id }) => {
  const { data: matches, isLoading, error, refetch } = useGetAllMatchByTournamentId(id);

  // Ensure data is refetched if id changes
  useEffect(() => {
    if (id) {
      refetch();
    }
  }, [id, refetch]);

  // Log for debugging
  useEffect(() => {
    console.log("Tournament matches data:", { 
      id, 
      matchesCount: matches?.length || 0,
      isLoading,
      hasError: !!error
    });
  }, [id, matches, isLoading, error]);

  // Animation variants
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.15,
        delayChildren: 0.2
      }
    }
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        type: "spring",
        damping: 12,
        stiffness: 100
      }
    }
  };

  if (isLoading) {
    return (
      <motion.div 
        className="d-flex justify-content-center align-items-center py-5"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5 }}
        key="loading-state"
      >
        <motion.div
          animate={{ 
            rotate: 360,
            transition: { duration: 1.5, repeat: Infinity, ease: "linear" }
          }}
        >
          <Spin size="large" tip="Loading matches..." />
        </motion.div>
      </motion.div>
    );
  }

  if (error) {
    return (
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        key="error-state"
      >
        <Alert 
          message="Error fetching matches" 
          description={error.toString()}
          type="error" 
          showIcon 
        />
      </motion.div>
    );
  }

  if (!matches || matches.length === 0) {
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="py-4"
        key="empty-state"
      >
        <Card className="text-center p-4">
          <Empty
            description={<span>No matches have been scheduled for this tournament yet</span>}
            image={Empty.PRESENTED_IMAGE_SIMPLE}
          />
        </Card>
      </motion.div>
    );
  }

  return (
    <motion.div 
      className="container"
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      key="matches-container"
    >
      <div className="row">
        {matches?.map((match) => (
          <motion.div
            key={match.id}
            className="col-md-6 mb-4"
            variants={itemVariants}
          >
            <TournamentMatchCard value={match} />
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
};

export default TournamentMatches;
