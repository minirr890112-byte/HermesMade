<p align="center">
  <img src="https://img.shields.io/badge/ClawHub-downloads-1910-blue" alt="ClawHub downloads">
  <img src="https://img.shields.io/badge/templates-54-green" alt="54 templates">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="MIT license">
</p>

# 🎨 Popular Web Designs

> 54 production-quality design systems extracted from real websites.
> One command to make your landing page look like Stripe, Linear, or Vercel.
> No designer. No Tailwind guessing. 30 seconds.

---

## The Problem

You build a tool, write the backend, deploy the API... then spend 3 hours making it "look decent." The result? Generic Tailwind gray. Meanwhile, Stripe and Linear have designers on payroll. You don't.

> "I spent more time on CSS than on my actual product logic. The landing page still looks like a default template." — every indie hacker

## The Solution

54 design systems extracted from production websites. Each one is a complete set of design tokens — colors, fonts, spacing, shadows, border radii — that match the visual identity of a specific company or style.

```bash
pip install git+https://github.com/minirr890112-byte/popular-web-designs.git
popular-web-designs load stripe-style --name "MySaaS"
```

---

## Quick Start

```bash
# Load a Stripe-style landing page
$ popular-web-designs load stripe-style --name "MySaaS"

✅ Loaded Stripe-style template
   Components: hero, features, pricing, CTA, footer
   Colors: #635BFF (primary), #0A2540 (dark), #F6F9FC (bg)
   Fonts: Inter, Source Code Pro

📁 Generated: ./MySaaS/
   ├── index.html       (hero + features + pricing + CTA)
   ├── styles.css       (Stripe design tokens)
   └── README.md        (deploy to Vercel in 1 click)
```

---

## Templates

| Template | Vibe | Best For |
|----------|------|----------|
| **Stripe** | Clean gradients, blue-purple | SaaS landing pages |
| **Linear** | Dark, minimal, monospace | Developer tools |
| **Vercel** | Black/white, geometric | Deployment platforms |
| **Notion** | Serif headings, clean cards | Docs, wikis, blogs |
| **GitHub** | Terminal-green accents | Open source projects |
| **Neo-brutalist** | Bold borders, primary colors | Indie hacker vibes |
| **Dashboard** | Data-dense, dark mode | Admin panels |
| **...47 more** | | |

---

## Why It Works

Each template includes:
- **Design tokens**: CSS custom properties for every color, spacing, and typography value
- **Component library**: hero, features, pricing, CTA, footer — pre-built and responsive
- **No framework lock-in**: Pure HTML + CSS, drop into any project
- **Responsive**: Mobile-first, works on all screen sizes

---

## Real Output

```css
/* Stripe-style generated CSS tokens */
:root {
  --primary: #635BFF;
  --primary-hover: #5A52E0;
  --dark: #0A2540;
  --bg: #F6F9FC;
  --text: #425466;
  --radius: 8px;
  --shadow-sm: 0 1px 2px rgba(10, 37, 64, 0.04);
  --shadow-md: 0 4px 12px rgba(10, 37, 64, 0.08);
  --font-sans: 'Inter', -apple-system, sans-serif;
  --font-mono: 'Source Code Pro', monospace;
}
```

---

## ⭐ Why Star?

1,910 developers downloaded this from ClawHub. **Zero left a star.**

If this saved you 3 hours of CSS pain, click that button. It's the only currency open source has.

---

## Related

- [HermesMade Dashboard](https://github.com/minirr890112-byte/HermesMade) — pain point intelligence platform
- [pain-to-pip-package](https://github.com/minirr890112-byte/pain-to-pip-package) — pipeline that built this

---

<p align="center">
  <b>Built from real website analysis. 54 designs. Zero designers harmed.</b><br>
  <sub>MIT License · <a href="https://github.com/minirr890112-byte/popular-web-designs">Give it a star →</a></sub>
</p>
