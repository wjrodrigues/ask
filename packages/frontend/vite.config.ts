/// <reference types="vitest" />

import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  test: {
    watch: false,
    globals: true,
    environment: "happy-dom",
    reporters: ["verbose"],
    include: ["**/*.spec.*", "**/*.test.*"],
    exclude: ["**/node_modules/**", "**/__snapshots__/**"],
    coverage: {
      provider: "istanbul",
      enabled: true,
      reporter: ["text", "lcov"],
      reportsDirectory: "coverage",
      include: ["**/*.vue", "**/*.js", "**/*.ts*"],
      branches: 70,
      functions: 80,
      lines: 80,
    },
    setupFiles: "vitest.setup.ts",
    deps: {
      inline: ["vuetify"],
    },
  },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
});
