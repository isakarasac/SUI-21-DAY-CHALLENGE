/// DAY 6: String Type for Habit Names

module challenge::day_06 {
    use std::vector;
    use std::string::{Self, String};

    /// Habit now uses String instead of vector<u8>
    public struct Habit has drop {
        name: String,
        completed: bool,
    }

    /// Updated constructor: accepts String
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    /// Same as before
    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty<Habit>(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let len = vector::length(&list.habits);
        if (index < len) {
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            habit_ref.completed = true;
        }
    }

    /// Helper: takes bytes, converts to String, returns a Habit
    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name = string::utf8(name_bytes);
        new_habit(name)
    }
}
