module testDex::swap {
    use std::signer;

    use liquidswap::router_v2;
    use liquidswap::curves::Uncorrelated;
    use test_coins::coins::BTC;

    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;

    public entry fun buy_btc(account: &signer, btc_min_value_to_get: u64, aptos_amount_to_swap: u64) {

        let aptos_coins_to_swap = coin::withdraw<AptosCoin>(account, aptos_amount_to_swap);

        let btc = router_v2::swap_exact_coin_for_coin<AptosCoin, BTC, Uncorrelated>(
            aptos_coins_to_swap,
            btc_min_value_to_get
        );

        let account_addr = signer::address_of(account);

        // Register BTC coin on account in case the account don't have it.
        if (!coin::is_account_registered<BTC>(account_addr)) {
            coin::register<BTC>(account);
        };

        // Deposit on account.
        coin::deposit(account_addr, btc);
    }
}