# Starlight homepage copy review

## Verdict

The homepage does not read as obviously machine-generated, but it does read as **AI-polished marketing copy**. The impression is moderate—about **6/10 on an “AI-sounding” scale**—and comes mostly from the hero and the abstract language in the cards.

The copy is concise and restrained. It avoids the worst AI clichés such as “unlock,” “seamless,” and “revolutionize.” What makes it feel synthetic is the combination of:

- a symmetrical slogan: “Build with containers. Learn by shipping.”
- stacked positioning words: “practical, project-led curriculum”
- broad reassurance: “without getting lost in the jargon”
- abstract phrases: “the mental model you need,” “services, networks, and workflows,” and “security habits”
- repeated startup language around “shipping”
- very few details unique to this curriculum, such as the Food Trucks app, Flask, Elasticsearch, Nginx, or AWS

The older lesson copy has a recognizable authorial voice: first-person guidance, rhetorical questions, and concrete project details. The homepage replaces that voice with polished product-marketing language. That contrast is the strongest reason it feels AI-assisted.

Authorship cannot be determined from prose alone; this review is about the impression the copy creates.

## Step 1 — Hero

![Current homepage hero](/Users/prakhar/Code/docker-curriculum/audit-homepage-copy/01-current-hero.png)

**Health: Needs revision.**

| Copy | Assessment | Recommendation |
| --- | --- | --- |
| “Docker, from first principles” | Clean, but fashionable and not especially distinctive. “First principles” suggests a more theoretical treatment than this project-led course delivers. | Use “A hands-on Docker tutorial.” |
| “Build with containers. Learn by shipping.” | Memorable rhythm, but it has the strongest startup/AI-copy cadence on the page. “Shipping” is also repeated in the terminal. | Prefer “Learn Docker by building and deploying real apps.” If the slogan is intentionally part of the brand, keep it and make the supporting copy much more concrete. |
| “A practical, project-led curriculum…” | The adjective stack and “without getting lost in the jargon” are generic positioning language. It says how the course should feel, but not what the learner will actually do. | Name the actual progression: `docker run`, Dockerfiles, Flask, Elasticsearch, Compose, and AWS. |
| “Start learning” | Understandable but generic. | “Start the tutorial” is more concrete. |
| “View on GitHub” | Clear and conventional. | Keep. |
| Terminal progression | “Understand the container” is awkward and vague; “build a real web app” and “ship it to the cloud” could describe hundreds of tutorials. | Replace the promises with course-specific milestones. |

Suggested hero:

> **A hands-on Docker tutorial**
>
> # Learn Docker by building real apps.
>
> Start with `docker run`, package a Flask app, connect it to Elasticsearch with Compose, and deploy it to AWS. No Docker experience required.
>
> **Start the tutorial** · View on GitHub

Suggested terminal:

```text
$ docker run hello-world
→ write your first Dockerfile
→ run Flask + Elasticsearch with Compose
→ deploy the app to AWS
```

## Step 2 — Learning paths and footer

![Current learning paths and footer](/Users/prakhar/Code/docker-curriculum/audit-homepage-copy/02-current-paths-footer.png)

**Health: Mixed. The structure scans well, but three of the four cards are more generic than the course itself. The footer is strong.**

### Section heading

“Pick your path” implies four alternative routes, while the cards are numbered stages in one curriculum. Use:

- “Choose where to start” if learners are genuinely encouraged to jump ahead, or
- “Curriculum at a glance” if the intended experience is sequential.

### Card 1

“New to containers?” is natural and audience-aware. The body—“why containers matter” and “the mental model you need”—is abstract and sounds AI-polished.

Recommended:

> **01 / FOUNDATIONS**  
> **Start with the basics**  
> Learn how images and containers work, and how Docker differs from a virtual machine.

### Card 2

This is the strongest card. It names a static site and Flask, so it feels grounded in a real curriculum. “From scratch” is slightly clichéd but harmless.

Recommended:

> **02 / DOCKERFILES**  
> **Containerize a web app**  
> Serve a static site with Nginx, then package a Flask app in your own image.

### Card 3

“Run a full stack app” should be “full-stack” when used as an adjective. “Services, networks, and workflows” is an abstract list, and “modern Compose” does not tell the learner what they will build.

Recommended:

> **03 / COMPOSE**  
> **Connect two services**  
> Run the Food Trucks app with Flask and Elasticsearch using Docker networking and Compose.

### Card 4

“Go beyond hello world” is familiar but clichéd. The technology names help, while “security habits” is vague. The label “04 / SHIP” does not match a chapter about BuildKit, multi-platform builds, Compose Watch, and security.

Recommended:

> **04 / MODERN DOCKER**  
> **Make builds faster and safer**  
> Use multi-stage builds, target ARM and x86, sync code with Compose Watch, and harden your containers.

### Footer

“Written and developed by Prakhar Srivastav” is the most human line on the page because it is direct, factual, and attributable. Keep it.

## Highest-impact changes

1. Replace the generic hero paragraph with the actual course journey.
2. Put Flask, Elasticsearch, Nginx, the Food Trucks app, and AWS on the homepage.
3. Replace “Pick your path” with wording that matches whether the curriculum is sequential or skippable.
4. Make the four stage labels parallel and accurate.
5. Remove or reduce repeated “ship/shipping” language.

## Accessibility and evidence limits

The visible copy has clear headings, concise link labels, and understandable card titles. The screenshot and DOM structure show labelled hero and path regions, and the card links have descriptive accessible names. A copy review cannot verify color contrast, keyboard behavior, screen-reader announcements, responsive reflow, or full WCAG compliance.
