import axios from "axios";
const env = import.meta.env;

const simpleHttp = () => {
  return axios.create({
    timeout: 1000,
  });
};

const apiRegistration = () => {
  return axios.create({
    baseURL: env.VITE_API_REGISTRATION_URL,
    timeout: 1000,
    headers: { "Accept-Language": "pt-BR" },
  });
};

export { simpleHttp, apiRegistration };
