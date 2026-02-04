module challenge::day_17 {
    use std::vector;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // -------------------------
    // Counters
    // -------------------------
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty<u8>(),
        }
    }

    fun plant(counters: &mut FarmCounters, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);

        let mut i = 0;
        let len = vector::length(&counters.plots);
        while (i < len) {
            assert!(
                *vector::borrow(&counters.plots, i) != plot_id,
                E_PLOT_ALREADY_EXISTS
            );
            i = i + 1;
        };

        vector::push_back(&mut counters.plots, plot_id);
        counters.planted = counters.planted + 1;
    }

    fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let len = vector::length(&counters.plots);
        let mut i = 0;
        let mut found = false;

        while (i < len) {
            if (*vector::borrow(&counters.plots, i) == plot_id) {
                vector::swap_remove(&mut counters.plots, i);
                found = true;
                break;
            };
            i = i + 1;
        };

        assert!(found, E_PLOT_NOT_FOUND);
        counters.harvested = counters.harvested + 1;
    }

    // -------------------------
    // Farm object (ownership)
    // -------------------------
    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    // -------------------------
    // ENTRY FUNCTIONS
    // -------------------------
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::transfer(farm, tx_context::sender(ctx));
    }

    public entry fun plant_on_farm(
        farm: &mut Farm,
        plot_id: u8
    ) {
        plant(&mut farm.counters, plot_id);
    }

    public entry fun harvest_from_farm(
        farm: &mut Farm,
        plot_id: u8
    ) {
        harvest(&mut farm.counters, plot_id);
    }
}
