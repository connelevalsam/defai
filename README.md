
# DEFAI | Sovereign AI Agent Shell

DEFAI is a premium mobile experience designed for the Tether "AI Agents for Onchain Finance" Hackathon. It bridges the gap between **Autonomous AI** and **Self-Custody**.

## The Vision
Defai follows the principles of **Deep Work**: building a non-mediocre, sovereign tool that addresses the niche need for mobile-first, autonomous financial agents.

## Tech Stack
- **Framework:** Flutter (3.x)
- **State Management:** Riverpod 3.0 (AsyncNotifier & Code Gen)
- **Navigation:** GoRouter (StatefulShellRoute for persistent agent monitoring)
- **Blockchain:** Tether WDK (Wallet Development Kit)
- **Agent Logic:** OpenClaw Integration
- **Animations:** flutter_animate & Shimmer
- **Security:** Native local_auth (Biometric Enclave)

## Architecture
Defai uses a "Modular Brain" architecture:
1. **The Pulse:** A background Notifier that manages the Agent's "Thought Stream."
2. **The Vault:** A WDK-powered layer that keeps private keys in the device's secure enclave.
3. **The Reasoning Board:** A UI component that breaks down natural language prompts into executable onchain logic.

## Features
- **Neon-Sovereign UI:** A custom theme designed for high-contrast visibility and a premium feel.
- **Biometric Handshake:** Every autonomous action requires a native OS biometric scan, ensuring the agent is always under user control.
- **Strategy Visualization:** Watch your agent "think" through market conditions in real-time.

## Getting Started
1. Clone the repo.
2. Ensure you have the Flutter 2026 stable SDK.
3. Run `dart run build_runner build` to generate the Riverpod providers.
4. Launch on iOS or Android.

---
Built for the Tether x DoraHacks 2026.