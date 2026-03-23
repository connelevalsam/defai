/*
* Created by Connel Asikong on 18/03/2026
*
*/

import { Router } from 'express'
const router = Router()

router.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'DeFAI Sentinel Server',
    version: '1.0.0',
    network: process.env.WDK_NETWORK || 'testnet',
    timestamp: new Date().toISOString(),
  })
})

export default router