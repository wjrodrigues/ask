import { apiRegistration } from "@/lib/http";

interface ISignupForm {
  first_name: string;
  last_name: string;
  email: string;
  password: string;
}

interface ISignupResponse {
  message?: string[] | object[];
}

const signup = async (form: ISignupForm) => {
  return (await apiRegistration()
    .post("/users", form)
    .then(() => ({}))
    .catch((error) => error.response.data)) as ISignupResponse;
};

export { signup };
