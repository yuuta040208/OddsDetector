import * as React from "react";
import { Chart } from "react-google-charts";
import { getWinOdds, Odds } from "../api/_oddsApiClient";

const options = {
  curveType: "none",
  legend: { position: "top", maxLines: 5 },
  pointSize: 5,
  vAxis: {
    title: "オッズ",
    scaleType: "log"
  },
  hAxis: {
    title: "時刻",
    gridlines: {
      count: 5,
      units: {
        hours: {format: ["HH:mm"]},
      }
    },
  },
};

export const GraphElement: React.FC = () => {
  const [googleChartData, setGoogleChartData] = React.useState<any[][]>([]);

  const convertToGoogleChart = (data: Odds[]) => {
    let header: any[] = ["crawled_at"];
    data[0].horses.forEach(horse => {
      header.push(`${horse.number} ${horse.name}`);
    });

    let body: any[] = data.map(elem => {
      let body: any[] = [new Date(elem.crawled_at)];
      elem.horses.forEach(horse => body.push(horse.odds));
      return body;
    });

    let convertedData = [];
    convertedData.push(header);
    body.forEach(elem => convertedData.push(elem));

    return convertedData;
  };

  const fetchWinOdds = () => {
    getWinOdds().then((res) => {
      if (res.success) {
        console.log(res.result);
        setGoogleChartData(convertToGoogleChart(res.result));
      }
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
        height="800px"
        data={ googleChartData }
        options={ options }
      />
    </>
  );
};
