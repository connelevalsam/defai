/*
* Created by Connel Asikong on 14/03/2026
*
*/

use flutter_rust_bridge::frb;
use wdk_core::{WDK, WalletManagerBtc};

#[frb(sync)]
pub fn init_wallet(mnemonic: String) -> VaultHandle {
    let wdk = WDK::new(&mnemonic);

    drop(mnemonic);

    VaultHandle {
            id: wdk.vault_id(),
            address: wdk.primary_address(),
            network: "liquid".to_string(),
        }
}

#[frb(sync)]
pub fn get_balance(address: String) -> BalanceResult {
    let wdk = WDK::from_address(&address);
    BalanceResult {
        usdt: wdk.balance_usdt(),
        xaut: wdk.balance_xaut(),
    }
}

#[frb(sync)]
pub fn sign_transaction(address: String, tx_hex: String) -> String {
    // Called ONLY after Dart-side biometric gate passes
    let wdk = WDK::from_address(&address);
    wdk.sign(&tx_hex)
}


#[frb]
pub struct VaultHandle {
    pub id: String,
    pub address: String,
    pub network: String,
}

#[frb]
pub struct BalanceResult {
    pub usdt: f64,
    pub xaut: f64,
}