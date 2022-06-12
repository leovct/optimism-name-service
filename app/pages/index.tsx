import type { NextPage } from 'next'
import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>ONS</title>
        <meta name="description" content="Optimism Name Service" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to <a href="https://www.optimism.io/">Optimism</a> Name Service!
        </h1>
      </main>
    </div>
  )
}

export default Home
