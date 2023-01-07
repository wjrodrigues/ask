import { simpleHttp } from "@/lib/http";
const env = import.meta.env;

const AUTH_URL = `${env.VITE_AUTH_URL}/realms/${env.VITE_AUTH_REALM}/protocol/openid-connect/token`;

interface ResponseAuth {
  access_token: string;
  expires_in: number;
  refresh_expires_in: number;
  refresh_token: string;
  token_type: string;
  session_state: string;
}

const auth = (username: string, password: string): Promise<boolean> => {
  return simpleHttp()
    .post(
      AUTH_URL,
      new URLSearchParams({
        grant_type: "password",
        client_secret: env.VITE_AUTH_CLIENT_SECRET,
        client_id: env.VITE_AUTH_CLIENT_ID,
        password,
        username,
      }),
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      }
    )
    .then((response) => saveToken(response.data as ResponseAuth))
    .catch(() => false);
};

const saveToken = (data: ResponseAuth): boolean => {
  sessionStorage.setItem("access_token", data.access_token);
  sessionStorage.setItem("expires_in", data.expires_in.toString());
  sessionStorage.setItem("refresh_token", data.refresh_token);
  sessionStorage.setItem("token_type", data.token_type);
  sessionStorage.setItem("session_state", data.session_state);
  sessionStorage.setItem(
    "refresh_expires_in",
    data.refresh_expires_in.toString()
  );

  return true;
};

export { auth };
