/*
* Created by Connel Asikong on 18/03/2026
*
*/

import { Router } from 'express'
import * as walletService from '../services/wallet_service.js'
const router = Router()

/**
 * POST /agent/execute
 * Executes a Sentinel strategy onchain.
 * This endpoint is the bridge between Flutter's agent_provider
 * and real WDK transactions.
 *
 * Called ONLY after the Sovereign Handshake (biometric) passes in Flutter.
 *
 * Body: {
 *   address: string,         — vault address
 *   strategyType: string,    — 'auto_save' | 'gold_threshold' | 'reserve_floor'
 *   params: object           — strategy-specific parameters
 * }
 *
 * Response: {
 *   executed: boolean,
 *   strategyType: string,
 *   results: Array<{ action, description, txHash, status, timestamp }>
 * }
 */
router.post('/execute', async (req, res) => {
  const { address, strategyType, params } = req.body

  if (!address || !strategyType) {
    return res.status(400).json({
      error: 'address and strategyType are required',
    })
  }

  try {
    const result = await walletService.executeStrategy({
      address,
      strategyType,
      params: params || {},
    })
    res.json(result)
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
})

/**
 * POST /agent/reason
 * Returns the reasoning steps for a given strategy command.
 * Purely logic — no onchain action.
 * Used by Flutter's Reasoning Board to show the plan before execution.
 *
 * Body: { command: string }
 * Response: { steps: string[], strategyType: string, params: object }
 */
router.post('/reason', async (req, res) => {
  const { command } = req.body

  if (!command) {
    return res.status(400).json({ error: 'command is required' })
  }

  const lower = command.toLowerCase()
  let strategyType = 'unknown'
  let steps = []
  let params = {}

  if (lower.includes('save') || lower.includes('saving')) {
    const percentMatch = command.match(/(\d+)%/)
    const percentage = percentMatch ? parseInt(percentMatch[1]) : 10

    strategyType = 'auto_save'
    params = { percentage }
    steps = [
      `Check USD₮ balance in WDK Vault`,
      `Calculate ${percentage}% savings amount`,
      `Verify no pending transactions`,
      `Prepare self-custodial USD₮ transfer`,
    ]
  } else if (lower.includes('gold') || lower.includes('xau')) {
    const thresholdMatch = command.match(/(\d[\d,]*)\s*(usd|usdt)?/i)
    const threshold = thresholdMatch
      ? parseInt(thresholdMatch[1].replace(',', ''))
      : 1000

    strategyType = 'gold_threshold'
    params = { threshold }
    steps = [
      `Fetch XAU₮/USD₮ rate from Tether Oracle`,
      `Check current USD₮ balance vs ${threshold} threshold`,
      `Calculate excess amount for conversion`,
      `Prepare XAU₮ conversion transaction`,
    ]
  } else if (lower.includes('reserve') || lower.includes('keep') || lower.includes('minimum')) {
    const amountMatch = command.match(/(\d[\d,]*)\s*(usd|usdt)?/i)
    const floor = amountMatch
      ? parseInt(amountMatch[1].replace(',', ''))
      : 500

    strategyType = 'reserve_floor'
    params = { floor }
    steps = [
      `Check current USD₮ balance`,
      `Compare against ${floor} USD₮ reserve floor`,
      `Evaluate if protective action required`,
      `Prepare reserve maintenance strategy`,
    ]
  } else {
    steps = [
      `Analyse command intent`,
      `Identify relevant assets`,
      `Build execution strategy`,
      `Prepare transaction payload`,
    ]
  }

  res.json({ steps, strategyType, params })
})

export default router;