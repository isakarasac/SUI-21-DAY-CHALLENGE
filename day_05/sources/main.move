/// DAY 5: Control Flow & Mark Habit as Done

module challenge::day_05 {
    use std::vector;

    // Copy from day 04
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty<Habit>(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    // TODO: Mark habit as completed if index is valid
    public fun complete_habit(list: &mut HabitList, index: u64) {
        let length = vector::length(&list.habits);
        if (index < length) {
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            habit_ref.completed = true;
        }
    }
}
