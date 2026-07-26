# Implementation Plan: Interactive Quizzes & Devcontainer Integration

This plan outlines the architecture, design, and step-by-step roadmap for adding interactive knowledge-check quizzes and 1-click Devcontainer integration to the **Docker Curriculum**.

---

## 1. Feature Overview & Goals

### Goal A: Interactive Chapter Quizzes (`<Quiz />`)
- **Purpose**: Test learner comprehension at the end of key chapters with interactive multiple-choice questions, instant visual feedback (correct/incorrect states), explanations, and score tracking.
- **Technology**: Lightweight Astro / React MDX component (`Quiz.astro`) styled with the Docker signature cyan/blue design system.
- **Target Chapters**:
  1. **Hello World**: `hello-world/01-docker-run.md` (Testing `docker run` flags `-d`, `-p`, `--name`).
  2. **Web Applications**: `webapps-with-docker/03-dockerfile.md` (Testing Dockerfile directives `FROM`, `WORKDIR`, `COPY`, `EXPOSE`, `CMD`).
  3. **Multi-Container Stack**: `multi-container-environments/03-docker-compose.md` (Testing Compose services, ports, networks, volumes).
  4. **Modern Docker**: `modern-docker/01-multi-stage-builds.md` (Testing multi-stage build concepts `FROM ... AS builder`).

### Goal B: Devcontainer Integration (`.devcontainer`)
- **Purpose**: Allow learners and contributors to open the repository in a pre-configured Docker environment with 1-click in VS Code, Cursor, or AGY IDE.
- **Components**:
  - Root `.devcontainer/devcontainer.json` configuration file.
  - Root `.devcontainer/Dockerfile` based on Node 20 & Python 3.12 with Docker-in-Docker (dind) support.
  - Documentation section in `getting-started/02-setting-up.md` ("Instant Setup with Devcontainers").

---

## 2. Technical Design & Architecture

### A. Quiz Component (`starlight/src/components/Quiz.astro`)

```astro
---
// Component Props Interface
export interface Question {
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
}

export interface Props {
  title?: string;
  questions: Question[];
}

const { title = "Knowledge Check", questions } = Astro.props;
---

<div class="quiz-container not-content" data-quiz={JSON.stringify(questions)}>
  <!-- Interactive Client-side Quiz UI rendered via JS -->
</div>
```

**Key Features**:
- **Interactive State**: Options highlight green on correct answer, soft red on incorrect selection, revealing detailed explanations.
- **Score Counter**: Displays live score (e.g. `Score: 3 / 3 🎉`) upon completing all questions.
- **Dark/Light Theme Responsive**: Integrates seamlessly with Starlight custom CSS tokens.

---

### B. Devcontainer Setup (`.devcontainer/`)

#### `.devcontainer/devcontainer.json`
```json
{
  "name": "Docker Curriculum Dev Environment",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:1-20-bullseye",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-azuretools.vscode-docker",
        "astro-build.astro-vscode",
        "esbenp.prettier-vscode"
      ]
    }
  },
  "postCreateCommand": "npm install && npm --prefix starlight install",
  "forwardPorts": [4321, 5000]
}
```

---

## 3. Implementation Roadmap & Steps

### Step 1: Build the `<Quiz />` Component
1. Create `starlight/src/components/Quiz.astro`.
2. Add interactive client-side JavaScript for handling option selection, score calculation, reset buttons, and explanations.
3. Add Quiz CSS rules in `starlight/src/styles/custom.css`.

### Step 2: Integrate Quizzes into Chapters
1. Import `<Quiz />` into MDX pages:
   - `hello-world/01-docker-run.md`
   - `webapps-with-docker/03-dockerfile.md`
   - `multi-container-environments/03-docker-compose.md`
   - `modern-docker/01-multi-stage-builds.md`

### Step 3: Create Devcontainer Configuration
1. Create `.devcontainer/devcontainer.json` in the root workspace directory.
2. Update `getting-started/02-setting-up.md` with a step-by-step section on using Devcontainers.

### Step 4: Verification & Site Build
1. Run `npm run build` to verify MDX page compilation.
2. Test local dev server at `http://localhost:4321` to verify interactive quiz UI and Devcontainer setup.

---

## 4. Maintenance & Extensions

- **Future Quizzes**: Easily add quizzes to remaining chapters by inserting `<Quiz questions={[...]} />` into MDX files.
- **GitHub Codespaces Support**: The `.devcontainer` configuration automatically enables 1-click browser environments in GitHub Codespaces.
