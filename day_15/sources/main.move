module challenge::day_15 {
    use std::vector;

    /// -----------------------------
    /// Constants (error codes)
    /// -----------------------------
    const MAX_PLOTS: u64 = 20;

    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    /// -----------------------------
    /// Struct
    /// -----------------------------
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    /// -----------------------------
    /// Constructor
    /// -----------------------------
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty<u8>(),
        }
    }

    /// -----------------------------
    /// Plant
    /// -----------------------------
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // plot_id basic validation
        assert!(plot_id > 0, E_INVALID_PLOT_ID);

        // max plot limit
        assert!(
            vector::length(&counters.plots) < MAX_PLOTS,
            E_PLOT_LIMIT_EXCEEDED
        );

        // prevent duplicates
        let mut i = 0;
        let len = vector::length(&counters.plots);
        while (i < len) {
            let existing = *vector::borrow(&counters.plots, i);
            assert!(existing != plot_id, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };

        vector::push_back(&mut counters.plots, plot_id);
        counters.planted = counters.planted + 1;
    }

    /// -----------------------------
    /// Harvest
    /// -----------------------------
    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let mut i = 0;
        let len = vector::length(&counters.plots);
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
}
