module challenge::day_18 {
    use std::vector;

    use sui::object;
    use sui::transfer;
    use sui::tx_context::TxContext;

    const MAX_PLOTS: u64 = 20;

    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: object::UID,
        counters: FarmCounters,
    }

    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    fun plant(counters: &mut FarmCounters, plot_id: u8) {
        assert!(plot_id >= 1 && plot_id <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);

        let len = vector::length(&counters.plots);
        assert!(len < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);

        let mut i: u64 = 0;
        while (i < len) {
            let p = *vector::borrow(&counters.plots, i);
            assert!(p != plot_id, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };

        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plot_id);
    }

    fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let len = vector::length(&counters.plots);

        let mut i: u64 = 0;
        let mut found: u64 = len;

        while (i < len) {
            if (*vector::borrow(&counters.plots, i) == plot_id) {
                found = i;
            };
            i = i + 1;
        };

        assert!(found < len, E_PLOT_NOT_FOUND);

        vector::remove(&mut counters.plots, found);
        counters.harvested = counters.harvested + 1;
    }

    entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    entry fun plant_on_farm_entry(farm: Farm, plot_id: u8, _ctx: &mut TxContext) {
        let mut farm_mut = farm;
        plant(&mut farm_mut.counters, plot_id);
        transfer::share_object(farm_mut);
    }

    entry fun harvest_from_farm_entry(farm: Farm, plot_id: u8, _ctx: &mut TxContext) {
        let mut farm_mut = farm;
        harvest(&mut farm_mut.counters, plot_id);
        transfer::share_object(farm_mut);
    }
}
