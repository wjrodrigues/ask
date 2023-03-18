import { session } from "@/service/auth";
import axios from "axios";
const env = import.meta.env;

const simpleHttp = (params = { timeout: 1000 }) => {
  return axios.create(params);
};

const apiRegistration = () => {
  return axios.create({
    baseURL: env.VITE_API_REGISTRATION_URL,
    timeout: 1000,
    headers: { "Accept-Language": "pt-BR" },
  });
};

const authHttp = () => {
  const axiosInstance = axios.create({
    timeout: 1000,
    headers: {
      "Accept-Language": "pt-BR",
      Authorization: session(),
    },
    baseURL: env.VITE_API_REGISTRATION_URL,
  });

  axiosInstance.interceptors.response.use(
    (response) => response,
    (error) => {
      if ([401, 404, 500].includes(error.response.status)) {
        window.location.href = "/";
      } else {
        throw error;
      }
    }
  );

  return axiosInstance;
};

export { simpleHttp, apiRegistration, authHttp };
