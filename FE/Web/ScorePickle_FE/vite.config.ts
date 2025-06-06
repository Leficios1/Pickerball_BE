import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@components': path.resolve(__dirname, 'src/components/'),
      '@src': path.resolve(__dirname, 'src/'),
    },
  },
  base: '/', // <- cái này quan trọng khi deploy lên Vercel
  build: {
    outDir: 'dist',
  },
});
