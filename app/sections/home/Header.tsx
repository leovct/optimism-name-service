import { FC } from "react";
import styled from "styled-components";
import Image from "next/image";
import { ConnectButton } from '@rainbow-me/rainbowkit';

import OptimismLogo from "../../assets/logo/optimism.svg";

const Header: FC = () => {
    return (
        <Container>
            <BrandContainer>
                <Image src={OptimismLogo} alt="optimism-logo" priority={true} />
                <p>Optimism Name Service</p>
            </BrandContainer>
            <ConnectButton showBalance={false} chainStatus="full" />
        </Container>
    );
}

const Container = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;

    padding: 40px;
    width: 100%;

    p {
        color: #FF0320;
        font-style: normal;
        font-weight: 900;
        font-size: 22px;
        line-height: 20px;
    }
`;

const BrandContainer = styled.div`
    display: flex;
    gap: 20px;
`;

export default Header;
