module challenge::day_13 {

    use std::vector;
    use std::string::String;
    use std::option::{Self, Option};

    /**************
     *  ENUMS
     **************/
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    /**************
     *  STRUCTS
     **************/
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    /**************
     *  CONSTRUCTORS
     **************/
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

    /**************
     *  MUTATIONS
     **************/
    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    /**************
     *  LOOKUP (from Day 12)
     **************/
    public fun find_task_by_title(
        board: &TaskBoard,
        title: &String
    ): Option<u64> {
        let len = vector::length(&board.tasks);
        let mut i = 0;

        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            if (&t.title == title) {
                return option::some(i);
            };
            i = i + 1;
        };

        option::none()
    }

    /**************
     *  DAY 13 – AGGREGATIONS
     **************/
    public fun total_reward(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        let mut total = 0;

        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            total = total + t.reward;
            i = i + 1;
        };

        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        let mut count = 0;

        while (i < len) {
            let t = vector::borrow(&board.tasks, i);
            if (t.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };

        count
    }
}
