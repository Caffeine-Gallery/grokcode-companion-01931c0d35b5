import { fileURLToPath, URL } from 'url';
import { defineConfig } from 'vite';
import environment from 'vite-plugin-environment';

export default defineConfig({
    logLevel: "error",
    build: {
        emptyOutDir: true,
        sourcemap: true,
    },
    optimizeDeps: {
        esbuildOptions: {
            define: {
                global: "globalThis",
            },
        },
    },
    server: {
        proxy: {
            "/api": {
                target: "http://127.0.0.1:4943",
                changeOrigin: true,
            },
        },
    },
    plugins: [
        environment("all", { prefix: "CANISTER_" }),
        environment("all", { prefix: "DFX_" }),
    ],
    resolve: {
        alias: [
            {
                find: "declarations",
                replacement: fileURLToPath(
                    new URL("../src/declarations", import.meta.url)
                ),
            },
        ],
    },
});