import * as React from "react";
import { Chart } from "react-google-charts";
import { getWinOdds, WinOdds } from "../api/_oddsApiClient";

const data = [
  ["時刻", "①ディープインパクト", "②オルフェーヴル", "③コントレイル", "④ハルウララ"],
  [new Date(2020, 5, 12, 10, 0, 0), 1.7, 12.4, 4.8, 200],
  [new Date(2020, 5, 12, 10, 0, 5), 1.8, 17.4, 5.0, 210],
  [new Date(2020, 5, 12, 10, 0, 10), 1.9, 11.2, 4.7, 150],
  [new Date(2020, 5, 12, 10, 0, 15), 1.8, 25.1, 4.3, 120],
  [new Date(2020, 5, 12, 10, 0, 20), 1.6, 20.5, 4.2, 100],
  [new Date(2020, 5, 12, 10, 0, 25), 1.3, 18.6, 6.3, 120],
  [new Date(2020, 5, 12, 10, 0, 30), 1.2, 24.1, 7.3, 150],
  [new Date(2020, 5, 12, 10, 0, 35), 1.4, 22.1, 8.3, 130],
  [new Date(2020, 5, 12, 10, 0, 40), 1.5, 21.1, 4.3, 120],
  [new Date(2020, 5, 12, 10, 0, 45), 1.6, 21.1, 5.3, 110]
];
const options = {
  title: "皐月賞",
  curveType: "none",
  legend: { position: "bottom" },
  pointSize: 5,
  vAxis: {
    title: "オッズ",
    scaleType: "log"
  },
  hAxis: {
    title: "時刻",
    gridlines: {
      count: -1,
      units: {
        days: {format: ['MMM dd']},
        hours: {format: ['HH:mm']},
      }
    },
  },
};


export const GraphElement: React.FC = () => {
  const [winOdds, setWinOdds] = React.useState<WinOdds[]>([]);

  const fetchWinOdds = () => {
    getWinOdds().then((res) => {
      if (res.success) setWinOdds(res.result);
    });
  };

  React.useEffect(() => {
    fetchWinOdds();
  }, []);

  return (
    <>
      <Chart
        chartType="LineChart"
        width="100%"
        height="400px"
        data={data}
        options={options}
      />
    </>
  );
};
