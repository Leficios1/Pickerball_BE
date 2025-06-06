import { useState, useEffect, useCallback } from 'react';
import { getDatabase, ref, set, update, onValue, get } from 'firebase/database';

export interface Match {
  submissions: {
    team1score: number;
    team2score: number;
  };
  accepted_1: boolean;
  accepted_2: boolean;
  isSend: boolean;
  note?: string;
}

export const useMatchSubmission = (matchId: string) => {
  const db = getDatabase();
  const matchRef = ref(db, `/competitive/${matchId}`);
  const [match, setMatch] = useState<Match | null>(null);

  // Theo dõi dữ liệu realtime từ Firebase
  useEffect(() => {
    const unsubscribe = onValue(matchRef, (snapshot) => {
      if (snapshot.exists()) {
        setMatch(snapshot.val());
      }
    });
    return () => unsubscribe();
  }, [matchId]);

  /**
   * Tạo bản ghi mẫu nếu chưa tồn tại
   */
  const createDefaultRecord = useCallback(async () => {
    const snapshot = await get(matchRef);
    if (!snapshot.exists()) {
      await set(matchRef, {
        submissions: {
          team1score: 0,
          team2score: 0,
        },
        accepted_1: false,
        accepted_2: false,
        isSend: false,
        note: '',
      });
    }
  }, [matchRef]);

  /**
   * Nhập hoặc cập nhật điểm cho trận đấu
   * - Chỉ room owner có quyền gọi
   * - Sau khi nhập sẽ bật isSend = true để các player khác thấy và xác nhận
   */
  const submitScore = useCallback(
    async (team1score: number, team2score: number) => {
      const updates: Partial<Match> = {
        submissions: { team1score, team2score },
        isSend: true,
      };
      await update(matchRef, updates);
    },
    [matchRef]
  );

  /**
   * Cho phép Team 1 hoặc Team 2 xác nhận kết quả
   */
  const acceptScore = useCallback(
    async (team: 'Team 1' | 'Team 2') => {
      const field = team === 'Team 1' ? 'accepted_1' : 'accepted_2';
      await update(matchRef, { [field]: true });
    },
    [matchRef]
  );

  /**
   * Cập nhật ghi chú (log) của trận đấu
   */
  const updateNote = useCallback(
    async (note: string) => {
      await update(matchRef, { note });
    },
    [matchRef]
  );

  /**
   * Reset lại xác nhận & điểm số (phòng trường hợp cần làm lại)
   */
  const resetMatch = useCallback(async () => {
    await update(matchRef, {
      submissions: {
        team1score: 0,
        team2score: 0,
      },
      accepted_1: false,
      accepted_2: false,
      isSend: false,
      note: '',
    });
  }, [matchRef]);

  return {
    match,
    createDefaultRecord,
    submitScore,
    acceptScore,
    updateNote,
    resetMatch,
  };
};
