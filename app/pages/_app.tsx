import "../styles/globals.css";
// eslint-disable-next-line node/no-missing-import
import "@rainbow-me/rainbowkit/styles.css";

import type { AppProps } from "next/app";
import {
	RainbowKitProvider,
	getDefaultWallets,
	connectorsForWallets,
	wallet,
	lightTheme,
} from "@rainbow-me/rainbowkit";
import { chain, configureChains, createClient, WagmiConfig } from "wagmi";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";

const { chains, provider, webSocketProvider } = configureChains(
	[chain.optimism, chain.optimismKovan],
	[
		alchemyProvider({ alchemyId: process.env.ALCHEMY_API_KEY }),
		publicProvider(),
	]
);

const { wallets } = getDefaultWallets({
	appName: "Optimism Name Service",
	chains,
});

const connectors = connectorsForWallets([
	...wallets,
	{
		groupName: "Other",
		wallets: [
			wallet.argent({ chains }),
			wallet.trust({ chains }),
			wallet.ledger({ chains }),
		],
	},
]);

const wagmiClient = createClient({
	autoConnect: true,
	connectors,
	provider,
	webSocketProvider,
});

const appInfo = {
	appName: "Optimism Name Service",
};

function MyApp({ Component, pageProps }: AppProps) {
	return (
		<WagmiConfig client={wagmiClient}>
			<RainbowKitProvider
				appInfo={appInfo}
				chains={chains}
				showRecentTransactions={true}
				theme={lightTheme({
					accentColor:
						"\
							linear-gradient(0deg, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1)),\
							linear-gradient(311.52deg, #FFCC00 -10.37%, #FF0320 62.81%);",
					overlayBlur: "small",
				})}
				coolMode
			>
				<Component {...pageProps} />
			</RainbowKitProvider>
		</WagmiConfig>
	);
}

export default MyApp;
