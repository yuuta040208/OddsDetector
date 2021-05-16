import * as React from "react";
import { Chart } from "react-google-charts";
import { getWinOdds, getPlaceOdds } from "../api/_oddsApiClient";
import { getHorses } from "../api/_horsesApiClient";

const options = {
  curveType: "none",
  legend: { position: "top", maxLines: 5 },
  pointSize: 5,
  vAxis: {
    scaleType: "log"
  },
  hAxis: {
    gridlines: {
      units: {
        hours: {
          format: ["HH:mm"]
        },
      }
    },
  },
  animation:{
    duration: 200,
    easing: "out"
  },
};

export type Props = {
  raceId: string
};

export const GraphElement: React.FC<Props> = ({ raceId }) => {
  const [googleChartData, setGoogleChartData] = React.useState<any[][]>([]);
  const [isWin, setIsWin] = React.useState(true);

  const fetchWinOdds = React.useCallback(() => {
    getWinOdds(raceId).then((res) => {
      console.log(res);
      setGoogleChartData((res));
    });
  }, []);

  const fetchPlaceOdds = React.useCallback(() => {
    getPlaceOdds(raceId).then((res) => {
      console.log(res);
      setGoogleChartData((res));
    });
  }, []);

  React.useEffect(() => {
    isWin ? fetchWinOdds() : fetchPlaceOdds();
  }, [isWin]);

  React.useEffect(() => {
    fetchWinOdds();
    getHorses(raceId).then((res) => {
      console.log(res);
    });
  }, []);

  return (
    <>
      <div className="row">
        <div className="col-sm-2">
          <div className="mt-4">
            <div className="list-group">
              <button
                onClick={ () => setIsWin(true) }
                className={ `list-group-item list-group-item-action ${ isWin ? "active" : "" }` }
                aria-current={ isWin }
              >
                単勝
              </button>
            </div>
            <div className="list-group mt-2">
              <button
                onClick={ () => setIsWin(false) }
                className={ `list-group-item list-group-item-action ${ !isWin ? "active" : "" }` }
                aria-current={ !isWin }
              >
                複勝
              </button>
            </div>
            <div className="list-group mt-2">
              <button className="list-group-item list-group-item-action">
                馬連（準備中）
              </button>
            </div>
            <div className="list-group mt-2">
              <button className="list-group-item list-group-item-action">
                ワイド（準備中）
              </button>
            </div>
          </div>
        </div>
        <div className="col-sm-10">
          <Chart
            chartType="LineChart"
            width="100%"
            height="800px"
            data={ googleChartData }
            options={ options }
          />
        </div>
      </div>
    </>
  );
};
