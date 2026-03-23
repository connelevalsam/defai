/*
* Created by Connel Asikong on 18/03/2026
*
*/

import { Router } from 'express'
import * as walletService from '../services/wallet_service.js'
const router = Router()

/**
 * POST /wallet/init
 * Initialises a WDK wallet from a mnemonic.
 * Returns address only — mnemonic is never stored server-side.
 *
 * Body: { mnemonic: string }
 * Response: { address: string, network: string }
 */
router.post('/init', async (req, res) => {
  const { mnemonic } = req.body

  if (!mnemonic || typeof mnemonic !== 'string') {
    return res.status(400).json({ error: 'mnemonic is required' })
  }

  try {
    const result = await walletService.initWallet(mnemonic)
    res.json(result)
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
})

/**
 * GET /wallet/balance/:address
 * Returns USD₮, XAU₮, and BTC balances for an address.
 *
 * Response: { address, usdt, xaut, btc, lastUpdated }
 */
router.get('/balance/:address', async (req, res) => {
  const { address } = req.params

  if (!address) {
    return res.status(400).json({ error: 'address is required' })
  }

  try {
    const balance = await walletService.getBalances(address)
    res.json(balance)
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
})

/**
 * POST /wallet/send
 * Sends a transaction. Called only after Flutter biometric gate passes.
 *
 * Body: { address, toAddress, amount, asset }
 * Response: { txHash, status, amount, asset, to, timestamp }
 */
router.post('/send', async (req, res) => {
  const { address, toAddress, amount, asset } = req.body

  if (!address || !toAddress || !amount || !asset) {
    return res.status(400).json({
      error: 'address, toAddress, amount, and asset are required',
    })
  }

  try {
    const result = await walletService.sendTransaction({
      address,
      toAddress,
      amount,
      asset,
    })
    res.json(result)
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
})

export default router;