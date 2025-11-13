// client/vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      // Bất kỳ yêu cầu nào bắt đầu bằng /api
      // sẽ được chuyển tiếp đến server backend
      '/api': {
        target: 'http://localhost:5000', // <-- ĐÂY LÀ PORT CỦA SERVER NODE.JS
        changeOrigin: true,
        secure: false,
      },
    },
  },
})