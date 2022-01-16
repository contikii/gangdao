import React, { useEffect, useState } from 'react';

import {
  Container,
  Stack,
  Input,
  Button,
  Heading,
  Text
} from '@chakra-ui/react';

import { useWallet, ConnectWallet } from '@web3-ui/core';
import { NFTGallery } from '@web3-ui/components';
import { useContract } from '@web3-ui/hooks';
import  GangFactoryABI  from './abis/GangFactory.json';

function App() {
  const [address, setAddress] = useState('');
  const [nftGallery, setNftGallery] = useState(null);
  const {
    correctNetwork,
    switchToCorrectNetwork,
    connected,
    provider
  } = useWallet();
  const [gangFactory, isReady] = useContract(
    // Goerli
    '0x7e1D33FcF1C6b6fd301e0B7305dD40E543CF7135',
    GangFactoryABI
  );

  useEffect(() => {
    console.log('correctNetwork', correctNetwork);
  }, [correctNetwork]);

  async function setGreeting() {
    console.log(gangFactory);

    // const response = await greeterContract.setGreeting('Hello World');

    // console.log('setGreeting', response);
  }

  async function greet() {
    const response = await gangFactory.greet();

    console.log('greet', response);
  }

  return (
    <Container>
      <ConnectWallet />
      {!correctNetwork && (
        <Button onClick={switchToCorrectNetwork}>Switch to Goerli. </Button>
      )}
      
      <Stack p={3}>
        <Heading>Demo</Heading>
        <Text>Type in an address to view their NFTs</Text>
        <Input
          placeholder="Address"
          value={address}
          onChange={e => setAddress(e.target.value)}
        />
        <Button
          disabled={!connected}
          onClick={() =>
            setNftGallery(
              <NFTGallery
                address={address}
                gridWidth={2}
                web3Provider={provider}
              />
            )
          }
        >
          {connected ? 'Submit' : 'Connect your wallet first!'}
        </Button>
        {nftGallery}
      </Stack>
    </Container>
  );
}

export default App;