import * as React from "react";
import { Chart } from "react-google-charts";
import { getWinOdds, getPlaceOdds, getQuinellaOdds, getWideOdds } from "../../api/jra/_oddsApiClient";
import { getHorses, Horse } from "../../api/jra/_horsesApiClient";

const options = {
  chartArea: {
    top: 100,
    left: 100,
    right: 100,
    bottom: 100
  },
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


const Toggle = () => {
  return {
    win: false,
    place: false,
    quinella: 0,
    wide: 0,
  };
};

export const GraphElement: React.FC<Props> = ({ raceId }) => {
  const [googleChartData, setGoogleChartData] = React.useState<any[][]>([[]]);
  const [toggle, setToggle] = React.useState(Toggle);
  const [horses, setHorses] = React.useState<Horse[]>([]);

  const fetchWinOdds = React.useCallback(() => {
    getWinOdds(raceId).then((res) => {
      setGoogleChartData((res));
    });
  }, []);

  const fetchPlaceOdds = React.useCallback(() => {
    getPlaceOdds(raceId).then((res) => {
      setGoogleChartData((res));
    });
  }, []);

  const fetchQuinellaOdds = React.useCallback((horseNumber) => {
    getQuinellaOdds(raceId, horseNumber).then((res) => {
      setGoogleChartData((res));
    });
  }, []);

  const fetchWideOdds = React.useCallback((horseNumber) => {
    getWideOdds(raceId, horseNumber).then((res) => {
      setGoogleChartData((res));
    });
  }, []);

  const fetch = () => {
    if (toggle.win) {
      fetchWinOdds()
    } else if (toggle.place) {
      fetchPlaceOdds();
    } else if (toggle.quinella !== 0) {
      fetchQuinellaOdds(toggle.quinella);
    } else if (toggle.wide !== 0) {
      fetchWideOdds(toggle.wide);
    } else{
    }
  };

  React.useEffect(() => {
    fetch();
  }, [toggle]);

  React.useEffect(() => {
    setToggle({ ...Toggle(), win: true });
    fetch();
    getHorses(raceId).then((res) => {
      setHorses(res);
    });
  }, []);

  return (
    <>
      <div className="row">
        <div className="col-sm-2">
          <div className="mt-4">
            <div className="list-group">
              <button
                onClick={ () => setToggle({ ...Toggle(), win: true }) }
                className={ `list-group-item list-group-item-action p-3 ${ toggle.win ? "active" : "" }` }
                aria-current={ toggle.win }
              >
                単勝
              </button>
            </div>
            <div className="list-group mt-2">
              <button
                onClick={ () => setToggle({ ...Toggle(), place: true }) }
                className={ `list-group-item list-group-item-action p-3 ${ toggle.place ? "active" : "" }` }
                aria-current={ toggle.place }
              >
                複勝
              </button>
            </div>
            <div className="accordion mt-2" id="accordion-quinella">
              <div className="accordion-item">
                <h2 className="accordion-header" id="accordion-quinella-heading">
                  <button className="accordion-button collapsed p-3" type="button" data-bs-toggle="collapse"
                          data-bs-target="#accordion-quinella-body" aria-expanded="false" aria-controls="accordion-quinella-body">
                    馬連
                  </button>
                </h2>
                <div id="accordion-quinella-body" className="accordion-collapse collapse" aria-labelledby="accordion-quinella-heading"
                     data-bs-parent="#accordion-quinella">
                  <div className="list-group list-group-flush">
                    {
                      horses.map((horse) => {
                        return (
                          <>
                            <button
                              onClick={ () => setToggle({ ...Toggle(), quinella: horse.number }) }
                              className={ `list-group-item list-group-item-action ${ toggle.quinella === horse.number ? "active" : "" }` }
                              aria-current={ toggle.quinella === horse.number }
                              key={ horse.number }
                            >
                              {horse.number} {horse.name}
                            </button>
                          </>
                        );
                      })
                    }
                  </div>
                </div>
              </div>
            </div>
            <div className="accordion mt-2" id="accordion-wide">
              <div className="accordion-item">
                <h2 className="accordion-header" id="accordion-wide-heading">
                  <button className="accordion-button collapsed p-3" type="button" data-bs-toggle="collapse"
                          data-bs-target="#accordion-wide-body" aria-expanded="false" aria-controls="accordion-wide-body">
                    ワイド
                  </button>
                </h2>
                <div id="accordion-wide-body" className="accordion-collapse collapse" aria-labelledby="accordion-wide-heading"
                     data-bs-parent="#accordion-wide">
                  <div className="list-group list-group-flush">
                    {
                      horses.map((horse) => {
                        return (
                          <>
                            <button
                              onClick={ () => setToggle({ ...Toggle(), wide: horse.number }) }
                              className={ `list-group-item list-group-item-action ${ toggle.wide === horse.number ? "active" : "" }` }
                              aria-current={ toggle.wide === horse.number }
                              key={ horse.number }
                            >
                              {horse.number} {horse.name}
                            </button>
                          </>
                        );
                      })
                    }
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-10">
          <Chart
            chartType="LineChart"
            width="100%"
            height="640px"
            data={ googleChartData }
            options={ options }
          />
        </div>
      </div>
    </>
  );
};
