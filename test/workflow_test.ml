open Taskt

let check label condition =
  if not condition then failwith label

(* 작업을 만들거나 map해도 실행되지 않고, run할 때마다 다시 실행된다. *)
let test_task () =
  let executions = ref 0 in
  let task =
    Task.create (fun () ->
      incr executions;
      21)
  in
  let doubled = Task.map (fun value -> value * 2) task in
  check "create/map must not execute the task" (!executions = 0);
  check "map must transform the result" (Task.run doubled = 42);
  check "the original task must execute once" (!executions = 1);
  check "a task can execute again" (Task.run doubled = 42);
  check "results are not cached" (!executions = 2)

(* 첫 Agent의 출력을 두 번째 Agent의 입력으로 전달한다. *)
let test_agent_workflow () =
  let events = ref [] in
  let normalize =
    Agent.create (fun input ->
      Task.create (fun () ->
        events := !events @ [ "normalize" ];
        String.trim input))
  in
  let measure =
    Agent.create (fun input ->
      Task.create (fun () ->
        events := !events @ [ "measure" ];
        String.length input))
  in
  let workflow =
    Agent.apply normalize "  hello  "
    |> Task.bind (Agent.apply measure)
  in
  check "building the workflow must not execute its tasks" (!events = []);
  let result = Task.run workflow in
  check "the second agent must receive the first agent's output" (result = 5);
  check "agents must execute in order"
    (!events = [ "normalize"; "measure" ]);
  Printf.printf "Agent workflow: trim -> length = %d\n" result

let test_agent_run () =
  let executions = ref 0 in
  let double =
    Agent.create (fun input ->
      Task.create (fun () ->
        incr executions;
        input * 2))
  in
  check "Agent.run must return the result" (Agent.run double 21 = 42);
  check "Agent.run must execute the task once" (!executions = 1)

let () =
  test_task ();
  test_agent_workflow ();
  test_agent_run ();
  print_endline "All Task/Agent tests passed."
