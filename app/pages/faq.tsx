import type { NextPage } from "next";
import Head from "next/head";
import styles from "../styles/Home.module.css";

const Faq: NextPage = () => {
  return (
    <>
      <Head>
        <title>ONS FAQ</title>
        <meta
          name="description"
          content="Optimism Name Service, a distributed naming system based on the Optimism blockchain"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <p>Hello world=</p>
      </main>
    </>
  );
};

export default Faq;
