/// DAY 8: New Module & Simple Task Struct

module challenge::day_08 {
    use std::string::String;

    /// Task struct
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        done: bool,
    }

    /// Constructor: done = false
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            done: false,
        }
    }
}
