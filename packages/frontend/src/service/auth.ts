import { apiRegistration } from "@/lib/http";

interface ResponseAuth {
  access_token: string;
  expires_in: number;
  refresh_expires_in: number;
  refresh_token: string;
  token_type: string;
  session_state: string;
}

const auth = (username: string, password: string): Promise<boolean> => {
  return apiRegistration()
    .post("users/auth", {
      password,
      username,
    })
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
