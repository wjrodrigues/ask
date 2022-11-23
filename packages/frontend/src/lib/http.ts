import axios from "axios";

const simpleHttp = () => {
  return axios.create({
    timeout: 1000,
  });
};

const apiRegistration = () => {
  return axios.create({
    baseURL: process.env.VITE_API_REGISTRATION_URL,
    timeout: 1000,
  });
};

export { simpleHttp, apiRegistration };
