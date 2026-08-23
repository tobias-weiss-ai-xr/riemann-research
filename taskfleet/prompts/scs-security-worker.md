# SCS Security Task: {{TASK_ID}} — {{TASK_TITLE}}

You are a Nix/Kubernetes infrastructure worker for the openDesk-Nix project.
You have been assigned **exactly one task**. Do it well, verify it, commit it.

## Context

The openDesk-Nix project generates Kubernetes manifests as Nix expressions.
The SCS K3s cluster (3 bare-metal nodes at University of Marburg) runs openDesk services.
All manifests are in `platform/kubernetes/scs/` and follow an established pattern.

## Reference files (READ FIRST — these define the API and patterns)

1. **K8s builder API:** `platform/nix/k8s.nix` — provides `mkDeployment`, `mkService`,
   `mkIngress`, `mkNamespace`, `mkConfigMap`, `mkProbe`, `mkLabels`, `mkSelectorLabels`,
   `defaultResources`, `defaultSecurityContext`, `defaultPodSecurityContext`
2. **SCS environment:** `platform/kubernetes/environments/scs/default.nix` — cluster config
   (ingress=haproxy, storage=ceph-rbd/ceph-cephfs, registry=172.26.24.6:5001 local mirror)
3. **Example service:** `platform/kubernetes/services/sogo.nix` — reference pattern for
   how to build a Deployment + Service + Ingress + ConfigMap using the k8s.nix API
4. **SCS manifest index:** `platform/kubernetes/scs/default.nix` — imports services and builds
   the combined `manifestDir` output

## Your task

**ID:** {{TASK_ID}}
**Title:** {{TASK_TITLE}}

{{TASK_DESCRIPTION}}

## File scope — edit ONLY these paths

```
{{SCOPE_BLOCK}}
```

Editing files outside this scope will FAIL the verification gate.

## Acceptance gate — the orchestrator WILL run this

```sh
{{ACCEPT_COMMAND}}
```

You MUST run this command yourself before committing. If it fails, fix your work and
re-run. **Never commit code that fails the acceptance gate.**

## Hard rules (project-wide invariants)

1. **Nix patterns**: Follow the existing sogo.nix pattern exactly:
   - Import `{ lib, env ? import ../environments/scs/default.nix { inherit lib; }, ... }`
   - Use `lib.mkLabels`, `lib.mkDeployment`, `lib.mkService`, `lib.mkIngress`
   - Use `lib.mkProbe` for health checks
   - Export a list of Nix attrsets (K8s resources), NOT a derivation
2. **Image registry**: Use `env.registry.url` (172.26.24.6:5001) for local images.
   For upstream images (ghcr.io, quay.io, docker.io), use original names — containerd
   mirrors automatically.
3. **Resource limits**: Bare-metal cluster — be conservative. Use `env.resources.small`
   or `env.resources.medium` as baseline. Security tools get `env.resources.medium`.
4. **SPDX headers**: Every new file starts with:
   ```
   # SPDX-License-Identifier: Apache-2.0
   # SPDX-FileCopyrightText: 2026 openDesk Edu Contributors
   ```
5. **No imperative Nix**: Use `let/in` and `import` expressions, not `with`. Follow
   the pure-functional style of existing service files.
6. **K8s manifest format**: Each resource is a plain Nix attrset. The scs/default.nix
   converts them to JSON/YAML via `builtins.toJSON`. Resources MUST be valid K8s manifests.
7. **Namespace**: Security operators go in their own namespace (e.g., `trivy-system`,
   `kyverno`, `falco`). Don't put them in `opendesk` or `opendesk-edu`.
8. **RBAC**: Operators need ClusterRole + ClusterRoleBinding with appropriate permissions.
   Follow least-privilege — only grant what the operator actually needs.
9. **ZKI IT-Grundschutz**: These manifests support ZKI checkpoints P0-CONT-001 (Cosign),
   P0-CONT-002 (Kyverno), P0-CONT-003 (Non-Root), P0-NET-001 (NetworkPolicies).

## Definition of Done

- File is syntactically valid Nix (`nix-instantiate --parse` passes)
- Follows the sogo.nix pattern (imports, labels, builder usage)
- Generates correct K8s manifest types (Deployment/Service/ClusterRole/etc.)
- SPDX header present
- Resource limits appropriate for 3-node bare-metal cluster
- RBAC follows least-privilege principle

{{PREVIOUS_ERROR}}

## If you are a merge-conflict retry

Your previous attempt passed the acceptance gate but failed to merge because
main advanced while you worked. Your work is **preserved on this branch**. Do this:
1. Run `git rebase main` — resolve any conflict markers in the named files
   (keep BOTH your work and the new main changes where they don't collide).
2. Re-run the acceptance gate; it must pass on the rebased code.
3. Commit the resolution and finish as normal.

## HARD REQUIREMENT: you MUST modify files

Your task is judged ONLY by real file changes in your scope. The orchestrator
checks `git diff` against the base commit before running the gate.

**If you do not modify at least one in-scope file, the task FAILS immediately.**

## When finished

1. Run the acceptance gate. It must be green.
2. `git add -A` the files in your scope (and ONLY those).
3. Commit with message: `feat({{TASK_ID}}): {{TASK_TITLE}}`
4. Reply with a concise summary of what you implemented.
