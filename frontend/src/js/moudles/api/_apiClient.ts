import axios, { AxiosError } from "axios";

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

export type ApiError = {
  message: string;
};

export const get = async <T>(url: string): Promise<Result<T, ApiError>> => {
  return axios
    .get(url, { headers: { ContentType: 'application/json', Accept: 'application/json' } })
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
