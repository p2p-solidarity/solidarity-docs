import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import { Banner, Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'
import 'nextra-theme-docs/style.css'
import './archive-banner.css'
import Image from 'next/image'

export const metadata = {
  title: 'Solidarity Docs',
  description: 'Solidarity Documentation',
  icons: {
    icon: '/favicon.ico'
  },
  // Archived site: keep it viewable but out of search results. Crawling stays
  // allowed so crawlers can see this tag and the X-Robots-Tag header that
  // public/_headers sets on every response.
  robots: {
    index: false
  }
}

// Archive notice on every page. Not dismissible, so it can't be hidden.
const banner = (
  <Banner dismissible={false} className="archive-banner">
    <strong>Archived</strong> · These docs describe Solid(ar)ity 1.x and are no
    longer updated. Solidarity now builds creds →{' '}
    <a href="https://creds.id">creds.id</a>
  </Banner>
)

const navbar = (
  <Navbar
    logo={
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
        <Image src="/1024.png" alt="Solidarity" width={32} height={32} />
        <span style={{ fontWeight: 600 }}>Solid(ar)ity</span>
      </div>
    }
    projectLink="https://github.com/kidneyweakx/solidarity"
  />
)

const footer = <Footer>Apache 2.0 {new Date().getFullYear()} © Solid(ar)ity.</Footer>

export default async function RootLayout({ children }) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <Head />
      <body>
        <Layout
          banner={banner}
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/kidneyweakx/solidarity/tree/main/docs"
          footer={footer}
        >
          {children}
        </Layout>
      </body>
    </html>
  )
}
