
# DeFAI — Sovereign Finance Agent

> *Your money should work while you think.*

DeFAI is a self-custodial mobile AI agent shell built for the **Tether Hackathon Galáctica: WDK Edition 1**.

Sentinel agents reason transparently through a **Reasoning Board**, then execute onchain strategies only after a **Sovereign Handshake** — your biometric approval. No custody leaks. No silent transactions.

---

## Architecture

```
┌─────────────────────────────────┐
│     Flutter App (app/)          │
│  Reasoning Board · Sentinel UI  │
│  Sovereign Handshake (biometric)│
└──────────────┬──────────────────┘
               │ HTTP
┌──────────────▼──────────────────┐
│   Node.js Server (server/)      │
│   WDK wallet · Strategy engine  │
│   Balance · Send · Execute      │
└──────────────┬──────────────────┘
               │ WDK
┌──────────────▼──────────────────┐
│      Tether Network             │
│  USD₮ · XAU₮ · Liquid L2       │
└─────────────────────────────────┘
```

---

## Repo Structure

```
defai/
├── app/        Flutter mobile app
├── server/     Node.js + WDK backend
└── README.md
```

---

## Running Locally

### 1. Start the server

```bash
cd server
npm install
cp .env.example .env   # edit API_SECRET
npm run dev
```

Server runs at `http://localhost:3000`

### 2. Run the Flutter app

```bash
cd app
flutter pub get
flutter run
```

Make sure your device and server are on the same network for local mode.

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Server status |
| `POST` | `/wallet/init` | Initialise WDK wallet from mnemonic |
| `GET` | `/wallet/balance/:address` | Fetch USD₮ + XAU₮ balances |
| `POST` | `/agent/reason` | Get reasoning steps for a command |
| `POST` | `/agent/execute` | Execute strategy onchain (post-biometric) |

---

## Key Technical Pillars

**Self-Custodial Core** — WDK handles wallet initialisation and onchain settlement. The server never stores mnemonics. Keys live on the device.

**Reasoning Transparency** — The Reasoning Board visualises every step of the agent's decision process before execution fires. Judges and users can see exactly what Sentinel is planning.

**Sovereign Handshake** — Every transaction requires biometric approval from the device owner. The execute endpoint is called only after `local_auth` passes in Flutter.

**Layer 2 Native** — Optimised for USD₮ and XAU₮ settlement on Liquid Network.

---

## Strategies

| Strategy | Trigger | Action |
|----------|---------|--------|
| `auto_save` | Any time | Moves X% of balance to savings address |
| `gold_threshold` | Balance > threshold | Converts excess USD₮ to XAU₮ |
| `reserve_floor` | Balance < floor | Alerts + protective action |

---

## Built With

- **Flutter** — cross-platform mobile UI
- **Riverpod** — reactive state management
- **Node.js + Express** — WDK backend server
- **Tether WDK** — `@tetherto/wdk` + `@tetherto/wdk-wallet-btc`
- **flutter_animate** — UI animations
- **local_auth** — biometric Sovereign Handshake

---

## Hackathon

Built for **Hackathon Galáctica: WDK Edition 1** by Tether  
Submission deadline: March 22, 2026