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
  localStorage.setItem("access_token", data.access_token);
  localStorage.setItem("expires_in", data.expires_in.toString());
  localStorage.setItem("refresh_token", data.refresh_token);
  localStorage.setItem("token_type", data.token_type);
  localStorage.setItem("session_state", data.session_state);
  localStorage.setItem(
    "refresh_expires_in",
    data.refresh_expires_in.toString()
  );

  return true;
};

const session = (key = "access_token") => localStorage.getItem(key);

export { auth, session };
