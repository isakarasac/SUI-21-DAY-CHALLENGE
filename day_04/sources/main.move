/// DAY 4: Vector + Ownership Basics

module challenge::day_04 {

    use std::vector;

    // Copy the Habit struct from day 03
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    /// A list of habits (vector can't be copied, so only drop)
    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    /// Returns an empty HabitList
    public fun empty_list(): HabitList {
        HabitList { habits: vector::empty<Habit>() }
    }

    /// Adds a habit into the list (ownership moves into the vector)
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }
}
