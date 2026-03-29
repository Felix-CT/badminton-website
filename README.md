# Bell Badminton Club Website

This repository contains the Hugo source, deployment automation, and production Terraform for the Bell Badminton Club website.

## Overview

- Static site generator: Hugo (theme-based)
- Source branch: `master`
- Generated-output branch: `hugo-build`
- Hosting target: AWS Amplify (wired to `hugo-build`)
- Infrastructure as code: Terraform under `infra/terraform/production`

The repository is organized so editors can work in Hugo source files while generated output is kept in a separate branch for deployment.

## Repository Structure

- `config.toml`: Main Hugo site configuration.
- `content/`: Page and section content in Markdown.
- `layouts/`: Site-level Hugo templates and partials.
- `assets/`: Source JS/SCSS compiled or processed during build.
- `static/`: Files copied directly to the built site.
- `themes/alpha-church/`: Hugo theme submodule/content.
- `.github/workflows/hugo.yaml`: CI workflow that builds and syncs generated output to `hugo-build`.
- `infra/terraform/production/`: Production Terraform root and modules.
- `docs/architecture.mmd`: Mermaid architecture diagram source.

## Architecture Diagram

Mermaid source: `docs/architecture.mmd`

To preview:

1. Open the file in VS Code with a Mermaid preview extension, or
2. Paste the diagram into any Mermaid-compatible renderer.

## Local Development

### Prerequisites

- Hugo extended (version `0.128.0` or newer recommended)
- Git
- Optional: Node.js (only if lockfiles are present and dependencies are used)

### Run local server

```bash
hugo server -D
```

This serves drafts and auto-reloads changes while editing.

### Build locally

```bash
hugo --gc --minify
```

Build output is generated in `public/`.

## Content Workflow

Typical content update flow:

1. Edit files under `content/`.
2. If needed, update menus/site settings in `config.toml`.
3. Run a local preview with `hugo server -D`.
4. Commit and push to `master`.

The workflow in `.github/workflows/hugo.yaml` handles generated output updates automatically.

## Deployment Automation (master -> hugo-build)

The GitHub Actions workflow performs the following:

1. Trigger on push to `master` (and manual dispatch).
2. Build Hugo output in `public/`.
3. Generate a manifest of produced files.
4. Check out `hugo-build` in a worktree.
5. Delete only previously generated files that are no longer produced.
6. Copy newly generated files into branch root.
7. Commit and push only when a real diff exists.

### Why this is safe

- Non-generated files on `hugo-build` are preserved.
- Generated files are incrementally updated.
- Generated-file deletions are mirrored correctly.
- No blanket replacement of the entire branch tree is performed.

## Verifying Automation

Use this short validation sequence:

1. Push a small content change to `master`.
2. Confirm the workflow run succeeds in GitHub Actions.
3. Confirm a new commit appears on `hugo-build`.
4. Confirm branch-only files remain untouched.
5. Delete one source page, push again, and confirm corresponding generated output is removed on `hugo-build`.
6. Re-run without meaningful changes and confirm no new commit is made.

## Branch Roles

- `master`: Authoritative source for content, templates, and configuration.
- `hugo-build`: Generated deployable output plus any intentional branch-only files.

Do not edit generated files on `hugo-build` unless intentionally maintaining branch-only artifacts.

## Terraform and Production Infrastructure

Terraform root: `infra/terraform/production`

What it manages/scaffolds:

- DNS resources (Route53)
- Hosting resources (Amplify app/branch/domain)
- IAM roles and policy attachments
- DynamoDB data resources
- API resources (Lambda and API Gateway import path)

Start with the production Terraform README:

- `infra/terraform/production/README.md`

Recommended approach:

1. Copy `terraform.tfvars.example` to local `terraform.tfvars`.
2. Initialize backend with the production S3 state settings.
3. Run `terraform plan`.
4. Import existing production resources in dependency order.

## Security and Operational Notes

- Never commit secrets, state files, `.terraform/`, or Lambda artifacts.
- Keep local-only environment values out of tracked files.
- Review CI workflow changes carefully before merging.
- Use branch protection and required checks on `master` where appropriate.

## Troubleshooting

### Workflow cannot push to hugo-build

- Check repository Actions permissions for write access.
- Ensure `hugo-build` branch is not blocking bot pushes via restrictive rules.

### Hugo build fails in CI

- Confirm `config.toml` changes are valid.
- Confirm any theme/submodule references are accessible.
- If Node dependencies are introduced, ensure lockfile and install step are consistent.

### Missing or stale generated pages

- Verify the source page exists and is published.
- Check workflow logs for manifest and sync step output.
- Trigger `workflow_dispatch` to run a manual sync.

## Maintainer Checklist

When changing deployment behavior:

1. Update `.github/workflows/hugo.yaml`.
2. Re-run verification sequence above.
3. Update this README and `docs/architecture.mmd` if architecture changed.

When changing infrastructure behavior:

1. Update Terraform module/root files.
2. Re-run `terraform plan` in production root.
3. Update `infra/terraform/production/README.md` if import or ownership scope changes.
