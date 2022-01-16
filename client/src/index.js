import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { NETWORKS, Provider } from '@web3-ui/core'
import './index.css';

ReactDOM.render(
  <React.StrictMode>
    <Provider network={NETWORKS.goerli}>
      <App />
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);

