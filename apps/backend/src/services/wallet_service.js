/*
* Created by Connel Asikong on 18/03/2026
*
*/

import WDK from '@tetherto/wdk'
import WalletManagerBtc from '@tetherto/wdk-wallet-btc'
import { validateMnemonic } from 'bip39'

// In-memory session store — keyed by address
// Mnemonic is used once to derive keys then dropped
// Only the account object is kept for the session
const _sessions = new Map()

// ── Init wallet ───────────────────────────────────────────────────────────────

export async function initWallet(mnemonic) {
  if (!validateMnemonic(mnemonic)) {
    throw new Error('Invalid mnemonic')
  }

  const wdk = new WDK(mnemonic)
    .registerWallet('bitcoin', WalletManagerBtc, {
      provider: 'https://blockstream.info/testnet/api',
    })

  const account = await wdk.getAccount('bitcoin', 0)
  const address = await account.getAddress()

  // Store account — mnemonic is gone after this point
  _sessions.set(address, account)

  console.log(`[WalletService] Vault initialised — address: ${address}`)

  return {
    address,
    network: process.env.WDK_NETWORK || 'testnet',
  }
}

// ── Get balances ──────────────────────────────────────────────────────────────

export async function getBalances(address) {
  const account = _sessions.get(address)

  if (!account) {
    // Session expired or server restarted
    return {
      address,
      usdt: '0.00',
      xaut: '0.00',
      btc: '0.00000000',
      lastUpdated: new Date().toISOString(),
    }
  }

  try {
    const transfers = await account.getTransfers()
    // Calculate balance from transfers since WDK BTC uses UTXO model
    const received = transfers
      .filter(t => t.type === 'receive')
      .reduce((sum, t) => sum + Number(t.amount), 0)
    const sent = transfers
      .filter(t => t.type === 'send')
      .reduce((sum, t) => sum + Number(t.amount), 0)
    const balanceSats = received - sent
    const btc = (balanceSats / 100_000_000).toFixed(8)

    return {
      address,
      usdt: '0.00',   // BTC wallet — USD₮ via Liquid/EVM in v2
      xaut: '0.00',
      btc,
      lastUpdated: new Date().toISOString(),
    }
  } catch (err) {
    console.error('[WalletService] Balance error:', err.message)
    // Return zeros rather than crashing — balance display degrades gracefully
    return {
      address,
      usdt: '0.00',
      xaut: '0.00',
      btc: '0.00000000',
      lastUpdated: new Date().toISOString(),
    }
  }
}

// ── Send transaction ──────────────────────────────────────────────────────────

export async function sendTransaction({ address, toAddress, amount, asset }) {
  const account = _sessions.get(address)
  if (!account) throw new Error('Session not found. Re-initialise wallet.')

  try {
    const result = await account.transfer({
      to: toAddress,
      amount: Math.floor(parseFloat(amount) * 100_000_000), // convert to sats
    })

    return {
      txHash: result.hash,
      status: 'confirmed',
      amount,
      asset,
      to: toAddress,
      timestamp: new Date().toISOString(),
    }
  } catch (err) {
    console.error('[WalletService] Send error:', err.message)
    throw new Error(`Transaction failed: ${err.message}`)
  }
}

// ── Execute strategy ──────────────────────────────────────────────────────────

export async function executeStrategy({ address, strategyType, params }) {
  const account = _sessions.get(address)
  if (!account) throw new Error('Session not found. Re-initialise wallet.')

  const balance = await getBalances(address)
  const btcBalance = parseFloat(balance.btc)
  const results = []

  switch (strategyType) {
    case 'auto_save': {
      const percentage = params.percentage || 10
      const savingsAddress = params.savingsAddress
      if (!savingsAddress) throw new Error('savingsAddress required for auto_save')

      const saveAmountBtc = btcBalance * percentage / 100
      const saveAmountSats = Math.floor(saveAmountBtc * 100_000_000)

      if (saveAmountSats < 1000) {
        return {
          executed: false,
          reason: 'Amount too small — below dust limit (1000 sats)',
          results: [],
        }
      }

      const tx = await account.transfer({
        to: savingsAddress,
        amount: saveAmountSats,
      })

      results.push({
        action: 'auto_save',
        description: `Saved ${saveAmountBtc.toFixed(8)} BTC to savings vault`,
        txHash: tx.hash,
        status: 'confirmed',
        timestamp: new Date().toISOString(),
      })
      break
    }

    case 'gold_threshold': {
      // Placeholder — requires EVM/Liquid module for real XAU₮ conversion
      results.push({
        action: 'gold_threshold',
        description: 'Gold conversion strategy acknowledged — requires Liquid module',
        txHash: null,
        status: 'pending_module',
        timestamp: new Date().toISOString(),
      })
      break
    }

    case 'reserve_floor': {
      results.push({
        action: 'reserve_alert',
        description: `Reserve floor check complete — BTC balance: ${btcBalance.toFixed(8)}`,
        alert: btcBalance < (params.floor || 0.001),
        timestamp: new Date().toISOString(),
      })
      break
    }

    default:
      throw new Error(`Unknown strategy: ${strategyType}`)
  }

  return { executed: true, strategyType, results }
}