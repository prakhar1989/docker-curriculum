# Docker Curriculum Documentation Site (Starlight)

This folder contains the source code for the **[Docker Curriculum](https://docker-curriculum.com)** documentation website, built with [Astro Starlight](https://starlight.astro.build/).

## 🚀 Features

- **Interactive Quizzes**: Custom `<Quiz />` component integrated into end-of-chapter knowledge checks.
- **Fast Static Generation**: Lightning-fast site build powered by Astro & Pagefind full-text search.
- **1-Click Devcontainers & Codespaces**: Pre-configured `.devcontainer` setup with Docker support.
- **Web Analytics**: Integrated Cloudflare Web Analytics tracking.

---

## 📁 Directory Structure

```
starlight/
├── public/                # Static assets (favicons, Codespaces screenshots, copy-code.js)
│   ├── codespaces.png
│   └── codespaces-docker.png
├── src/
│   ├── assets/            # Content images (diagrams, flowcharts, gifs)
│   ├── components/        # Custom Astro components (Quiz.astro, etc.)
│   ├── content/
│   │   ├── docs/          # Curriculum chapters (.md and .mdx files)
│   │   │   ├── introduction/
│   │   │   ├── getting-started/
│   │   │   ├── hello-world/
│   │   │   ├── webapps-with-docker/
│   │   │   ├── multi-container-environments/
│   │   │   ├── modern-docker/
│   │   │   └── conclusion/
│   │   └── config.ts      # Starlight content collections schema
│   └── styles/            # Custom CSS styling tokens (`custom.css`)
├── astro.config.mjs       # Starlight configuration, sidebar navigation, head scripts
├── package.json           # Dependencies and build scripts
└── tsconfig.json
```

---

## 🧞 Available Commands

Run these commands from the `starlight` folder (or via `npm --prefix starlight <command>` from the root workspace):

| Command               | Action                                               |
| :-------------------- | :--------------------------------------------------- |
| `npm install`         | Installs dependencies                                |
| `npm run dev`         | Starts local dev server at `http://localhost:4321`   |
| `npm run build`       | Builds production static site into `./dist/`         |
| `npm run preview`     | Previews the production build locally                |
| `npm run astro ...`   | Runs Astro CLI commands                              |

---

## 🛠️ Customization & Configuration

- **Sidebar Navigation & Head Scripts**: Configured in [astro.config.mjs](file:///Users/prakhar/Code/docker-curriculum/starlight/astro.config.mjs).
- **Styling**: Custom component styles and theme overrides are defined in `src/styles/custom.css`.
- **Content Pages**: Edit Markdown files in `src/content/docs/`.
