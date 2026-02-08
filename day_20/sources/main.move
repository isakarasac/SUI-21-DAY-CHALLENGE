module challenge::farm {

    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use std::vector;

    const E_PLOT_EXISTS: u64 = 0;
    const E_PLOT_NOT_FOUND: u64 = 1;

    public struct FarmCounters has copy, drop, store {
        plots: vector<u64>,
        total: u64
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters
    }

    fun new_counters(): FarmCounters {
        FarmCounters {
            plots: vector::empty<u64>(),
            total: 0
        }
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters()
        }
    }

    entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    public entry fun plant(farm: &mut Farm, plot_id: u64) {
        let len = vector::length(&farm.counters.plots);
        let mut i = 0;

        while (i < len) {
            let p = *vector::borrow(&farm.counters.plots, i);
            assert!(p != plot_id, E_PLOT_EXISTS);
            i = i + 1;
        };

        vector::push_back(&mut farm.counters.plots, plot_id);
    }

    public entry fun harvest(farm: &mut Farm, plot_id: u64) {
        let len = vector::length(&farm.counters.plots);
        let mut i = 0;
        let mut found = len;

        while (i < len) {
            let p = *vector::borrow(&farm.counters.plots, i);
            if (p == plot_id) {
                found = i;
            };
            i = i + 1;
        };

        assert!(found < len, E_PLOT_NOT_FOUND);
        vector::remove(&mut farm.counters.plots, found);
        farm.counters.total = farm.counters.total + 1;
    }

    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.total
    }
}
