# My Claude Code Setup (Make + R/Julia)

> **Work in progress.** This is a summary of how I use Claude Code for computational research — running analysis pipelines with Make, writing R and Julia scripts, and managing build dependencies. I keep updating these files as I learn new things.

A ready-to-fork starter kit for researchers using [Claude Code](https://code.claude.com/docs/en/overview) with **Make + R + Julia** build systems. You describe what you want; Claude plans the approach, implements it, builds via Make, runs specialized review agents, fixes issues, and presents results — like a contractor who handles the entire job.

---

## Quick Start (5 minutes)

### 1. Fork & Clone

```bash
# Fork this repo on GitHub (click "Fork" on the repo page), then:
git clone https://github.com/YOUR_USERNAME/repo-template.git my-project
cd my-project
```

Replace `YOUR_USERNAME` with your GitHub username.

### 2. Start Claude Code and Paste This Prompt

```bash
claude
```

**Using VS Code?** Open the Claude Code panel instead. Everything works the same.

Then paste the following, filling in your project details:

> I am starting to work on **[PROJECT NAME]** in this repo. **[Describe your project in 2–3 sentences — what you're building, what data you use, what your pipeline stages are (e.g., data cleaning, estimation, figures).]**
>
> I want our collaboration to be structured, precise, and rigorous. Code should be reproducible and build-system driven.
>
> I've set up the Claude Code academic workflow (forked from `irudik/repo-template`). The configuration files are already in this repo. Please read them, understand the workflow, and then **update all configuration files to fit my project** — fill in placeholders in `CLAUDE.md`, set up the `code/` directory structure with sub-Makefiles for my pipeline stages, and propose any customizations specific to my use case.
>
> After that, use the plan-first workflow for all non-trivial tasks. Once I approve a plan, switch to contractor mode — coordinate everything autonomously and only come back to me when there's ambiguity or a decision to make.
>
> Enter plan mode and start by adapting the workflow configuration for this project.

**What this does:** Claude reads all the configuration files, sets up your `code/` directory with sub-Makefiles for each pipeline stage, fills in your project details, then enters contractor mode — planning, implementing, reviewing, and verifying autonomously.

---

## How It Works

### Make as the Backbone

A root Makefile delegates to `code/` (analysis pipeline) and `latex/` (manuscript):

```
my-project/
├── Makefile              # Root — delegates to code/ and latex/
├── code/
│   ├── Makefile          # Delegates to sub-Makefiles
│   ├── data_prep/
│   │   ├── Makefile      # Targets for cleaning raw data
│   │   ├── clean.R
│   │   └── merge.R
│   ├── estimation/
│   │   ├── Makefile      # Targets for running models
│   │   ├── model.R
│   │   └── bootstrap.R
│   ├── simulation/
│   │   ├── Makefile      # Targets for trade model simulation
│   │   ├── simulate_trade.jl
│   │   └── process_results.jl
│   ├── tables/
│   │   ├── Makefile      # Targets for regression tables
│   │   └── reg_tables.R
│   └── figures/
│       ├── Makefile      # Targets for generating plots
│       └── main_figures.R
└── latex/
    ├── Makefile          # pdflatex 3-pass build
    ├── manuscript.tex    # Main paper
    ├── slides.tex        # Presentation slides
    ├── latex_extras/     # Preamble files
    └── references/       # .bib and .bst files
```

- `make` from project root builds everything (code first, then latex)
- `make -n` shows what would be rebuilt (dry-run)
- `make -C code` rebuilds all code targets
- `make -C code/estimation all` rebuilds one pipeline stage
- `make -C latex` compiles the manuscript
- Scripts never create directories — Makefiles own that via order-only prerequisites

### Contractor Mode

You describe a task. Claude:
1. **Plans** the approach (enter plan mode, save to disk)
2. **Implements** the code
3. **Verifies** via `make -n` then `make` — builds stale targets (including `make -C latex` for the manuscript), checks exit codes
4. **Reviews** with specialized agents (r-reviewer, julia-reviewer, verifier)
5. **Fixes** issues found by reviewers
6. **Scores** against quality gates

If the score meets threshold, Claude presents a summary. Say "just do it" and it auto-commits too.

### Specialized Agents

Focused agents each check one dimension:

| Agent | What It Checks |
|-------|---------------|
| `r-reviewer` | R code quality, reproducibility, domain correctness |
| `julia-reviewer` | Julia code quality, type stability, performance |
| `verifier` | End-to-end build verification, orphaned script detection |

The verifier runs an **orphaned script check**: every `.R` and `.jl` file under `code/` must appear as a prerequisite in some Makefile. Scripts with no Makefile target get flagged.

### Quality Gates

Every file gets a score (0–100). Scores below threshold block the action:
- **80** — commit threshold
- **90** — PR threshold
- **95** — excellence (aspirational)

Rubrics cover R scripts, Julia scripts, Makefiles, and LaTeX manuscripts. See `.claude/rules/quality-gates.md` for the full deduction table.

---

## What's Included

<details>
<summary><strong>Agents, skills, and rules</strong> (click to expand)</summary>

### Agents (`.claude/agents/`)

| Agent | What It Does |
|-------|-------------|
| `r-reviewer` | R code quality, reproducibility, and domain correctness |
| `julia-reviewer` | Julia code quality, type stability, and performance |
| `verifier` | End-to-end build verification with orphaned script check |

### Key Skills (`.claude/skills/`)

| Skill | What It Does |
|-------|-------------|
| `/commit` | Stage, commit, PR, merge (with `make -n` staleness warning) |
| `/data-analysis` | End-to-end R analysis workflow |

### Key Rules (`.claude/rules/`)

| Rule | What It Enforces |
|------|-----------------|
| `makefile-conventions` | Standard Make patterns: `.PHONY`, order-only prereqs, pattern rules, joint production |
| `r-code-conventions` | R coding standards, Makefile-based directory creation |
| `julia-code-conventions` | Julia coding standards, Makefile-based directory creation |
| `quality-gates` | 80/90/95 scoring for R, Julia, Makefiles, and LaTeX |
| `verification-protocol` | Make-first verification, then file-specific checks |
| `orchestrator-protocol` | Contractor mode: implement, verify via Make, review, fix, score |
| `orchestrator-research` | Simplified loop for R/Julia scripts |
| `plan-first-workflow` | Plan mode for non-trivial tasks |

</details>

---

## Prerequisites

| Tool | Required For | Install |
|------|-------------|---------|
| [Claude Code](https://code.claude.com/docs/en/overview) | Everything | `npm install -g @anthropic-ai/claude-code` |
| [GNU Make](https://www.gnu.org/software/make/) | Build system | Pre-installed on macOS/Linux |
| R | Data analysis, figures | [r-project.org](https://www.r-project.org/) |
| Julia | Computation, simulation | [julialang.org](https://julialang.org/downloads/) |
| pdflatex | Manuscript compilation | Included with TeX Live / MacTeX |
| [gh CLI](https://cli.github.com/) | PR workflow | `brew install gh` (macOS) |

Not all tools are needed — install only what your project uses. Claude Code is the only hard requirement.

---

## Dynamic Numbers in LaTeX

The pipeline keeps computed results out of your `.tex` source by writing `\newcommand` definitions to `output/numbers/` and resolving them at compile time via `TEXINPUTS`.

### How it works

1. **Code generates a `.txt` file** with a `\newcommand`:

   **R:**
   ```r
   writeLines("\\newcommand{\\revenueEstimate}{4.72}",
              file.path("output", "numbers", "revenue_estimate.txt"))
   ```

   **Julia:**
   ```julia
   open(joinpath("output", "numbers", "revenue_estimate.txt"), "w") do io
       println(io, "\\newcommand{\\revenueEstimate}{4.72}")
   end
   ```

2. **The manuscript inputs the file** (plain filename — no path prefix needed):
   ```latex
   \input{revenue_estimate.txt}
   A U.S. carbon tariff raises \$\revenueEstimate\ billion in revenue.
   ```

3. **`TEXINPUTS` resolves the path.** The `latex/Makefile` exports:
   ```make
   export TEXINPUTS := .:./latex_extras/:../output/numbers/:../output/tables/:../output/figures/:
   ```
   So `pdflatex` finds `revenue_estimate.txt` in `../output/numbers/` without your `.tex` files needing `../output/` prefixes.

### Adding a new dynamic number

1. Add the write call to your R or Julia script
2. Add the `.txt` file as a prerequisite in the relevant `code/` Makefile
3. Add `\input{filename.txt}` in the manuscript preamble (or wherever the macro is first used)
4. Use the macro (`\revenueEstimate`) in prose
5. Run `make` — the code pipeline writes the file, then `pdflatex` picks it up

The same `TEXINPUTS` mechanism resolves figures (`output/figures/`) and tables (`output/tables/`), so `\includegraphics{plot.pdf}` and `\input{reg_table.tex}` also work without path prefixes.

---

## Adapting for Your Field

1. **Add field-specific pitfalls** to `.claude/rules/r-code-conventions.md` and `.claude/rules/julia-code-conventions.md`
2. **Adjust tolerance thresholds** in `.claude/rules/quality-gates.md` for your domain's precision requirements
3. **Set up the `code/` directory** with sub-Makefiles matching your pipeline stages

---

## Project Structure

```
my-project/
├── CLAUDE.md                    # Project config (loaded every session)
├── Makefile                     # Root — delegates to code/ and latex/
├── .claude/                     # Rules, skills, agents, hooks
├── code/
│   ├── Makefile                 # Delegates to sub-Makefiles
│   ├── [task_group_a]/          # e.g., data cleaning (R)
│   │   ├── Makefile
│   │   └── *.R or *.jl
│   ├── [task_group_b]/          # e.g., simulation (Julia)
│   │   ├── Makefile
│   │   └── *.R or *.jl
│   └── [task_group_c]/          # e.g., figures (R)
│       ├── Makefile
│       └── *.R or *.jl
├── latex/
│   ├── Makefile                 # pdflatex 3-pass build
│   ├── manuscript.tex           # Main paper
│   ├── slides.tex               # Presentation slides
│   ├── latex_extras/            # packages.tex, custom_commands.tex, etc.
│   └── references/              # references.bib, econ.bst
├── quality_reports/             # Plans, session logs, merge reports
└── templates/                   # Session log, quality report templates
```

Each `code/[task_group]/Makefile` follows the conventions in `.claude/rules/makefile-conventions.md`: `all` and `clean` targets, order-only prerequisites for directories, pattern rules for parametric outputs, and `.PRECIOUS` for expensive intermediates.

---

## License

MIT License. Use freely for research or any academic purpose.
