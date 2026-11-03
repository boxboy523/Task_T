# `Task<T>`

> Typed zero-trust runtime for agentic workflows.

[Website / design preview](https://task-t-agent.netlify.app/?utm=github)

**Work in progress.**

LLM agents are useful, but they are not trusted execution environments.

Hallucinations, prompt injection, and cloud model privacy make it dangerous to give an agent unrestricted access to data and effects.

Task<T> explores a different approach:

**Models are functions. Workflows are programs. Permissions are enforced by types.**

## Idea

Agent workflows are expressed as typed computations and compiled into an explicit execution graph.

```scala
val analysis =
  localReasoner(repo)

val patch =
  coder(analysis)

val result =
  runTests(patch)
```

LLMs perform probabilistic reasoning, while deterministic runtime rules control information flow and side effects.

## Core types

```scala
Task[T]
```

A lazy computation that produces `T` when executed.

```scala
Agent[D, I, O]
```

A computation from `I` to `O` running inside an execution domain `D`.

Domains may describe properties such as:

```text
Cloud / Local
Networked / Sandboxed
Probabilistic / Deterministic
```

```scala
Effect[E, T]
```

A computation that performs effect `E` and produces `T`.

```scala
Secure[L, T]
```

Data protected by a security level.

```text
Public < Private < Secret
```

Security levels may only flow upward implicitly.

```scala
Trusted[T]
Untrusted[T]
```

Whether data is trusted enough to be consumed by ordinary agents.

`Trusted[T]` does not mean that every statement inside `T` is objectively true. It means the data passed the workflow's trust policy and is considered free from obvious malicious manipulation, prompt injection, or intentionally misleading input.

## Zero-trust by construction

```scala
val repo:
  Secure[Secret, Trusted[Repo]] =
    workspace.repo

cloudAgent(repo)
```

```text
Type error:
Secret data cannot flow into a Cloud execution domain.
```

External data can also remain untrusted until explicitly verified.

```scala
val page:
  Untrusted[WebPage] =
    readWeb(url)

agent(page)
```

```text
Type error:
Agent requires Trusted input.
```

## Effects are explicit

LLMs do not directly mutate the environment.

```scala
generatePatch :
  Analysis
  -> Task[Candidate[Patch]]

verify :
  Candidate[Patch]
  -> Task[Verified[Patch]]

applyPatch :
  Verified[Patch]
  -> Task[Effect[FileWrite, RepoState]]
```

Reasoning may be probabilistic.

Effects are not.

## Execution graph

A workflow is executed as a typed graph rather than an opaque sequence of agent messages.

```text
Issue + Repo
    │
    ▼
 Analyze
    │
    ├──▶ Local Coder ──┐
    │                  │
    └──▶ Cloud Coder ──┤
                       ▼
                    Verify
                       │
                       ▼
                 Apply + Test
```

This makes parallel execution, retries, model replacement, isolated Git worktrees, replay, and policy enforcement explicit runtime operations.

## Status

Currently in the design / prototype stage.

The initial focus is:

- Scala 3 embedded DSL
- typed task graph
- local and OpenAI-compatible model backends
- explicit security and trust boundaries
- effect-controlled execution
- parallel agent workflows
- Git worktree isolation
- execution graph inspection

The type system and runtime model are still experimental.
