import * as React from 'react';
import { render } from 'react-dom';
import { GraphElement } from "../../moudles/nankan/races/_oddsGraph";

const target = document.getElementById('main-container');

const raceId = () => {
  if (target === null || target.dataset.id === undefined) return '';

  return target.dataset.id;
};

render(
  <React.StrictMode>
    <GraphElement
      raceId={ raceId() }
    />
  </React.StrictMode>,
  target
);
