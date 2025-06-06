import { useEffect, useRef, useState } from 'react';
import * as signalR from '@microsoft/signalr';

export interface MatchRequest {
  userId: number;
  gender: string;
  city: string;
  ranking: number;
  matchFormat: number;
}

export function useMatchHub(onEvents?: {
  onMatchFound?: (rival: any) => void;
  onRoomCreated?: (roomId: number) => void;
  onRoomCreationFailed?: (error: string) => void;
  onWaiting?: () => void;
  onScoreConfirmed?: () => void;
  onPlayerConfirmed?: (userId: number) => void;
}) {
  const connectionRef = useRef<signalR.HubConnection | null>(null);
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    const connection = new signalR.HubConnectionBuilder()
      .withUrl(
        'https://pickleballcapton-hvgvf6h4eqbudcbw.eastasia-01.azurewebsites.net/matchHub'
      )
      .withAutomaticReconnect()
      .configureLogging(signalR.LogLevel.Information)
      .build();

    connectionRef.current = connection;

    connection
      .start()
      .then(() => {
        console.log('✅ Connected to MatchHub');
        setIsConnected(true);

        connection.on('MatchFound', ({ Rival }) => {
          console.log('🎯 MatchFound:', Rival);
          onEvents?.onMatchFound?.(Rival);
        });

        connection.on('RoomCreated', (roomId) => {
          console.log('✅ RoomCreated:', roomId);
          onEvents?.onRoomCreated?.(roomId);
        });

        connection.on('RoomCreationFailed', (error) => {
          console.error('❌ RoomCreationFailed:', error);
          onEvents?.onRoomCreationFailed?.(error);
        });

        connection.on('WaitingForMatch', () => {
          console.log('⏳ WaitingForMatch...');
          onEvents?.onWaiting?.();
        });

        connection.on('PlayerConfirmed', (userId) => {
          onEvents?.onPlayerConfirmed?.(userId);
        });

        connection.on('ScoreConfirmed', (message) => {
          console.log('✅ ScoreConfirmed:', message);
          onEvents?.onScoreConfirmed?.();
        });
      })
      .catch((err) => {
        console.error('❌ SignalR connection error:', err);
      });

    return () => {
      connection
        .stop()
        .then(() => console.log('🛑 Disconnected from MatchHub'));
    };
  }, []);

  const findMatch = (request: MatchRequest) => {
    if (!connectionRef.current || connectionRef.current.state !== 'Connected')
      return;
    connectionRef.current.invoke('FindMatch', request);
  };

  const confirmScore = (matchId: number, userId: number) => {
    if (!connectionRef.current || connectionRef.current.state !== 'Connected')
      return;
    connectionRef.current.invoke('ConfirmScore', matchId, userId);
  };

  return {
    isConnected,
    findMatch,
    confirmScore,
  };
}
