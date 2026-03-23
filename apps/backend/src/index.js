/*
* Created by Connel Asikong on 18/03/2026
*
*/



import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import { rateLimit } from 'express-rate-limit'

import walletRoutes from './routes/wallet.js'
import agentRoutes from './routes/agent.js'
import healthRoutes from './routes/health.js'

const app = express()
const PORT = process.env.PORT || 3000

// ── Security middleware ────────────────────────────────────────────────────────
app.use(helmet())
app.use(cors({
  origin: '*', // tighten in production
  methods: ['GET', 'POST'],
}))
app.use(express.json())

// Rate limiting — prevent abuse
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 60,             // 60 requests per minute per IP
  message: { error: 'Too many requests' },
  legacyHeaders: false,
})
app.use(limiter)

// ── API key middleware ─────────────────────────────────────────────────────────
// Simple shared secret between Flutter app and server
app.use((req, res, next) => {
  // Health endpoint is public
  if (req.path === '/health') return next()

  const key = req.headers['x-api-key']
  if (key !== process.env.API_SECRET) {
    return res.status(401).json({ error: 'Unauthorized' })
  }
  next()
})

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/health', healthRoutes)
app.use('/wallet', walletRoutes)
app.use('/agent', agentRoutes)

// ── 404 fallback ──────────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' })
})

// ── Global error handler ──────────────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error('[DeFAI Server Error]', err.message)
  res.status(err.status || 500).json({ error: err.message || 'Internal server error' })
})

// ── Start ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`
  ██████╗ ███████╗███████╗ █████╗ ██╗
  ██╔══██╗██╔════╝██╔════╝██╔══██╗██║
  ██║  ██║█████╗  █████╗  ███████║██║
  ██║  ██║██╔══╝  ██╔══╝  ██╔══██║██║
  ██████╔╝███████╗██║     ██║  ██║██║
  ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝

  Sentinel Agent Server — v1.0.0
  Running on http://localhost:${PORT}
  Network: ${process.env.WDK_NETWORK || 'testnet'}
  `)
  console.log("DeFAI Server running on http://localhost:${PORT}")
})