import type { NextPage } from 'next';
import Head from 'next/head';
import Content from '../sections/home/Content';
import Footer from '../sections/home/Footer';
import Header from '../sections/home/Header';
import styles from '../styles/Home.module.css';

const Home: NextPage = () => {
  return (
    <>
      <Head>
        <title>ONS</title>
        <meta
          name="description"
          content="Optimism Name Service, a distributed naming system based on the Optimism blockchain"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <Header></Header>
        <Content></Content>
        <Footer></Footer>
      </main>
    </>
  );
}

export default Home;
