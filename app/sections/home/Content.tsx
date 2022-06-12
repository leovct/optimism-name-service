import { FC } from "react";
import styled from "styled-components";
import { ethers } from "ethers";
import { useAddRecentTransaction } from '@rainbow-me/rainbowkit';

import Button from "../../components/Button";
import Contract from "../../contracts/ONS.json";

const Content: FC = () => {
    const addRecentTransaction = useAddRecentTransaction();

    const test = async function () {
        try {
            const { ethereum } = window;
            if (ethereum) {
                const provider = new ethers.providers.Web3Provider(ethereum as any);
                const signer = provider.getSigner();
                const contract = new ethers.Contract('0x1e9162F3cf08E7E6EE1f67FD35477a7F9aBC87b5', Contract.abi, signer);
                console.log('Connected to the contract!');
    
                const domain = 'wa.opt';
                const domainToBytes = ethers.utils.formatBytes32String(domain);
    
                // Verify domain is not registered yet
                await contract.getOwner(domainToBytes)
                    .then((owner: string) => console.log(`The domain owner is: ${owner}`))
                    .catch(async () => {
                        console.log("The transaction reverted! Maybe the domain is not registered yet...");
    
                        const registerTxn = await contract.register(domainToBytes, 60);
                        await registerTxn.wait();
                        console.log(`Domain ${domain} registered!`);
    
                        addRecentTransaction({
                            hash: registerTxn.hash,
                            description: `Register the ${domain} domain`,
                          });
                        
                    });
            } else {
                console.log('Not connected!');
            }
        } catch (error) {
            console.log(error);
        }
    }

    return (
        <Container>
            <Input type="text" placeholder="wagmi.opt" />
            <span>.opt</span>
            <StyledButton
                onClick={test}
            >
                <span>Register the domain</span>
            </StyledButton>
        </Container>
    );
}

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  gap: 10px;
`;

const StyledButton = styled(Button)`
  width: 440px;
  height: 40px;
`;

const Input = styled.input`
    /* Remove default styling */
    padding: 0;
	background: none;
	border: none;
	border-radius: 0;
	outline: none;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;

    width: 600px;
    height: 60px;
    display: flex;
    text-align: center;

    font-size: 20px;

    /* Border */
    border: 2px solid transparent;
    border-radius: 25px;
    background:
        linear-gradient(#ffffff 0 0) padding-box,
        linear-gradient(73.6deg, #FFCC00 2.11%, #FF0320 90.45%) border-box;
`;

export default Content;
