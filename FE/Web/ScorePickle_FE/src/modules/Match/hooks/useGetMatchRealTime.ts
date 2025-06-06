import { useEffect, useState } from 'react';
import { ref, onValue } from 'firebase/database';
import { database } from '@src/firebase/firebaseConfig';

export type LogEntry = {
  team: number;
  points: number;
  timestamp: string;
};

export type MatchLogs = Record<string, LogEntry[]>; // round_1, round_2, etc.

export function useGetMatchRealTime(matchId: number) {
  const [logs, setLogs] = useState<MatchLogs>({});
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    if (!matchId) {
      console.warn('useGetMatchRealTime: Invalid matchId');
      setLogs({});
      setIsLoading(false);
      return;
    }

    const path = `match_logs/match_${matchId}`;
    const dbRef = ref(database, path);

    const unsubscribe = onValue(
      dbRef,
      (snapshot) => {
        const data = snapshot.val();
        if (!data) {
          setLogs({});
        } else {
          const parsed: MatchLogs = {};
          for (const [roundKey, entries] of Object.entries(data)) {
            parsed[roundKey] = Object.values(
              entries as Record<string, LogEntry>
            );
          }
          setLogs(parsed);
        }
        setIsLoading(false);
        setError(null);
      },
      (error) => {
        console.error('useGetMatchRealTime: Firebase error', error);
        setLogs({});
        setError(error);
        setIsLoading(false);
      }
    );

    return () => unsubscribe();
  }, [matchId]);

  return {
    logs, // toàn bộ logs chia theo round
    isLoading, // trạng thái tải
    error, // nếu có lỗi
  };
}
