import * as React from 'react';
import { render } from 'react-dom';
import { GraphElement } from "../moudles/races/_oddsGraph";

const target = document.getElementById('main-container');

const raceId = () => {
  return location.href.split('/').filter(function(e){return e}).slice(-1)[0];
};

render(
  <React.StrictMode>
    <GraphElement
      raceId={ raceId() }
    />
  </React.StrictMode>,
  target
);
