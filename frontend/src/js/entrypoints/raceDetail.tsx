import * as React from 'react';
import { render } from 'react-dom';
import { GraphElement } from "../moudles/races/_oddsGraph";

const target = document.getElementById('main-container');

render(
  <React.StrictMode>
    <GraphElement/>
  </React.StrictMode>,
  target
);
