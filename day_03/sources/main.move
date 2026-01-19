/// DAY 3: Structs (Habit Model Skeleton)

module challenge::day_03 {

    use std::vector;

    /// A simple Habit struct
    /// - name: vector<u8>
    /// - completed: bool
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    /// Constructor function
    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }
}
