import { get } from "../_apiClient";

const API_PATH = "/api/v1/jra/races";
const HORSES_ENDPOINT = "horses/";

export type Horse = {
  number: number,
  name: string
};

type ApiHorse = {
  horse_id: number,
  bracket_number: number,
  horse_number: number,
  horse_name: string
}

export const getHorses = async (raceId: string): Promise<Horse[]> => {
  const horses = await get<ApiHorse[]>(getHorsesUrl(raceId));
  if (horses.success) {
    return horses.result.map(horse => {
      return { number: horse.horse_number, name: horse.horse_name }
    });
  } else {
    return [];
  }
};

const getHorsesUrl = (raceId: string) => {
  return `${API_PATH}/${raceId}/${HORSES_ENDPOINT}`;
};