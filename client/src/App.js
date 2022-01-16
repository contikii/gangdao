import React, { useEffect, useState } from "react";

import {
  Container,
  Stack,
  Input,
  Button,
  Heading,
  Text,
} from "@chakra-ui/react";

import { useWallet, ConnectWallet } from "@web3-ui/core";
import { NFTGallery } from "@web3-ui/components";
import { useContract } from "@web3-ui/hooks";
import GangFactoryABI from "./abis/GangFactory.json";

import { create } from "ipfs-http-client";


const projectId = process.env.REACT_APP_PROJECT_ID
const projectSecret = process.env.REACT_APP_SECRET_ID

const auth =
  'Basic ' + Buffer.from(projectId + ':' + projectSecret).toString('base64')

const client = create({
  host: 'ipfs.infura.io',
  port: 5001,
  protocol: 'https',
  headers: {
    authorization: auth
  }
})

// TODO separate state & function logic to different components
function App() {
  const [address, setAddress] = useState("");
  const [nftGallery, setNftGallery] = useState(null);
  
  // IPFS logic
  const [file, setFile] = useState(null);
  const [picUrl, setPicUrl] = useState("");
  const [metadataUrl, setMetadataUrl] = useState("");

  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  


  const { correctNetwork, switchToCorrectNetwork, connected, provider } = useWallet();
  
  const [gangFactory, isReady] = useContract("0x7e1D33FcF1C6b6fd301e0B7305dD40E543CF7135",GangFactoryABI); // Goerli


  const retrieveFile = (e) => {
    const data = e.target.files[0];
    const reader = new window.FileReader();
    reader.readAsArrayBuffer(data);
    reader.onloadend = () => {
      setFile(Buffer(reader.result));
    }

    e.preventDefault();  

  };

  const handlePicSubmit = async (e) => {
    e.preventDefault();
    console.log(client)
    try {
      const created = await client.add(file);
      console.log('path`?, ', created)
      const url = `https://ipfs.infura.io/ipfs/${created.path}`;
      setPicUrl(url);

    } catch (error) {
      console.log(error.message);
    }
  };

  const handleMetadataSubmit = async (e) => {
    e.preventDefault();

    try {
      const doc = JSON.stringify({
        name,
        description,
        image: picUrl
      });

      const created = await client.add(doc);
      console.log('path`?, ', created)
      const url = `https://ipfs.infura.io/ipfs/${created.path}`;
      setMetadataUrl(url);

    } catch (error) {
      console.log(error.message);
    }
  };

  function handleNameChange(e) {
    setName(e.target.value);
  };

  function handleDescriptionChange(e) {
    setDescription(e.target.value);
  };


  return (
    <Container>
      <ConnectWallet />
      {!correctNetwork && (
        <Button onClick={switchToCorrectNetwork}>Switch to Goerli. </Button>
      )}

      <Stack p={3}>
        <Heading>Demo</Heading>
        <Text>Your nfts.</Text>
        <Input
          placeholder="Address"
          value={address}
          onChange={(e) => setAddress(e.target.value)}
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
          {connected ? "Submit" : "Connect your wallet first!"}
        </Button>
        {nftGallery}
      </Stack>
      <form className="form" onSubmit={handlePicSubmit}>
        <input type="file" name="data" onChange={retrieveFile} />
        <button type="submit" className="btn">
          Upload file
        </button>
      </form>
      <form className="form" onSubmit={handleMetadataSubmit}>
        <label>name:<Input type="text"  name="name" onChange={handleNameChange} /></label>
        <label>description:<Input type="text" name="description" onChange={handleDescriptionChange} /></label>
        <Button type="submit" className="btn">
          upload metadata
        </Button>
      </form>

    </Container>
  );
}

export default App;
