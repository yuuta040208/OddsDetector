import axios, { AxiosError } from "axios";

const API_PATH = "/api/v1/races";
const ODDS_WIN_ENDPOINT = "odds/win/";

type Success<T> = {
  success: true;
  result: T;
};
type Failure<T> = {
  success: false;
  result: T;
};
type Result<T, U> = Success<T> | Failure<U>;

const success = <T>(data: T): Success<T> => {
  return {
    success: true,
    result: data,
  };
};
const failure = <T>(data: T): Failure<T> => {
  return {
    success: false,
    result: data,
  };
};

export type Odds = {
  crawled_at: string,
  horses: Horse[]
};
export type Horse = {
  number: number,
  name: string,
  odds: number[]
}

type ApiError = {
  message: string;
};

const raceId = () => {
  return location.href.split('/').filter(function(e){return e}).slice(-1)[0];
};

export const getWinOdds = async (): Promise<Result<Odds[], ApiError>> => {
  return axios
    .get<Odds[]>(`${API_PATH}/${raceId()}/${ODDS_WIN_ENDPOINT}`, { headers: { ContentType: 'application/json', Accept: 'application/json' } })
    .then((res) => {
      return Object.keys(res.data).length === 0
        ? success([])
        : success(res.data);
    })
    .catch((e: AxiosError<ApiError>) => {
      return e.response !== undefined
        ? failure(e.response.data)
        : failure({ message: "Something went wrong." });
    });
};
