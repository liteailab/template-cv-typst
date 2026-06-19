#import "template.typ": *

#set page(
  margin: (
    left: 8mm,
    right: 8mm,
    top: 8mm,
    bottom: 8mm
  ),
)

// Font switcher. Override at build time with e.g. `typst compile --input font="Inter" ...`
// Available locally (assets/fonts): "Inter", "Roboto"
#let bodyFont = sys.inputs.at("font", default: "Inter")

#set text(font: bodyFont)

#show: project.with(
  theme: rgb("#0F83C0"),
  name: "Alex Doe",
  contact: (
    contact(
      text: "LinkedIn://alexdoe",
      link: "https://www.linkedin.com/in/alexdoe"
    ),
    contact(
      text: "Github://alexdoe",
      link: "https://www.github.com/alexdoe"
    ),
    contact(
      text: "alexdoe.dev",
      link: "https://alexdoe.dev"
    ),
    contact(
      text: "alex@example.com",
      link: "mailto:alex@example.com"
    )
  ),
  main: (
    section(
      title: "Experience",
      content: (
        subSection(
          title: "Acme Cloud",
          titleEnd: "Remote",
          subTitle: "Senior Full Stack Engineer",
          subTitleEnd: "(Jan 2023 – Present)",
          content: [
            #list(
              [Led development of a multi-tenant SaaS platform serving *50k+ daily active users*, owning both the *React/TypeScript* frontend and the *Node.js* API layer.],
              [Designed and shipped a *GraphQL* gateway consolidating 6 internal REST services, cutting average page load time by *40%*.],
              [Drove the platform's migration to a *Kubernetes*-based infrastructure on *AWS*, improving reliability to *99.95%* uptime.],
              [Built CI/CD pipelines with *GitHub Actions* and *Docker*, reducing deployment time from 30 minutes to under 5.],
              [Mentored 4 engineers and established code-review, observability, and testing standards across the team.],
              [*Technologies:* React, TypeScript, Node.js, GraphQL, PostgreSQL, Kubernetes, Docker, AWS],
            )
          ],
        ),
        subSection(
          title: "Bright Labs",
          titleEnd: "Berlin, DE",
          subTitle: "Full Stack Engineer",
          subTitleEnd: "(Jun 2020 – Dec 2022)",
          content: list(
            [Developed customer-facing features for an e-commerce platform using *Next.js* and a *Django REST* backend.],
            [Implemented real-time inventory sync with *WebSockets* and *Redis*, eliminating overselling incidents.],
            [Migrated a legacy monolith to a modular service architecture, improving release cadence to weekly.],
            [Added end-to-end testing with *Playwright*, raising critical-path coverage to *85%*.],
            [*Technologies:* Next.js, Django, Python, Redis, MySQL, Playwright],
          ),
        ),
        subSection(
          title: "Nimbus Analytics",
          titleEnd: "Amsterdam, NL",
          subTitle: "Backend Engineer",
          subTitleEnd: "(Aug 2017 – May 2020)",
          content: list(
            [Built high-throughput data ingestion services in *Go* processing *2B+ events/day* from streaming sources.],
            [Designed an event pipeline on *Kafka* and *PostgreSQL* powering the company's real-time analytics dashboards.],
            [Reduced query latency by *60%* by introducing materialized views and a *Redis* caching layer.],
            [Owned on-call rotation and incident response for the core ingestion platform.],
            [*Technologies:* Go, Python, Kafka, PostgreSQL, Redis, Docker, GCP],
          ),
        ),
        subSection(
          title: "Startup Forge",
          titleEnd: "Remote",
          subTitle: "Web Developer",
          subTitleEnd: "(Sep 2015 – Jul 2017)",
          content: list(
            [Built and maintained marketing sites and internal dashboards using *Vue.js* and *Express*.],
            [Integrated third-party payment and analytics APIs (*Stripe*, *Segment*) into production apps.],
            [Shipped the company's first mobile-responsive design system, adopted across all client projects.],
            [*Technologies:* Vue.js, Express, Node.js, MongoDB, Stripe],
          ),
        ),
        subSection(
          title: "PixelWorks Agency",
          titleEnd: "Munich, DE",
          subTitle: "Frontend Developer",
          subTitleEnd: "(Jul 2013 – Aug 2015)",
          content: list(
            [Delivered 20+ client websites and campaign microsites with *JavaScript*, *jQuery*, and *Sass*.],
            [Partnered with designers to translate Figma mockups into pixel-accurate, accessible interfaces.],
            [Introduced a reusable component library that cut new-project setup time by *30%*.],
            [*Technologies:* JavaScript, jQuery, Sass, Gulp, WordPress],
          ),
        ),
        subSection(
          title: "DataNest",
          titleEnd: "Munich, DE",
          subTitle: "Junior Software Developer",
          subTitleEnd: "(Jun 2011 – Jun 2013)",
          content: list(
            [Maintained internal CRM tooling and fixed bugs across a *PHP* and *MySQL* codebase.],
            [Automated weekly reporting tasks with *Python* scripts, saving the team several hours per week.],
            [*Technologies:* PHP, MySQL, Python, jQuery],
          ),
        ),
      ),
    ),
    section(
      title: "Skills",
      content: (
        subSection(
          title: "Technical",
          content: [
            *Languages:* TypeScript, JavaScript, Python, Go, SQL, PHP\
            *Frontend:* React, Next.js, Vue.js, HTML, CSS, Tailwind, Sass\
            *Backend:* Node.js, Express, Django, GraphQL, REST, Kafka\
            *Data & Infra:* PostgreSQL, MySQL, MongoDB, Redis, Docker, Kubernetes, AWS, GCP, GitHub Actions
          ],
        ),
        subSection(
          title: "Leadership",
          content: [
            Team mentorship · Technical roadmapping · Code-review culture\
            Incident response & on-call · Cross-functional collaboration
          ],
        ),
      ),
    ),
    section(
      title: "Education",
      content: (
        subSection(
          title: "Technical University",
          titleEnd: "Munich, DE",
          subTitle: "BSc in Computer Science",
          subTitleEnd: "(2008 – 2011)",
          content: [
            Graduated with honors\
            Focus: Web Systems & Distributed Computing
          ],
        ),
        subSection(
          title: "AWS",
          titleEnd: "Online",
          subTitle: "Certified Solutions Architect – Associate",
          subTitleEnd: "(2021)",
          content: [
            Cloud architecture, scalability, and cost optimization on AWS.
          ],
        ),
      ),
    ),
  ),
  sidebar: (),
)
