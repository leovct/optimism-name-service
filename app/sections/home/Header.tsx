import { FC } from "react";
import styled from "styled-components";
import Image from "next/image";

import Button from "../../components/Button";

import OptimismLogo from "../../assets/logo/optimism.svg";

type HeaderProps = {
    onConnect: () => void;
};

const Header: FC<HeaderProps> = ({ onConnect }) => {
    return (
        <Container>
            <BrandContainer>
                <Image src={OptimismLogo} alt="optimism-logo" priority={true} />
                <p>Optimism Name Service</p>
            </BrandContainer>
            <MenuContainer>
                <Button
                    onClick={() => console.log("You clicked on the network button!")}
                >
                    <span>Optimism Kovan</span>
                </Button>
                <ConnectWalletButton onClick={onConnect}>
                    <span>Connect Wallet</span>
                </ConnectWalletButton>
                <DotButton
                    size="sm"
                    onClick={() => console.log("You clicked on the option button!")}
                >
                    <span>...</span>
                </DotButton>
            </MenuContainer>
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
        font-family: "Inter";
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

const MenuContainer = styled.div`
    display: flex;
    gap: 40px;
`;

const ConnectWalletButton = styled(Button)`
  /* Remove break lines */
  white-space: nowrap;

  /* Border */
  border: 2px solid transparent;
  background:
    linear-gradient(#ffffff 0 0) padding-box,
    linear-gradient(73.6deg, #FFCC00 2.11%, #FF0320 90.45%) border-box;

  /* Text */
  span {
    font-weight: 700;

    /* Gradient */
    background-color: white;
    background-image: linear-gradient(73.6deg, #FFCC00 2.11%, #FF0320 90.45%);
    background-size: 100%;
    background-repeat: repeat;
    -webkit-text-fill-color: transparent;
    -webkit-background-clip: text;
    color: transparent;
  }

  &:hover {
    border-width: 3px;
    background: linear-gradient(#ffffff 0 0) padding-box,
      linear-gradient(-73.6deg, #FFCC00 2.11%, #FF0320 90.45%) border-box;
  }

  &:active {
    border-width: 4px;
    box-shadow: inset -2px -2px 3px rgba(255, 255, 255, 0.25);
  }
`;

const DotButton = styled(Button)`
  span {
    font-weight: 700;
    font-size: 20px;
  }
`;

export default Header;
