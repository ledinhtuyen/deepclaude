import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone',  // Changed from 'standalone' to 'export'
  images: {
    unoptimized: true, // Required for 'export'
  }
}

export default nextConfig;