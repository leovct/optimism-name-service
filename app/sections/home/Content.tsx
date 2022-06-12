import { FC } from "react";
import styled from "styled-components";

import Button from "../../components/Button";

const Content: FC = () => {
    return (
        <Container>
            <Input type="text" placeholder="wagmi.opt" />
            <span>.opt</span>
            <StyledButton
                onClick={() => console.log("You clicked on the test button!")}
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
