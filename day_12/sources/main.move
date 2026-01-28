/// DAY 12: Option for Task Lookup
module challenge::day_12 {
    use std::vector;
    use std::string::String;
    use std::option::{Self, Option};

    // Copy from day_11: TaskStatus, Task, TaskBoard

    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    /// Returns Option<u64> (index) if found, None if not found
    public fun find_task_by_title(board: &TaskBoard, title: &String): Option<u64> {
        let len = vector::length(&board.tasks);
        let wanted = *title; // copy String out of &String (String has copy in this challenge)

        let mut i: u64 = 0;
        while (i < len) {
            let t = *vector::borrow(&board.tasks, i); // copy Task out of &Task (Task has copy)
            if (t.title == wanted) {
                return option::some(i);
            };
            i = i + 1;
        };

        option::none()
    }
}
