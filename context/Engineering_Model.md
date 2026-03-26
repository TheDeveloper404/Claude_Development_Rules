# Engineering Model

This document defines how all documents and agents in the system must be used together.

Its purpose is not to introduce new rules, but to eliminate confusion and rigidity. Your system is already very strong in terms of engineering principles, security, and structure. The real problem is not the lack of rules, but how they are applied.

This document solves exactly that: it defines how Claude should think and act so that it works like a real engineering team, not like a rigid rule executor.

---

## 1. How the system should be understood

The system is not a collection of files. It is a simulation of a software engineering team.

There are different roles (frontend, backend, devops, etc.), global standards (engineering, security, CI/CD), and concrete requirements (tasks, features). All of these must work together, but not in the same way for every situation.

Claude should not apply all rules at once. It must decide what is relevant for the current context.

---

## 2. The problem this solves

Without a clear operating model, two extremes appear:

The first is overengineering. A full process is applied to every task, no matter how small. All agents are activated, formal architecture is created, and full audits are performed for trivial changes.

The second is under-engineering. Important rules are ignored in sensitive areas (auth, payments, security) because there is no clear distinction between types of tasks.

Both are incorrect.

---

## 3. Core principle

Not all tasks require the same level of rigor.

This is the principle that governs the entire system.

Claude must decide every time:
- how complex the task is
- how high the risk is
- what impact it has on the system

Based on these, the process is adapted.

---

## 4. Task classification

Every task must be placed into one of the following categories.

### Small task

A localized, clearly defined change with low risk. Examples include UI changes, minor bug fixes, or limited refactors.

In this case, formal architecture and full team involvement are not necessary. The work is implemented directly, verified, and reviewed lightly.

---

### Normal feature

A real product feature without critical impact on security or infrastructure. Examples include CRUD operations, new pages, or standard API integrations.

Here, proper structure is required: clear layering, well-defined logic, and relevant testing. Architecture is involved (even if not heavily formalized), along with backend, frontend, and proper review.

---

### Critical feature

Any work that affects security, sensitive data, authentication, payments, roles, or infrastructure.

In this case, no simplification is allowed. A full process is required: clear design, security audit, extended testing, and strict validation before delivery.

---

## 5. How Claude uses the documents

Documents are not equal and should not all be read every time.

There is a logical order:

First, define context and working mode (through `CLAUDE.md` and this document). Then apply global standards (engineering principles and security). After that, use only the agents relevant to the task. Finally, apply task-specific requirements.

Very important: the presence of a file in the project does not mean it is relevant for the current task.

---

## 6. Role of each type of document

Engineering principles define how correct code is written: structure, separation of concerns, naming, and testing. They do not define workflow.

The security checklist defines all security rules. It is the single source of truth for this domain and must not be duplicated or reinterpreted elsewhere.

CI/CD defines how code reaches production. It is only relevant when the task involves deployment, infrastructure, or release flow.

Agents define how each role operates. Not all agents are active at the same time.

This document defines how all of these are used together.

---

## 7. Agent activation

Claude must not activate all agents for every task.

It must select only the roles relevant to the situation.

For a small task, a developer (frontend or backend) and a light review are sufficient.

For a normal feature, architecture, full implementation, and testing are involved.

For a critical feature, security, full QA, and possibly DevOps are also required.

This is the difference between an efficient system and a rigid one.

---

## 8. Important rules

Do not apply complex processes to simple tasks. It wastes time and introduces unnecessary friction.

Do not ignore security in sensitive areas. There are no compromises there.

Do not mix responsibilities. The frontend does not handle security decisions, the backend should not contain presentation logic, and infrastructure must not be treated superficially.

Do not duplicate rules across multiple documents. If a document is authoritative, it must be respected.

---

## 9. Real workflow

For any task, the correct process is simple:

Understand the task. Classify it (small, normal, or critical). Choose the necessary roles. Implement according to the relevant standards. Validate based on risk. Deliver.

Nothing more is needed.

---

## 10. Golden rule

Do what is necessary, no more.

---

## 11. Conclusion

Your system is already very strong from a technical perspective. It has solid principles, well-defined security, and clear roles.

The problem was not the system itself, but how it is used.

This document does not change the system. It makes it usable in real-world scenarios.

---

## 12. Final sentence

Claude must work like a real engineering team: adaptive, responsible, and pragmatic.