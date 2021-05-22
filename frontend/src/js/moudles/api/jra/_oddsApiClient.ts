import {get} from "../_apiClient";

const API_PATH = "/api/v1/jra/races";
const ODDS_WIN_ENDPOINT = "odds/win/";
const ODDS_PLACE_ENDPOINT = "odds/place/";
const ODDS_QUINELLA_ENDPOINT = "odds/quinella/";
const ODDS_WIDE_ENDPOINT = "odds/wide/";

type ApiOdds = {
  crawled_at: string,
  horses: ApiOddsHorse[]
};

type ApiOddsHorse = {
  number: number,
  name: string,
  odds: number[]
}

export const getWinOdds = async (raceId: string): Promise<any[]> => {
  const winOdds = await get<ApiOdds[]>(getWinOddsUrl(raceId));
  if (winOdds.success) {
    return convertToGoogleChart(winOdds.result);
  } else {
    return [];
  }
};

export const getPlaceOdds = async (raceId: string): Promise<any[]> => {
  const placeOdds = await get<ApiOdds[]>(getPlaceOddsUrl(raceId));
  if (placeOdds.success) {
    return convertToGoogleChart(placeOdds.result);
  } else {
    return [];
  }
};

export const getQuinellaOdds = async (raceId: string, horseNumber: number): Promise<any[]> => {
  const quinellaOdds = await get<ApiOdds[]>(getQuinellaOddsUrl(raceId, horseNumber));
  if (quinellaOdds.success) {
    return convertToGoogleChart(quinellaOdds.result);
  } else {
    return [];
  }
};

export const getWideOdds = async (raceId: string, horseNumber: number): Promise<any[]> => {
  const wideOdds = await get<ApiOdds[]>(getWideOddsUrl(raceId, horseNumber));
  if (wideOdds.success) {
    return convertToGoogleChart(wideOdds.result);
  } else {
    return [];
  }
};

const getWinOddsUrl = (raceId: string) => {
  return `${API_PATH}/${raceId}/${ODDS_WIN_ENDPOINT}`;
};

const getPlaceOddsUrl = (raceId: string) => {
  return `${API_PATH}/${raceId}/${ODDS_PLACE_ENDPOINT}`;
};

const getQuinellaOddsUrl = (raceId: string, horseNumber: number) => {
  return `${API_PATH}/${raceId}/${ODDS_QUINELLA_ENDPOINT}${horseNumber}`;
};

const getWideOddsUrl = (raceId: string, horseNumber: number) => {
  return `${API_PATH}/${raceId}/${ODDS_WIDE_ENDPOINT}${horseNumber}`;
};

const convertToGoogleChart = (data: ApiOdds[]): any[] => {
  const header: any[] = ["crawled_at"];
  data[0].horses.forEach(horse => {
    header.push(`${horse.number} ${horse.name}`);
  });

  const body: any[] = data.map(elem => {
    let body: any[] = [new Date(elem.crawled_at)];
    elem.horses.forEach(horse => body.push(horse.odds));
    return body;
  });

  const convertedArray = [];
  convertedArray.push(header);
  body.forEach(elem => convertedArray.push(elem));

  return convertedArray;
};
