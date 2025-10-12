# Solidarity Documentation

Official documentation for [Solidarity](https://docs.solidarity.gg) - Privacy-first business card sharing app.

## 🚀 Quick Start

### Prerequisites

- [Bun](https://bun.sh) - Fast JavaScript runtime and package manager

### Installation

```bash
# Clone the repository
git clone https://github.com/kidneyweakx/solidarity.git
cd solidarity/docs

# Install dependencies
bun install
```

### Development

```bash
# Start development server
bun dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build

```bash
# Build for production
bun run build

# Preview production build
bun run start
```

## 📁 Project Structure

```
docs/
├── app/
│   ├── docs/                  # Documentation pages
│   │   ├── page.mdx          # Introduction
│   │   ├── _meta.js          # Navigation configuration
│   │   ├── usage/            # Usage guide section
│   │   │   ├── page.mdx      # Section overview
│   │   │   ├── _meta.js      # Section navigation
│   │   │   ├── quick-start/  # Quick start guide
│   │   │   ├── use-cases/    # Use cases
│   │   │   ├── sharing-methods/  # Sharing methods
│   │   │   └── privacy-security/ # Privacy & security
│   │   ├── features/         # Features documentation
│   │   ├── architecture/     # Technical architecture
│   │   └── contribute/       # Contributing guide
│   ├── layout.tsx            # Root layout
│   └── page.tsx              # Homepage
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Pages deployment
├── next.config.mjs           # Next.js configuration
├── package.json
└── bun.lock
```

## 📝 Creating New Pages

### 1. Create a Page File

```bash
# For a top-level page
mkdir -p app/docs/my-page
touch app/docs/my-page/page.mdx

# For a subsection
mkdir -p app/docs/usage/my-subsection
touch app/docs/usage/my-subsection/page.mdx
```

### 2. Add Frontmatter

```mdx
---
title: Page Title
description: Brief description of the page
---

# Page Title

Your content here...
```

### 3. Update Navigation

Edit the `_meta.js` file in the same directory:

```js
// app/docs/_meta.js
export default {
  index: 'Introduction',
  'usage': 'Usage Guide',
  'my-page': 'My New Page',  // Add this
  'features': 'Features',
}
```

## 🎨 MDX Features

### Code Blocks

````mdx
```bash
bun install
bun dev
```
````

### Callouts

```mdx
> **Note:** This is a note callout
```

### Internal Links

```mdx
[Usage Guide](/docs/usage)
```

### External Links

```mdx
[Nextra Documentation](https://nextra.site/docs)
```

## 🚢 Deployment

Documentation is automatically deployed to [https://docs.solidarity.gg](https://docs.solidarity.gg) when changes are pushed to the `main` branch via GitHub Actions.

The deployment workflow uses:
- **Bun** for dependencies and building
- **GitHub Pages** for hosting
- **Custom domain** configured via DNS

## 🛠 Built With

- [Nextra](https://nextra.site/) - Next.js-based documentation framework
- [Next.js](https://nextjs.org/) - React framework
- [Bun](https://bun.sh/) - JavaScript runtime and package manager
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework

## 📖 Writing Guidelines

- **Use clear, concise language**
- **Include code examples** where relevant
- **Add screenshots** for UI-related documentation
- **Keep pages focused** - split long content into multiple pages
- **Test all links** before submitting
- **Follow existing structure** for consistency

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](https://docs.solidarity.gg/docs/contribute) for detailed instructions.

## 📄 License

This documentation is part of the Solidarity project.

## 🔗 Links

- **Documentation**: [https://docs.solidarity.gg](https://docs.solidarity.gg)
- **Main Repository**: [https://github.com/kidneyweakx/solidarity](https://github.com/kidneyweakx/solidarity)
- **Issues**: [https://github.com/kidneyweakx/solidarity/issues](https://github.com/kidneyweakx/solidarity/issues)
