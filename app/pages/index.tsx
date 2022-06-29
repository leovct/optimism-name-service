import styles from "../styles/Home.module.css";
import type { NextPage } from "next";
import Head from "next/head";

// eslint-disable-next-line node/no-missing-import
import Content from "../sections/home/Content";
// eslint-disable-next-line node/no-missing-import
import Footer from "../sections/home/Footer";
// eslint-disable-next-line node/no-missing-import
import Header from "../sections/home/Header";

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
};

export default Home;
