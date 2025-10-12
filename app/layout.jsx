import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import { Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'
import 'nextra-theme-docs/style.css'
import Image from 'next/image'

export const metadata = {
  title: 'Solidarity Docs',
  description: 'Solidarity Documentation',
  icons: {
    icon: '/favicon.ico'
  }
}

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
